import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankMiniPrintOutPage extends StatefulWidget {
  const BankMiniPrintOutPage({super.key});

  @override
  State<BankMiniPrintOutPage> createState() => _BankMiniPrintOutPageState();
}

class _BankMiniPrintOutPageState extends State<BankMiniPrintOutPage> {
  // --- STATE PENGENDALI TAMPILAN ---
  bool _showPreview = false;

  final _formKey = GlobalKey<FormState>();

  // Controllers Form
  final _customerCtrl = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _endDateCtrl = TextEditingController();
  final _rowNumberCtrl = TextEditingController();

  String? _selectedCustomerId;
  String _selectedPagePrint = 'Select Option';

  // Dummy Data Nasabah
  final List<Map<String, String>> _customers = [
    {"id": "21049001", "name": "A. RAHMAN MULYA FAZIZ"},
    {"id": "21049002", "name": "ADHITYA PUTRA LIE WINATA"},
    {"id": "21049003", "name": "AHMAD SEPTIAN"},
    {"id": "21049004", "name": "BUDI SANTOSO"},
    {"id": "21049005", "name": "RINA NOSE"},
    {"id": "21049006", "name": "SITI AMINAH"},
  ];

  // Dummy Data Transaksi (Kosong untuk simulasi "No Data Found")
  final List<Map<String, dynamic>> _dummyPrintData = [];

  @override
  void dispose() {
    _customerCtrl.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    _rowNumberCtrl.dispose();
    super.dispose();
  }

