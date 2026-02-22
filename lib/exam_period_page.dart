import 'package:flutter/material.dart';

class ExamPeriodPage extends StatefulWidget {
  const ExamPeriodPage({super.key});

  @override
  State<ExamPeriodPage> createState() => _ExamPeriodPageState();
}

class _ExamPeriodPageState extends State<ExamPeriodPage> {
  // Dummy Data berdasarkan gambar referensi web
  final List<Map<String, dynamic>> _examPeriods = [
    {
      "id": "EXPER2025111900000002",
      "name": "ASAS GANJIL 2526",
      "startDate": "02-December-2025",
      "endDate": "12-December-2025",
      "yearCode": "2025",
    },
    {
      "id": "EXPER2025092200000001",
      "name": "Ujian Online",
      "startDate": "23-September-2025",
      "endDate": "23-September-2025",
      "yearCode": "2025",
    },
    {
      "id": "EXPER2025091300000002",
      "name": "ASTS GANJIL 2526",
      "startDate": "29-September-2025",
      "endDate": "16-October-2025",
      "yearCode": "2025",
    },
    {
      "id": "EXPER2025070500000001",
      "name": "5 Juli 2025 Malam",
      "startDate": "03-July-2025",
      "endDate": "31-December-2025",
      "yearCode": "2024",
    },
    {
      "id": "EXAMPR-20250410001",
      "name": "Test Farhan 2025",
      "startDate": "01-April-2025",
      "endDate": "30-April-2025",
      "yearCode": "2024",
    },
  ];

