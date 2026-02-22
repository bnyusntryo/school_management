import 'package:flutter/material.dart';

// ============================================================================
// HALAMAN 1: CBT REPORTS DASHBOARD
// ============================================================================

class CBTReportsPage extends StatelessWidget {
  const CBTReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // --- HEADER APP BAR (KONSISTEN DENGAN DESAIN SEBELUMNYA) ---
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
                  "CBT Reports",
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

          // --- BODY: DAFTAR REPORT ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildReportCard(
                    context,
                    title: "Exam Result Report",
                    description: "Exam Result Report provides students score from exam result, allowing educators to monitor student performance and identify areas for improvement.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ExamResultReportPage()),
                      );
                    },
                  ),
                  // Jika ada report lain (misal: Absensi, Analisis Soal), bisa ditambahkan di sini
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, {required String title, required String description, required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.analytics_rounded, color: Colors.blue.shade600, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4), // Warna biru sesuai gambar web
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text("Preview", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HALAMAN 2: EXAM RESULT REPORT (FORM SELEKSI)
// ============================================================================

class ExamResultReportPage extends StatefulWidget {
  const ExamResultReportPage({super.key});

  @override
  State<ExamResultReportPage> createState() => _ExamResultReportPageState();
}

class _ExamResultReportPageState extends State<ExamResultReportPage> {
  // Dummy Data Sesuai Gambar Web
  final List<String> _examPeriods = [
    "Exam Period 08 Feb 2024",
    "EXAM 11 Feb",
    "UJIAN_SATUAN_PENDIDIKAN_2024",
    "STS/PTS GANJIL 2024-2025",
  ];

  final List<String> _sessions = [
    "PAI X AK 1",
    "PKN X AK 1",
    "BAHASA INDONESIA X AK 1",
    "MATEMATIKA X AK 1",
  ];

  // Set untuk menyimpan item yang dipilih (Logika Fix)
  final Set<String> _selectedPeriods = {};
  final Set<String> _selectedSessions = {};

  bool _selectAllPeriods = false;
  bool _selectAllSessions = false;

  void _toggleSelectAllPeriods(bool? value) {
    setState(() {
      _selectAllPeriods = value ?? false;
      if (_selectAllPeriods) {
        _selectedPeriods.addAll(_examPeriods);
      } else {
        _selectedPeriods.clear();
      }
    });
  }

  void _toggleSelectAllSessions(bool? value) {
    setState(() {
      _selectAllSessions = value ?? false;
      if (_selectAllSessions) {
        _selectedSessions.addAll(_sessions);
      } else {
        _selectedSessions.clear();
      }
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
                  "Exam Result Report",
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- BAGIAN 1: SELECT EXAM PERIOD ---
                  _buildSelectionSection(
                    title: "Select Exam Period",
                    items: _examPeriods,
                    selectedItems: _selectedPeriods,
                    selectAllVal: _selectAllPeriods,
                    onSelectAll: _toggleSelectAllPeriods,
                    onItemToggle: (item, isSelected) {
                      setState(() {
                        if (isSelected == true) {
                          _selectedPeriods.add(item);
                        } else {
                          _selectedPeriods.remove(item);
                        }
                        _selectAllPeriods = _selectedPeriods.length == _examPeriods.length;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  // --- BAGIAN 2: SELECT SESSION ---
                  _buildSelectionSection(
                    title: "Select Session",
                    items: _sessions,
                    selectedItems: _selectedSessions,
                    selectAllVal: _selectAllSessions,
                    onSelectAll: _toggleSelectAllSessions,
                    onItemToggle: (item, isSelected) {
                      setState(() {
                        if (isSelected == true) {
                          _selectedSessions.add(item);
                        } else {
                          _selectedSessions.remove(item);
                        }
                        _selectAllSessions = _selectedSessions.length == _sessions.length;
                      });
                    },
                  ),

                  const SizedBox(height: 100), // Spasi untuk tombol submit di bawah
                ],
              ),
            ),
          ),
        ],
      ),
      // --- TOMBOL SUBMIT BAWAH ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: ElevatedButton(
          onPressed: (_selectedPeriods.isEmpty || _selectedSessions.isEmpty) ? null : () {
            // ✅ NAVIGASI MEMBAWA DATA SESI YANG DIPILIH
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewReportPage(
                  selectedSessions: _selectedSessions.toList(), // Kirim data filter
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3949AB),
            disabledBackgroundColor: Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
          child: const Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  // --- HELPER UNTUK MEMBUAT KOTAK SELEKSI (PENGGANTI TRANSFER LIST) ---
  Widget _buildSelectionSection({
    required String title,
    required List<String> items,
    required Set<String> selectedItems,
    required bool selectAllVal,
    required ValueChanged<bool?> onSelectAll,
    required void Function(String, bool?) onItemToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Label
        RichText(
          text: TextSpan(
            text: title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87, fontFamily: 'Roboto'),
            children: const [
              TextSpan(text: " *", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Kontainer Utama Form Seleksi
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              // Header: Select All & Counter
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 15, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: selectAllVal,
                          onChanged: onSelectAll,
                          activeColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        const Text("Select All", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${selectedItems.length} Selected",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurple.shade700),
                      ),
                    )
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),

              // Search Bar Internal
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 18),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),

              // Daftar Item (Scrollable Box)
              Container(
                height: 200, // Membatasi tinggi agar layout tidak hancur
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: items.isEmpty
                    ? Center(child: Text("No available options", style: TextStyle(color: Colors.grey.shade500)))
                    : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = selectedItems.contains(item);

                    return InkWell(
                      onTap: () => onItemToggle(item, !isSelected),
                      child: Container(
                        color: isSelected ? Colors.deepPurple.shade50.withOpacity(0.3) : Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSelected,
                              onChanged: (val) => onItemToggle(item, val),
                              activeColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.deepPurple.shade700 : Colors.black87
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Tombol Load More (Visual sesuai web)
              InkWell(
                onTap: (){},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8C9EFF), // Biru muda sesuai web
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
                  ),
                  child: const Center(
                    child: Text("Load More", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
// ============================================================================
// HALAMAN 3: PREVIEW REPORT DATA (TABLE)
// ============================================================================

class PreviewReportPage extends StatefulWidget {
  final List<String> selectedSessions;

  const PreviewReportPage({super.key, required this.selectedSessions});

  @override
  State<PreviewReportPage> createState() => _PreviewReportPageState();
}

class _PreviewReportPageState extends State<PreviewReportPage> {
  // Dummy Data Laporan (Biasanya ini hasil dari pemanggilan API backend)
  List<Map<String, dynamic>> reportData = [];

  @override
  void initState() {
    super.initState();
    _generateDummyReportData();
  }

  // Fungsi mensimulasikan Backend memfilter data berdasarkan Sesi yang dipilih
  void _generateDummyReportData() {
    // Jika tidak ada sesi yang dilempar, biarkan kosong
    if (widget.selectedSessions.isEmpty) return;

    // Kita buat 2 data murid dummy untuk SETIAP sesi yang dipilih user
    for (String session in widget.selectedSessions) {
      reportData.add({
        "className": "X AK 1",
        "userId": "25049120",
        "fullName": "Abdullah Widodo",
        "sessionName": session,
        "subjectClassName": "PAIXAK125",
        "subjectName": "Pendidikan Agama Islam",
        "attempt": "1",
        "startTime": "2025 Dec 03 07:00",
        "endTime": "2025 Dec 03 08:30",
        "score": "85.5",
      });
      reportData.add({
        "className": "X AK 1",
        "userId": "25049121",
        "fullName": "Andika Prastyo",
        "sessionName": session,
        "subjectClassName": "PAIXAK125",
        "subjectName": "Pendidikan Agama Islam",
        "attempt": "1",
        "startTime": "2025 Dec 03 07:05",
        "endTime": "2025 Dec 03 08:45",
        "score": "92.0",
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format tanggal saat ini untuk header (Seperti di web: 2/23/2026...)
    final now = DateTime.now();
    final String reportedDate = "${now.month}/${now.day}/${now.year}, ${now.hour}:${now.minute.toString().padLeft(2, '0')} AM";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2), // Biru Header Web
        title: const Text("Preview Reports", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            tooltip: "Close",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- META INFO HEADER ---
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMetaText("Report Name", ": Exam Result Report"),
                  const SizedBox(height: 5),
                  _buildMetaText("Reported Date", ": $reportedDate"),
                  const SizedBox(height: 5),
                  _buildMetaText("Reported By", ": Dummy Headmaster"),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // --- ACTION BUTTONS (DOWNLOAD EXCEL & PDF) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Rata kanan sesuai web
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Downloading Excel..."), backgroundColor: Colors.green));
                    },
                    icon: const Icon(Icons.description_rounded, size: 16, color: Colors.white),
                    label: const Text("Download Excel", style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50), // Hijau Excel
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Downloading PDF..."), backgroundColor: Colors.red));
                    },
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 16, color: Colors.white),
                    label: const Text("Download PDF", style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF44336), // Merah PDF
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // --- DATA TABLE SCROLLABLE ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3)),
                ],
              ),
              // Komponen ajaib untuk membuat tabel bisa digeser ke kanan-kiri
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.resolveWith((states) => const Color(0xFF283593)), // Biru gelap header tabel
                  headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  dataTextStyle: const TextStyle(color: Colors.black87, fontSize: 12),
                  columnSpacing: 25, // Jarak antar kolom
                  columns: const [
                    DataColumn(label: Text("#")),
                    DataColumn(label: Text("Class Name")),
                    DataColumn(label: Text("Userid")),
                    DataColumn(label: Text("Full Name")),
                    DataColumn(label: Text("Session Name")),
                    DataColumn(label: Text("Subject Class Name")),
                    DataColumn(label: Text("Subject Name")),
                    DataColumn(label: Text("Attempt")),
                    DataColumn(label: Text("Start Time")),
                    DataColumn(label: Text("End Time")),
                    DataColumn(label: Text("Score")),
                  ],
                  // Looping data dummy kita untuk dijadikan baris (row)
                  rows: List.generate(reportData.length, (index) {
                    final data = reportData[index];
                    return DataRow(
                      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                        // Belang-belang warna baris (Zebra Striping)
                        if (index.isEven) return Colors.grey.withOpacity(0.05);
                        return null;
                      }),
                      cells: [
                        DataCell(Text((index + 1).toString())),
                        DataCell(Text(data['className'])),
                        DataCell(Text(data['userId'])),
                        DataCell(Text(data['fullName'], style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(data['sessionName'])),
                        DataCell(Text(data['subjectClassName'])),
                        DataCell(Text(data['subjectName'])),
                        DataCell(Text(data['attempt'])),
                        DataCell(Text(data['startTime'])),
                        DataCell(Text(data['endTime'])),
                        DataCell(Text(data['score'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 40), // Padding bawah
          ],
        ),
      ),
    );
  }

  // Helper text meta info
  Widget _buildMetaText(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        )
      ],
    );
  }
}