  // --- MODAL PILIH NASABAH ---
  void _showCustomerSelector() {
    List<Map<String, String>> filteredCustomers = List.from(_customers);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.75,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                    const SizedBox(height: 20),
                    const Text("Select Bank Customer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2E3192))),
                    const SizedBox(height: 15),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Search name or ID...",
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                      onChanged: (query) {
                        setModalState(() {
                          filteredCustomers = _customers.where((c) => c['name']!.toLowerCase().contains(query.toLowerCase()) || c['id']!.contains(query)).toList();
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredCustomers.length,
                        itemBuilder: (context, index) {
                          final customer = filteredCustomers[index];
                          return ListTile(
                            leading: CircleAvatar(backgroundColor: const Color(0xFF2E3192).withOpacity(0.1), child: const Icon(Icons.person, color: Color(0xFF2E3192))),
                            title: Text(customer['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("ID: ${customer['id']}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            onTap: () {
                              setState(() {
                                _selectedCustomerId = customer['id'];
                                _customerCtrl.text = "[${customer['id']}] ${customer['name']}";
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tema Warna Bank Mini Utama
    const Color bankMiniBaseDark = Color(0xFF2E3192);
    const Color bankMiniBaseLight = Color(0xFF662D91);
    const Color bankMiniAccent = Color(0xFFF06292);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      // LOGIKA UTAMA: Tampilkan Form atau Tampilkan Preview
      body: _showPreview
          ? _buildPreviewScreen(bankMiniBaseDark)
          : _buildFilterScreen(bankMiniBaseDark, bankMiniBaseLight, bankMiniAccent),
    );
  }

  // =========================================================================
  // 1. TAMPILAN FILTER FORM (Tampilan Awal)
  // =========================================================================
  Widget _buildFilterScreen(Color darkTheme, Color lightTheme, Color accentTheme) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120, floating: false, pinned: true, backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [darkTheme, lightTheme]),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              boxShadow: [BoxShadow(color: accentTheme.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Stack(
              children: [
                Positioned(top: -20, right: -20, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: accentTheme.withOpacity(0.2)))),
                const FlexibleSpaceBar(titlePadding: EdgeInsets.only(left: 60, bottom: 20), title: Text("Bank Mini Print Out", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white))),
              ],
            ),
          ),
          leading: Container(
            margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: darkTheme.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Icon(Icons.print_rounded, color: darkTheme), const SizedBox(width: 10), const Text("Print Configuration", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)))]),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider()),

                    _buildLabel("Bank Customer *"),
                    InkWell(
                      onTap: _showCustomerSelector,
                      child: IgnorePointer(child: _buildTextField(_customerCtrl, Icons.person_search_rounded, "Select Customer", suffixIcon: Icons.keyboard_arrow_down_rounded)),
                    ),

                    Row(
                      children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Start Date *"), _buildDateField(_startDateCtrl, "Start Date")])),
                        const SizedBox(width: 15),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("End Date *"), _buildDateField(_endDateCtrl, "End Date")])),
                      ],
                    ),

                    _buildLabel("Page Print *"),
                    _buildDropdown(),

                    _buildLabel("Row Number"),
                    _buildTextField(_rowNumberCtrl, Icons.format_list_numbered_rounded, "e.g. 10", keyboardType: TextInputType.number),

                    const SizedBox(height: 35),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_customerCtrl.text.isEmpty || _startDateCtrl.text.isEmpty || _endDateCtrl.text.isEmpty || _selectedPagePrint == 'Select Option') {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all required fields (*)"), backgroundColor: Colors.red));
                            return;
                          }
                          // ✅ Pindah ke mode Preview
                          setState(() {
                            _showPreview = true;
                          });
                        },
                        icon: const Icon(Icons.print_rounded, color: Colors.white),
                        label: const Text("Generate Preview", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        style: ElevatedButton.styleFrom(backgroundColor: darkTheme, padding: const EdgeInsets.symmetric(vertical: 16), elevation: 4, shadowColor: darkTheme.withOpacity(0.4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 2. TAMPILAN PREVIEW REPORTS (Sesuai web: Tombol biru & silang merah)
  // =========================================================================
  Widget _buildPreviewScreen(Color darkTheme) {
    return Column(
      children: [
        // Appbar khusus Preview
        AppBar(
          backgroundColor: darkTheme, // Warna biru sesuai gambar
          elevation: 0,
          title: const Text("Preview Reports", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          automaticallyImplyLeading: false, // Matikan back button panah kiri
          actions: [
            // Tombol Tutup Merah (X)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(8)),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                onPressed: () {
                  // ✅ Kembali ke form filter
                  setState(() {
                    _showPreview = false;
                  });
                },
              ),
            ),
          ],
        ),

        // Konten Preview
        Expanded(
          child: Column(
            children: [
              // Area Tombol Print Biru (Kiri Atas)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Sending to printer..."), backgroundColor: Colors.blue)
                      );
                    },
                    icon: const Icon(Icons.print_rounded, color: Colors.white, size: 16),
                    label: const Text("Print", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600, // Tombol biru muda
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
              ),

              // Garis pemisah abu-abu
              Container(height: 1, color: Colors.grey.shade200),

              // Area Data (Kosong / Ada Data)
              Expanded(
                child: Center(
                  child: _dummyPrintData.isEmpty
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.layers_clear_rounded, size: 60, color: Colors.grey.shade300),
                      const SizedBox(height: 15),
                      Text("No Data Found", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontSize: 16)),
                      const SizedBox(height: 5),
                      Text("No transactions match your criteria.", style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                    ],
                  )
                      : const Text("Data will appear here..."), // Tempat jika data dummy diisi
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  // --- Helper UI Widgets Khusus Form ---
  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8, top: 10), child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)));

  Widget _buildTextField(TextEditingController controller, IconData icon, String hint, {TextInputType keyboardType = TextInputType.text, IconData? suffixIcon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(controller: controller, keyboardType: keyboardType, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87), decoration: InputDecoration(prefixIcon: Icon(icon, color: const Color(0xFF662D91).withOpacity(0.6), size: 20), suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey.shade500) : null, hintText: hint, hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.normal), filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15)), borderSide: BorderSide(color: Color(0xFF662D91), width: 1.5)))),
    );
  }

  Widget _buildDateField(TextEditingController controller, String hint) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100), builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF2E3192))), child: child!));
        if (pickedDate != null) setState(() => controller.text = DateFormat('yyyy-MM-dd').format(pickedDate));
      },
      child: IgnorePointer(child: _buildTextField(controller, Icons.calendar_today_rounded, hint)),
    );
  }

  Widget _buildDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.symmetric(horizontal: 15), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPagePrint, isExpanded: true, icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: <String>['Select Option', 'Page 1', 'Page 2', 'Page 3', 'All Pages'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(color: value == 'Select Option' ? Colors.grey.shade400 : Colors.black87, fontSize: 14, fontWeight: FontWeight.w600)))).toList(),
          onChanged: (newValue) => setState(() => _selectedPagePrint = newValue!),
        ),
      ),
    );
  }
}