  List<Map<String, dynamic>> _filteredPeriods = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredPeriods = _examPeriods;
  }

  void _filterPeriods(String query) {
    setState(() {
      _filteredPeriods = _examPeriods
          .where((p) =>
      p['name']!.toLowerCase().contains(query.toLowerCase()) ||
          p['id']!.toLowerCase().contains(query.toLowerCase()) ||
          p['yearCode']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // --- HEADER APP BAR ---
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  // Menggunakan warna ungu & pink agar berbeda dari Exam Management
                  colors: [
                    Colors.purple.shade500,
                    Colors.deepPurple.shade700,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 60, bottom: 18),
                title: const Text(
                  "Exam Period",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                background: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // --- FILTER, SEARCH & ADD BUTTON ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterPeriods,
                            decoration: InputDecoration(
                              icon: Icon(Icons.search_rounded, color: Colors.purple.shade400),
                              hintText: "Search periods...",
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Clear Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _filterPeriods('');
                          },
                          icon: Icon(Icons.filter_alt_off_rounded, color: Colors.grey.shade600),
                          tooltip: "Clear Filter",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Add Exam Period Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final newPeriod = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddExamPeriodPage(),
                          ),
                        );
                        if (newPeriod != null) {
                          setState(() {
                            _examPeriods.insert(0, newPeriod);
                            _filteredPeriods = _examPeriods;
                          });
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
                      label: const Text(
                        "Add Exam Period",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        shadowColor: Colors.deepPurple.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- LIST OF PERIOD CARDS ---
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            sliver: _filteredPeriods.isEmpty
                ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.calendar_view_month_rounded, size: 60, color: Colors.grey.shade300),
                    const SizedBox(height: 15),
                    Text(
                      "No Exam Period Found",
                      style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _buildPeriodCard(_filteredPeriods[index]);
                },
                childCount: _filteredPeriods.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET CARD EXAM PERIOD ---
  Widget _buildPeriodCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- CARD HEADER ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.purple.shade50.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ID Badge
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple.shade100),
                    ),
                    child: Text(
                      data['id'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Year Code Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag_rounded, size: 14, color: Colors.orange.shade700),
                      const SizedBox(width: 4),
                      Text(
                        data['yearCode'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- CARD BODY ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period Name
                Text(
                  data['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 20),

                // Info Tanggal (Start & End)
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      // Start Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "START DATE",
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.play_circle_fill_rounded, size: 16, color: Colors.green.shade500),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    data['startDate'],
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Arrow Icon di tengah
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward_rounded, color: Colors.grey.shade400, size: 20),
                      ),
                      // End Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "END DATE",
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.stop_circle_rounded, size: 16, color: Colors.red.shade400),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    data['endDate'],
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- CARD FOOTER (ACTION) ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Period Data",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Tombol Edit
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditExamPeriodPage(periodData: data),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.edit_rounded, color: Colors.purple.shade600, size: 20),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ============================================================================
// HALAMAN BARU: ADD EXAM PERIOD
// ============================================================================

class AddExamPeriodPage extends StatefulWidget {
  const AddExamPeriodPage({super.key});

  @override
  State<AddExamPeriodPage> createState() => _AddExamPeriodPageState();
}

class _AddExamPeriodPageState extends State<AddExamPeriodPage> {
  // Controllers untuk input form
  final _periodNameCtrl = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _endDateCtrl = TextEditingController();
  final _periodYearCtrl = TextEditingController();

  @override
  void dispose() {
    _periodNameCtrl.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    _periodYearCtrl.dispose();
    super.dispose();
  }

  // --- FUNGSI UNTUK MEMUNCULKAN KALENDER (DATE PICKER) ---
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        // Tema kalender disesuaikan dengan warna halaman Exam Period (Ungu)
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple.shade600, // Warna Header Kalender
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple.shade600,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        // Format tanggal: DD-Bulan-YYYY (Sesuai dengan referensi dummy data)
        const List<String> monthNames = [
          "January", "February", "March", "April", "May", "June",
          "July", "August", "September", "October", "November", "December"
        ];
        String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}-${monthNames[pickedDate.month - 1]}-${pickedDate.year}";
        controller.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      // --- APP BAR ---
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade500, Colors.deepPurple.shade700],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Exam Period",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),

      // --- BODY SCROLL FORM ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100), // padding bawah untuk tombol floating
        child: Column(
          children: [
            // 1. SECTION: PERIOD DETAILS
            _buildSectionCard(
              title: "Period Details",
              icon: Icons.info_outline_rounded,
              iconColor: Colors.purple,
              children: [
                _buildReadOnlyField("Exam Period ID", "EXPER[YYYYMMDDXXXXXX]"), // Auto generated
                const SizedBox(height: 15),
                _buildInputField(
                  label: "Exam Period Name",
                  controller: _periodNameCtrl,
                  hint: "Enter period name (e.g. ASAS GANJIL 2526)",
                  icon: Icons.edit_note_rounded,
                  isRequired: true,
                ),
                const SizedBox(height: 15),
                _buildInputField(
                  label: "Period Year",
                  controller: _periodYearCtrl,
                  hint: "Input Period Year (e.g. 2025)",
                  icon: Icons.flag_rounded,
                  isRequired: true,
                  isNumber: true,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. SECTION: TIMELINE CONFIGURATION
            _buildSectionCard(
              title: "Timeline Configuration",
              icon: Icons.calendar_month_rounded,
              iconColor: Colors.orange,
              children: [
                // Start Date & End Date dibuat bersebelahan agar rapi
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        label: "Start Date",
                        controller: _startDateCtrl,
                        hint: "Select start date",
                        icon: Icons.play_circle_fill_rounded,
                        isRequired: true,
                        readOnly: true,
                        onTap: () => _selectDate(context, _startDateCtrl),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildInputField(
                        label: "End Date",
                        controller: _endDateCtrl,
                        hint: "Select end date",
                        icon: Icons.stop_circle_rounded,
                        isRequired: true,
                        readOnly: true,
                        onTap: () => _selectDate(context, _endDateCtrl),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

      // --- FLOATING ACTION BUTTON (SUBMIT & CANCEL) ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.grey.shade100,
                ),
                child: Text("Cancel", style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  // Validasi Form
                  if (_periodNameCtrl.text.isNotEmpty && _startDateCtrl.text.isNotEmpty && _endDateCtrl.text.isNotEmpty && _periodYearCtrl.text.isNotEmpty) {

                    // Bungkus data baru
                    final newPeriod = {
                      "id": "EXPER${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}",
                      "name": _periodNameCtrl.text,
                      "startDate": _startDateCtrl.text,
                      "endDate": _endDateCtrl.text,
                      "yearCode": _periodYearCtrl.text,
                    };

                    // Kirim data kembali ke halaman utama Exam Period
                    Navigator.pop(context, newPeriod);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Exam Period Added Successfully!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all required fields!"), backgroundColor: Colors.red),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildSectionCard({required String title, required IconData icon, required Color iconColor, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontFamily: 'Roboto'),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isRequired = false,
    bool isNumber = false,
    bool readOnly = false,
    VoidCallback? onTap
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2D3142), fontFamily: 'Roboto'),
            children: [
              if (isRequired) const TextSpan(text: " *", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.normal),
            prefixIcon: Icon(icon, color: Colors.purple.shade300, size: 18),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.purple.shade400, width: 1.5),
            ),
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}

// ============================================================================
// HALAMAN BARU: EDIT EXAM PERIOD & SESSION LIST
// ============================================================================

class EditExamPeriodPage extends StatefulWidget {
  final Map<String, dynamic> periodData;

  const EditExamPeriodPage({super.key, required this.periodData});

  @override
  State<EditExamPeriodPage> createState() => _EditExamPeriodPageState();
}

class _EditExamPeriodPageState extends State<EditExamPeriodPage> {
  // Controllers untuk input form
  late TextEditingController _periodNameCtrl;
  late TextEditingController _startDateCtrl;
  late TextEditingController _endDateCtrl;
  late TextEditingController _periodYearCtrl;

  // ✅ LOGIC FIXED: Data Master disimpan di State agar persisten
  final List<Map<String, dynamic>> _sessionList = [
    {
      "id": "EXSES2025112400000001",
      "sessionName": "PAI X AK 1",
      "grade": "X",
      "className": "X AK 1",
      "subject": "Pendidikan Agama Islam",
      "teacher": "Afrida Karyati, S.Pd",
      "startDate": "03-Dec-2025",
      "endDate": "10-Dec-2025",
      "startTime": "07:00",
      "endTime": "15:00",
      "participants": ["25049120", "25049121", "25049122"] // ✅ List of String (IDs)
    },
    {
      "id": "EXSES2025112900000001",
      "sessionName": "PKN X AK 1",
      "grade": "X",
      "className": "X AK 1",
      "subject": "Pendidikan Pancasila...",
      "teacher": "Yogi Viranisa, A.Md",
      "startDate": "03-Dec-2025",
      "endDate": "10-Dec-2025",
      "startTime": "07:40",
      "endTime": "15:00",
      "participants": []
    },
    {
      "id": "EXSES2025120300000001",
      "sessionName": "BAHASA INDONESIA X AK 1",
      "grade": "X",
      "className": "X AK 1",
      "subject": "Bahasa Indonesia",
      "teacher": "Yusniarti Nurahmah, S.Pd",
      "startDate": "04-Dec-2025",
      "endDate": "10-Dec-2025",
      "startTime": "07:00",
      "endTime": "14:00",
      "participants": []
    },
  ];

  @override
  void initState() {
    super.initState();
    // Mengisi form dengan data yang dilempar dari halaman sebelumnya
    _periodNameCtrl = TextEditingController(text: widget.periodData['name']);
    _startDateCtrl = TextEditingController(text: widget.periodData['startDate']);
    _endDateCtrl = TextEditingController(text: widget.periodData['endDate']);
    _periodYearCtrl = TextEditingController(text: widget.periodData['yearCode']);
  }

  @override
  void dispose() {
    _periodNameCtrl.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    _periodYearCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple.shade600,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.deepPurple.shade600),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        const List<String> monthNames = [
          "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ];
        String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}-${monthNames[pickedDate.month - 1]}-${pickedDate.year}";
        controller.text = formattedDate;
      });
    }
  }

  // ✅ FUNGSI BARU: Konfirmasi Delete Session
  void _confirmDeleteSession(int index, String sessionName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                child: Icon(Icons.warning_amber_rounded, color: Colors.red.shade600),
              ),
              const SizedBox(width: 10),
              const Text("Delete Session", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontFamily: 'Roboto'),
              children: [
                const TextSpan(text: "Are you sure you want to delete session "),
                TextSpan(text: '"$sessionName"', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                const TextSpan(text: "? This action cannot be undone."),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Tutup dialog
              child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                // Hapus data dari List
                setState(() {
                  _sessionList.removeAt(index);
                });
                Navigator.pop(context); // Tutup dialog

                // Tampilkan snackbar sukses
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Session deleted successfully!"),
                    backgroundColor: Colors.red.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // --- HEADER APP BAR ---
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple.shade500, Colors.deepPurple.shade700],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Edit Exam Period",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================
                // BAGIAN 1: FORM EDIT EXAM PERIOD (UI MATCHED)
                // ==========================================
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    // Tidak ada shadow sesuai permintaan
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDesignReadOnlyField("Exam Period ID", widget.periodData['id']),
                      const SizedBox(height: 15),
                      _buildDesignInputField(
                          label: "Exam Period Name",
                          controller: _periodNameCtrl,
                          icon: Icons.edit_note_rounded,
                          isRequired: true
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                              child: _buildDesignInputField(
                                  label: "Start Date",
                                  controller: _startDateCtrl,
                                  icon: Icons.calendar_month_outlined,
                                  isRequired: true,
                                  readOnly: true,
                                  onTap: () => _selectDate(context, _startDateCtrl)
                              )
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                              child: _buildDesignInputField(
                                  label: "End Date",
                                  controller: _endDateCtrl,
                                  icon: Icons.calendar_month_outlined,
                                  isRequired: true,
                                  readOnly: true,
                                  onTap: () => _selectDate(context, _endDateCtrl)
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildDesignInputField(
                          label: "Period Year",
                          controller: _periodYearCtrl,
                          icon: Icons.flag_rounded,
                          isRequired: true
                      ),

                      const SizedBox(height: 25),
                      // TOMBOL AKSI FORM
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE57373), // Merah soft
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5E35B1), // Ungu tua
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(thickness: 1.5, color: Color(0xFFE0E0E0)),
                ),
                const SizedBox(height: 10),

                // ==========================================
                // BAGIAN 2: EXAM SESSION LIST (TABEL)
                // ==========================================

                // --- TOKENS BUTTONS ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewTokenPage(periodData: widget.periodData),
                              ),
                            );
                          },
                          icon: const Icon(Icons.visibility_rounded, color: Colors.indigo, size: 18),
                          label: const Text("View Token", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo.shade50,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.indigo)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GenerateTokenPage(periodData: widget.periodData),
                              ),
                            );
                          },
                          icon: const Icon(Icons.generating_tokens_rounded, color: Colors.white, size: 18),
                          label: const Text("Generate Token", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3949AB),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // --- SEARCH BAR ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search all fields...",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        icon: Icon(Icons.search_rounded, color: Colors.grey, size: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- LIST OF SESSION CARDS ---
                // ✅ UPDATE: Tambahkan argumen index di fungsi itemBuilder
                ListView.builder(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _sessionList.length,
                  itemBuilder: (context, index) {
                    final session = _sessionList[index];
                    return _buildSessionListCard(session, index); // Meneruskan index ke helper
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER UNTUK WIDGET FORM (UI DESIGN MATCH) ---
  Widget _buildDesignReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5), // Abu-abu pucat
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Widget _buildDesignInputField({required String label, required TextEditingController controller, required IconData icon, bool isRequired = false, bool readOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87, fontFamily: 'Roboto'),
            children: [if (isRequired) const TextSpan(text: " *", style: TextStyle(color: Colors.red))],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.purple.shade300, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.purple.shade400, width: 1.5)),
          ),
          onTap: onTap,
        ),
      ],
    );
  }

  // --- HELPER UNTUK KARTU TABEL SESSION ---
  // ✅ UPDATE: Menambahkan parameter index
  Widget _buildSessionListCard(Map<String, dynamic> session, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.indigo.shade100),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          // Header Card (ID & Action Buttons)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50.withOpacity(0.6),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              border: Border(bottom: BorderSide(color: Colors.indigo.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  session['id'],
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.indigo.shade700),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // ✅ NAVIGASI KE HALAMAN VIEW SESSION DETAIL
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewSessionDetailPage(sessionData: session),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Icon(Icons.visibility_rounded, size: 16, color: Colors.blue.shade600),
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () async {
                        // ✅ LOGIC FIXED: Tunggu hasil dari halaman Participant
                        final List<String>? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamParticipantPage(sessionData: session),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            session['participants'] = result;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.indigo.shade200),
                        ),
                        child: Icon(Icons.person_rounded, size: 16, color: Colors.indigo.shade600),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // ✅ UPDATE: Tambahkan Aksi Hapus (Delete)
                    InkWell(
                      onTap: () {
                        // Panggil fungsi konfirmasi hapus
                        _confirmDeleteSession(index, session['sessionName']);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red.shade600),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Body Card (Informasi Sesi)
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session['sessionName'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                ),
                const SizedBox(height: 12),

                // Info Grid
                Row(
                  children: [
                    Expanded(child: _buildInfoText(Icons.menu_book_rounded, session['subject'])),
                    Expanded(child: _buildInfoText(Icons.person_pin_circle_rounded, session['teacher'])),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildInfoText(Icons.class_rounded, "Class: ${session['className']} (Gr. ${session['grade']})")),
                    // ✅ Tampilkan jumlah peserta secara dinamis
                    Expanded(child: _buildInfoText(Icons.people_alt_rounded, "${session['participants']?.length ?? 0} Students")),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: Color(0xFFF0F0F0)),
                ),

                // Jadwal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("START", style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("${session['startDate']} • ${session['startTime']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                      ],
                    ),
                    Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.grey.shade400),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("END", style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("${session['endDate']} • ${session['endTime']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoText(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// HALAMAN BARU: VIEW EXAM TOKEN LIST
// ============================================================================

class ViewTokenPage extends StatefulWidget {
  final Map<String, dynamic> periodData;

  const ViewTokenPage({super.key, required this.periodData});

  @override
  State<ViewTokenPage> createState() => _ViewTokenPageState();
}

class _ViewTokenPageState extends State<ViewTokenPage> {
  // Dummy Data Token Murid (Berdasarkan gambar referensi web)
  final List<Map<String, dynamic>> _studentTokens = [
    {"userId": "25049120", "name": "Abdullah Widodo", "className": "X AK 1", "token": "HUYXMR"},
    {"userId": "25049121", "name": "Andika Prastyo", "className": "X AK 1", "token": "WMNEUY"},
    {"userId": "25049122", "name": "ARDIAN RESTU TRIAJI", "className": "X AK 1", "token": "WNYZDH"},
    {"userId": "25049123", "name": "ARSYVA RAHMAH", "className": "X AK 1", "token": "JTFRBA"},
    {"userId": "25049124", "name": "AZZURA NAILATUL IZZAH", "className": "X AK 1", "token": "EGMIUV"},
    {"userId": "25049125", "name": "BILQIS SALZABILLAH", "className": "X AK 1", "token": "ZGEYou"},
    {"userId": "25049126", "name": "DEZIYAH THOYIB", "className": "X AK 1", "token": "FAIXKM"},
  ];

  List<Map<String, dynamic>> _filteredTokens = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredTokens = _studentTokens;
  }

  void _filterTokens(String query) {
    setState(() {
      _filteredTokens = _studentTokens
          .where((s) =>
      s['name']!.toLowerCase().contains(query.toLowerCase()) ||
          s['userId']!.toLowerCase().contains(query.toLowerCase()) ||
          s['token']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // --- HEADER APP BAR ---
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple.shade500, Colors.deepPurple.shade700],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Exam Tokens",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- KARTU INFO PERIODE (Ringkasan dari halaman sebelumnya) ---
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.purple.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                    border: Border.all(color: Colors.purple.shade50),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: Colors.purple.shade400, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            "Period Summary",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: Color(0xFFF0F0F0)),
                      ),
                      _buildSummaryRow("Period Name", widget.periodData['name'] ?? "Unknown"),
                      const SizedBox(height: 8),
                      _buildSummaryRow("Period Date", "${widget.periodData['startDate']}  -  ${widget.periodData['endDate']}"),
                      const SizedBox(height: 8),
                      _buildSummaryRow("Period Year", widget.periodData['yearCode'] ?? "-"),
                    ],
                  ),
                ),

                // --- TOMBOL EXPORT & SEARCH BAR ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterTokens,
                            decoration: InputDecoration(
                              hintText: "Search name, ID...",
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                              icon: Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 18),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Tombol Export Excel (Sesuai Web)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green.shade500, Colors.green.shade700],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.download_rounded, color: Colors.white),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Downloading Excel File..."), backgroundColor: Colors.green),
                            );
                          },
                          tooltip: "Export Excel",
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- LIST OF STUDENT TOKENS ---
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Text(
                    "Student Tokens (${_filteredTokens.length})",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                  ),
                ),

                _filteredTokens.isEmpty
                    ? Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.person_off_rounded, size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 15),
                        Text("No students found", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredTokens.length,
                  itemBuilder: (context, index) {
                    final student = _filteredTokens[index];
                    return _buildTokenCard(student, index);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Card untuk Detail Periode
  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
        ),
        const Text(" :  ", style: TextStyle(fontSize: 12, color: Colors.grey)),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
      ],
    );
  }

  // Helper Card untuk Murid & Token
  Widget _buildTokenCard(Map<String, dynamic> student, int index) {
    // Mengambil inisial nama (misal: "Abdullah Widodo" jadi "AW")
    List<String> nameParts = student['name'].split(" ");
    String initials = nameParts[0][0];
    if (nameParts.length > 1) initials += nameParts[1][0];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Nomor Urut & Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple.shade700, fontSize: 14),
            ),
          ),
          const SizedBox(width: 15),

          // Data Murid
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'],
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.badge_rounded, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      student['userId'],
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.class_rounded, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      student['className'],
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Token Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade500],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3)),
              ],
            ),
            child: Text(
              student['token'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0, // Memberi jarak agar token mudah dibaca
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HALAMAN BARU: GENERATE TOKEN (MOBILE ADAPTATION)
// ============================================================================

class GenerateTokenPage extends StatefulWidget {
  final Map<String, dynamic> periodData;

  const GenerateTokenPage({super.key, required this.periodData});

  @override
  State<GenerateTokenPage> createState() => _GenerateTokenPageState();
}

class _GenerateTokenPageState extends State<GenerateTokenPage> {
  // Dummy Data Murid yang bisa di-generate tokennya
  final List<Map<String, dynamic>> _students = [
    {"id": "S001", "name": "A'LIN ZAHWAH DINIYAH", "className": "XII TKJ 2"},
    {"id": "S002", "name": "ABDUL BARKAH AR RASYID", "className": "XI DKV 2"},
    {"id": "S003", "name": "ABDUL FATAN ATALAH", "className": "XI DKV 1"},
    {"id": "S004", "name": "ADITYA PRATAMA", "className": "XII TKJ 1"},
    {"id": "S005", "name": "AYU LESTARI", "className": "XI AK 1"},
    {"id": "S006", "name": "BIMA SAKTI", "className": "X RPL 1"},
    {"id": "S007", "name": "CHELSEA ISLAN", "className": "XII DKV 1"},
  ];

  // Set untuk menyimpan ID murid yang dicentang
  Set<String> _selectedStudentIds = {};
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    // Default: Semua murid langsung tercentang saat halaman dibuka (Sesuai kebiasaan)
    _selectAllStudents(true);
  }

  void _selectAllStudents(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      if (_selectAll) {
        _selectedStudentIds = _students.map((s) => s['id'] as String).toSet();
      } else {
        _selectedStudentIds.clear();
      }
    });
  }

  void _toggleStudentSelection(String id, bool? value) {
    setState(() {
      if (value == true) {
        _selectedStudentIds.add(id);
      } else {
        _selectedStudentIds.remove(id);
      }
      // Update status "Select All" checkbox
      _selectAll = _selectedStudentIds.length == _students.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // --- HEADER APP BAR ---
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple.shade500, Colors.deepPurple.shade700],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Generate Token",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. INFO EXAM PERIOD (Read-Only) ---
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.purple.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                    border: Border.all(color: Colors.purple.shade50),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.assignment_rounded, color: Colors.purple.shade400, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            "Exam Period Info",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildReadOnlyField("Exam Period ID", widget.periodData['id'] ?? "-"),
                      const SizedBox(height: 12),
                      _buildReadOnlyField("Exam Period Name", widget.periodData['name'] ?? "-"),
                    ],
                  ),
                ),

                // --- 2. HEADER PESERTA (PARTICIPANT) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Participants",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${_selectedStudentIds.length} of ${_students.length} Selected",
                            style: TextStyle(fontSize: 13, color: Colors.deepPurple.shade400, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),

                      // Tombol Select All
                      InkWell(
                        onTap: () => _selectAllStudents(!_selectAll),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _selectAll ? Colors.deepPurple.shade50 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _selectAll ? Colors.deepPurple.shade200 : Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _selectAll ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                                color: _selectAll ? Colors.deepPurple.shade600 : Colors.grey.shade500,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Select All",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _selectAll ? Colors.deepPurple.shade700 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // --- 3. LIST PESERTA ---
                ListView.builder(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100), // Padding bawah untuk area FAB
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    final student = _students[index];
                    final isSelected = _selectedStudentIds.contains(student['id']);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepPurple.shade50.withOpacity(0.5) : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected ? Colors.deepPurple.shade300 : Colors.grey.shade200,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(color: Colors.deepPurple.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3))
                        ] : [],
                      ),
                      child: CheckboxListTile(
                        value: isSelected,
                        onChanged: (val) => _toggleStudentSelection(student['id'], val),
                        activeColor: Colors.deepPurple.shade600,
                        checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        title: Text(
                          student['name'],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.deepPurple.shade900 : const Color(0xFF2D3142)
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(Icons.class_rounded, size: 12, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Text(
                                student['className'],
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        secondary: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.deepPurple.shade100 : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.person_rounded, color: isSelected ? Colors.deepPurple.shade600 : Colors.grey.shade400),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // --- FLOATING ACTION BUTTON (SUBMIT & CANCEL) ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.grey.shade100,
                ),
                child: Text("Cancel", style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _selectedStudentIds.isEmpty ? null : () async {
                  // Simulasi proses generate token (API)
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: Colors.deepPurple.shade600),
                            const SizedBox(height: 20),
                            const Text("Generating Tokens...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  );

                  await Future.delayed(const Duration(seconds: 2));
                  if (mounted) Navigator.pop(context); // Tutup loading

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Colors.white),
                            const SizedBox(width: 12),
                            Text("Successfully generated ${_selectedStudentIds.length} tokens!"),
                          ],
                        ),
                        backgroundColor: Colors.green.shade600,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    );
                    Navigator.pop(context); // Kembali ke halaman sebelumnya
                  }
                },
                icon: const Icon(Icons.generating_tokens_rounded, color: Colors.white, size: 20),
                label: const Text("Generate", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade600,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
// ============================================================================
// HALAMAN BARU: VIEW SESSION DETAIL
// ============================================================================

class ViewSessionDetailPage extends StatelessWidget {
  final Map<String, dynamic> sessionData;

  const ViewSessionDetailPage({super.key, required this.sessionData});

  @override
  Widget build(BuildContext context) {
    // Data dummy tambahan jika di data utama belum ada (untuk Max Attempt)
    final String maxAttempt = sessionData['maxAttempt'] ?? "1";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      // --- HEADER APP BAR ---
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade500, Colors.deepPurple.shade700],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Session Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),

      // --- BODY CONTENT ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- KARTU 1: INFO UTAMA ---
            _buildDetailSectionCard(
              title: "Basic Information",
              icon: Icons.info_outline_rounded,
              children: [
                _buildDetailRow("Exam Session ID", sessionData['id'], Icons.fingerprint_rounded),
                _buildDivider(),
                _buildDetailRow("Exam Session Name", sessionData['sessionName'], Icons.edit_note_rounded),
              ],
            ),
            const SizedBox(height: 20),

            // --- KARTU 2: AKADEMIK & PENGAJAR ---
            _buildDetailSectionCard(
              title: "Academic & Teacher",
              icon: Icons.school_rounded,
              children: [
                Row(
                  children: [
                    Expanded(child: _buildDetailRow("Grade", sessionData['grade'], Icons.bookmark_border_rounded)),
                    const SizedBox(width: 20),
                    Expanded(child: _buildDetailRow("Class Name", sessionData['className'], Icons.class_rounded)),
                  ],
                ),
                _buildDivider(),
                _buildDetailRow("Subject Name", sessionData['subject'], Icons.menu_book_rounded),
                _buildDivider(),
                _buildDetailRow("Teacher Name", sessionData['teacher'], Icons.person_pin_circle_rounded),
              ],
            ),
            const SizedBox(height: 20),

            // --- KARTU 3: JADWAL & ATURAN ---
            _buildDetailSectionCard(
              title: "Schedule & Rules",
              icon: Icons.calendar_month_rounded,
              children: [
                _buildDetailRow("Start Date & Time", "${sessionData['startDate']} at ${sessionData['startTime']}", Icons.play_circle_fill_rounded, valueColor: Colors.green.shade700),
                _buildDivider(),
                _buildDetailRow("End Date & Time", "${sessionData['endDate']} at ${sessionData['endTime']}", Icons.stop_circle_rounded, valueColor: Colors.red.shade700),
                _buildDivider(),
                _buildDetailRow("Max Attempt", "$maxAttempt Time(s)", Icons.replay_rounded),
              ],
            ),

            const SizedBox(height: 30),
            // Tombol Close di bawah
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text("Close Details", style: TextStyle(color: Colors.deepPurple.shade700, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  // Helper untuk membuat Kartu Section
  Widget _buildDetailSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.deepPurple.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.deepPurple.shade400, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  // Helper untuk menampilkan baris data (Label & Value)
  Widget _buildDetailRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade400),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                  value,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: valueColor ?? const Color(0xFF2D3142),
                      height: 1.3
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper Garis Pembatas
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 35, top: 12, bottom: 12),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}

