import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  final _customerCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _spelledAmountCtrl = TextEditingController();
  final _remarkCtrl = TextEditingController();

  String? _selectedCustomerId;
  String _selectedTransactionType = 'Select Option';

  final List<Map<String, String>> _customers = [
    {"id": "21049001", "name": "A. RAHMAN MULYA FAZIZ"},
    {"id": "21049002", "name": "ADHITYA PUTRA LIE WINATA"},
    {"id": "21049003", "name": "AHMAD SEPTIAN"},
    {"id": "21049004", "name": "BUDI SANTOSO"},
    {"id": "21049005", "name": "RINA NOSE"},
    {"id": "21049006", "name": "SITI AMINAH"},
  ];

  void _updateSpelledAmount(String value) {
    if (value.isEmpty) {
      _spelledAmountCtrl.text = "";
      return;
    }

    String cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanValue.isEmpty) return;

    int number = int.tryParse(cleanValue) ?? 0;
    setState(() {
      _spelledAmountCtrl.text = "${_terbilang(number)} Rupiah";
    });
  }

  String _terbilang(int number) {
    List<String> angka = ["", "Satu", "Dua", "Tiga", "Empat", "Lima", "Enam", "Tujuh", "Delapan", "Sembilan", "Sepuluh", "Sebelas"];
    if (number < 12) return angka[number];
    if (number < 20) return "${angka[number - 10]} Belas";
    if (number < 100) return "${angka[number ~/ 10]} Puluh ${_terbilang(number % 10)}".trim();
    if (number < 200) return "Seratus ${_terbilang(number - 100)}".trim();
    if (number < 1000) return "${angka[number ~/ 100]} Ratus ${_terbilang(number % 100)}".trim();
    if (number < 2000) return "Seribu ${_terbilang(number - 1000)}".trim();
    if (number < 1000000) return "${_terbilang(number ~/ 1000)} Ribu ${_terbilang(number % 1000)}".trim();
    if (number < 1000000000) return "${_terbilang(number ~/ 1000000)} Juta ${_terbilang(number % 1000000)}".trim();
    return "Nominal terlalu besar";
  }

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
                          filteredCustomers = _customers.where((c) =>
                          c['name']!.toLowerCase().contains(query.toLowerCase()) ||
                              c['id']!.contains(query)
                          ).toList();
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
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF2E3192).withOpacity(0.1),
                              child: const Icon(Icons.person, color: Color(0xFF2E3192)),
                            ),
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
    const Color bankMiniBaseDark = Color(0xFF2E3192);
    const Color bankMiniBaseLight = Color(0xFF662D91);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [bankMiniBaseDark, bankMiniBaseLight],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Add Transaction",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(color: bankMiniBaseDark.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.receipt_long_rounded, color: bankMiniBaseDark),
                          SizedBox(width: 10),
                          Text(
                            "Transaction Details",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider()),

                      _buildLabel("Bank Customer *"),
                      InkWell(
                        onTap: _showCustomerSelector,
                        child: IgnorePointer(
                          child: _buildTextField(_customerCtrl, Icons.person_search_rounded, "Select Customer", suffixIcon: Icons.keyboard_arrow_down_rounded),
                        ),
                      ),

                      _buildLabel("Transaction Type *"),
                      _buildTypeDropdown(),

                      _buildLabel("Amount *"),
                      TextFormField(
                        controller: _amountCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        onChanged: _updateSpelledAmount,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.attach_money_rounded, color: bankMiniBaseLight, size: 22),
                          hintText: "0",
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: bankMiniBaseLight, width: 1.5)),
                        ),
                      ),

                      _buildLabel("Spelled Amount *"),
                      _buildTextField(_spelledAmountCtrl, Icons.spellcheck_rounded, "Auto generated amount in words", isReadOnly: true, maxLines: 2),

                      _buildLabel("Remark *"),
                      _buildTextField(_remarkCtrl, Icons.notes_rounded, "Enter transaction remark...", maxLines: 3),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_customerCtrl.text.isEmpty || _selectedTransactionType == 'Select Option' || _amountCtrl.text.isEmpty || _remarkCtrl.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all required fields (*)"), backgroundColor: Colors.red));
                                  return;
                                }

                                Map<String, dynamic> newTx = {
                                  "id": "BMTR${DateTime.now().millisecondsSinceEpoch}",
                                  "name": _customerCtrl.text.split('] ')[1],
                                  "type": _selectedTransactionType,
                                  "date": DateFormat('dd MMM yyyy HH:mm:ss').format(DateTime.now()),
                                  "amount": int.parse(_amountCtrl.text),
                                  "remark": _remarkCtrl.text,
                                  "by": "Admin App"
                                };

                                Navigator.pop(context, newTx);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: bankMiniBaseDark,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                elevation: 4,
                                shadowColor: bankMiniBaseDark.withOpacity(0.4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: const Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 10),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hint, {bool isReadOnly = false, int maxLines = 1, IconData? suffixIcon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        maxLines: maxLines,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isReadOnly ? Colors.grey.shade700 : Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: isReadOnly ? Colors.grey.shade400 : const Color(0xFF662D91).withOpacity(0.6), size: 20),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey.shade500) : null,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.normal),
          filled: true,
          fillColor: isReadOnly ? Colors.grey.shade200 : Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          focusedBorder: isReadOnly
              ? OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
              : const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15)), borderSide: BorderSide(color: Color(0xFF662D91), width: 1.5)),
        ),
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTransactionType,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: <String>['Select Option', 'Debet', 'Kredit'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  if (value != 'Select Option')
                    Icon(value == 'Debet' ? Icons.arrow_downward : Icons.arrow_upward,
                        size: 16, color: value == 'Debet' ? Colors.green : Colors.red),
                  if (value != 'Select Option') const SizedBox(width: 8),
                  Text(value, style: TextStyle(color: value == 'Select Option' ? Colors.grey.shade400 : Colors.black87, fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() { _selectedTransactionType = newValue!; });
          },
        ),
      ),
    );
  }
}