// ============================================================================
// HALAMAN BARU: EXAM PARTICIPANT SELECTION (MOBILE ADAPTATION)
// ============================================================================

class ExamParticipantPage extends StatefulWidget {
  final Map<String, dynamic> sessionData;

  const ExamParticipantPage({super.key, required this.sessionData});

  @override
  State<ExamParticipantPage> createState() => _ExamParticipantPageState();
}

class _ExamParticipantPageState extends State<ExamParticipantPage> {
  // Dummy Data Murid yang tersedia di kelas tersebut
  final List<Map<String, dynamic>> _availableStudents = [
    {"id": "25049120", "name": "Abdullah Widodo", "className": "X AK 1"},
    {"id": "25049121", "name": "Andika Prastyo", "className": "X AK 1"},
    {"id": "25049122", "name": "ARDIAN RESTU TRIAJI", "className": "X AK 1"},
    {"id": "25049123", "name": "ARSYVA RAHMAH", "className": "X AK 1"},
    {"id": "25049124", "name": "AZZURA NAILATUL IZZAH", "className": "X AK 1"},
    {"id": "25049125", "name": "BILQIS SALZABILLAH", "className": "X AK 1"},
    {"id": "25049126", "name": "DEZIYAH THOYIB", "className": "X AK 1"},
  ];

  // Set untuk menampung ID murid yang dipilih (Selected)
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    // ✅ PERBAIKAN LOGIKA:
    // Ambil data ID murid dari sessionData agar centang lama tidak hilang
    if (widget.sessionData['participants'] != null) {
      _selectedIds.addAll(List<String>.from(widget.sessionData['participants']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // --- HEADER APP BAR ---
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple.shade500, Colors.deepPurple.shade700],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Exam Participants",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- KARTU INFO SESI (Read-Only) ---
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.purple.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.label_important_outline_rounded, "Session Name", widget.sessionData['sessionName']),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: Color(0xFFF0F0F0)),
                      ),
                      _buildInfoRow(Icons.class_rounded, "Grade / Class", "${widget.sessionData['grade']} / ${widget.sessionData['className']}"),
                    ],
                  ),
                ),

                // --- TAB HEADER (Available vs Selected Count) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Student List",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade600,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${_selectedIds.length} Selected",
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // --- SEARCH BAR ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search student name...",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        icon: Icon(Icons.search_rounded, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- LIST PESERTA DENGAN CHECKBOX ---
                ListView.builder(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _availableStudents.length,
                  itemBuilder: (context, index) {
                    final student = _availableStudents[index];
                    final isSelected = _selectedIds.contains(student['id']);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedIds.remove(student['id']);
                          } else {
                            _selectedIds.add(student['id']);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? Colors.deepPurple.shade300 : Colors.transparent,
                            width: 1.5,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(color: Colors.deepPurple.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))
                          ] : [],
                        ),
                        child: Row(
                          children: [
                            // Status Checkbox Visual
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.deepPurple.shade600 : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isSelected ? Colors.deepPurple.shade600 : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 15),
                            // Data Murid
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student['name'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade600
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "ID: ${student['id']}",
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ),
                            // Badge Status (Available/Selected)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.green.shade50 : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isSelected ? "SELECTED" : "AVAILABLE",
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.green.shade700 : Colors.grey.shade500
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // --- TOMBOL SIMPAN ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: ElevatedButton(
          // ✅ PERBAIKAN LOGIKA: Kirim kembali list ID yang dipilih ke halaman sebelumnya
          onPressed: () {
            Navigator.pop(context, _selectedIds.toList());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade600,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
          ),
          child: const Text("Update Participants", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.purple.shade300),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
          ],
        ),
      ],
    );
  }
}