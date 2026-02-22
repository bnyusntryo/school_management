import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ExamManagementPage extends StatefulWidget {
  const ExamManagementPage({super.key});

  @override
  State<ExamManagementPage> createState() => _ExamManagementPageState();
}

class _ExamManagementPageState extends State<ExamManagementPage> {
  // Dummy Data berdasarkan gambar referensi web
  final List<Map<String, dynamic>> _examSessions = [
    {
      "classCode": "ADPA_XI-AK-1",
      "className": "Administrasi Pajak",
      "subjectName": "Administrasi Pajak",
      "period": "2025",
      "grade": "XI",
      "class": "XI AK 1",
      "teacher": "Elya Juliawati, S.Pd",
      "status": "Active"
    },
    {
      "classCode": "AKEU_XI-AK-1",
      "className": "Akuntansi Keuangan",
      "subjectName": "Akuntansi Keuangan",
      "period": "2025",
      "grade": "XI",
      "class": "XI AK 1",
      "teacher": "Elya Juliawati, S.Pd",
      "status": "Active"
    },
    {
      "classCode": "AKEU_XII_AK_2",
      "className": "Akuntansi Keuangan XII AK 2",
      "subjectName": "Akuntansi Keuangan",
      "period": "2025",
      "grade": "XII",
      "class": "XII AK 2",
      "teacher": "Dian Rostikawati, S.E., M.M",
      "status": "Active"
    },
    {
      "classCode": "AKUND_XI-BD-1",
      "className": "Akuntansi Dasar",
      "subjectName": "Akuntansi Dasar",
      "period": "2025",
      "grade": "XI",
      "class": "XI BD 1",
      "teacher": "Nurmaely, SE.I",
      "status": "Active"
    },
  ];

  List<Map<String, dynamic>> _filteredSessions = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredSessions = _examSessions;
  }

  void _filterSessions(String query) {
    setState(() {
      _filteredSessions = _examSessions
          .where((s) =>
      s['className']!.toLowerCase().contains(query.toLowerCase()) ||
          s['teacher']!.toLowerCase().contains(query.toLowerCase()) ||
          s['classCode']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showUploadSessionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.indigo.shade50],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.indigo.shade400, Colors.blue.shade600],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.cloud_upload_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Upload Session",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                const Text(
                  "Upload Data Session",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please upload your session data file here. Only Excel (.xlsx, .xls) or CSV files are supported.",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 25),

                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await _processFileUpload(['xlsx', 'xls', 'csv']);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.indigo.shade200,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.note_add_rounded,
                            size: 40,
                            color: Colors.indigo.shade400,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Tap to Select File",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Max file size: 10MB",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _processFileUpload(List<String> allowedExtensions) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo.shade600),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Uploading Session...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) Navigator.pop(context);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "File ${result.files.single.name} uploaded successfully!",
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.all(20),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text("Upload failed: ${e.toString()}")),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.all(20),
          ),
        );
      }
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
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange.shade400,
                    Colors.deepOrange.shade600,
                    Colors.red.shade700,
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
                  "Exam Management",
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

          // --- FILTER & SEARCH SECTION ---
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
                                color: Colors.orange.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterSessions,
                            decoration: InputDecoration(
                              icon: Icon(Icons.search_rounded, color: Colors.orange.shade600),
                              hintText: "Search fields...",
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
                            _filterSessions('');
                          },
                          icon: Icon(Icons.filter_alt_off_rounded, color: Colors.grey.shade600),
                          tooltip: "Clear Filter",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Upload Session Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showUploadSessionModal,
                      icon: const Icon(Icons.cloud_upload_rounded, color: Colors.white),
                      label: const Text(
                        "Upload Session",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        shadowColor: Colors.indigo.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- LIST OF DATA CARDS ---
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _buildExamCard(_filteredSessions[index], index);
                },
                childCount: _filteredSessions.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET CARD
  Widget _buildExamCard(Map<String, dynamic> data, int index) {
    bool isActive = data['status'] == 'Active';

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
              color: Colors.indigo.shade50.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Kode Kelas
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.indigo.shade100),
                  ),
                  child: Text(
                    data['classCode'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive ? Colors.green.shade200 : Colors.red.shade200,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        data['status'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // --- CARD BODY ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Mapel
                Text(
                  data['className'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 15),

                // Informasi Detail
                _buildDetailRow(Icons.person_rounded, "Teacher", data['teacher']),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.class_rounded, "Class / Grade", "${data['class']} (Grade ${data['grade']})"),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.calendar_month_rounded, "Period", "Year ${data['period']}"),
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
                  "Manage Session Data",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // ✅ Tombol Edit Pindah ke Halaman EditExamManagementPage
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditExamManagementPage(sessionData: data),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.edit_rounded, color: Colors.blue.shade700, size: 20),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontFamily: 'Roboto'),
              children: [
                TextSpan(text: "$label: "),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// HALAMAN BARU: EDIT EXAM MANAGEMENT (RE-DESIGNED)
// ============================================================================

class EditExamManagementPage extends StatefulWidget {
  final Map<String, dynamic> sessionData;

  const EditExamManagementPage({super.key, required this.sessionData});

  @override
  State<EditExamManagementPage> createState() => _EditExamManagementPageState();
}

class _EditExamManagementPageState extends State<EditExamManagementPage> {
  // Dummy data untuk tabel "Session" yang ada di bawah form
  List<Map<String, dynamic>> _sessionList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // --- HEADER APP BAR (Colorful & Modern) ---
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.indigo.shade400,
                    Colors.blue.shade600,
                    Colors.deepPurple.shade700,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 60, bottom: 20),
                title: const Text(
                  "Edit Exam",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
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
                    Positioned(
                      left: -50,
                      bottom: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
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
                borderRadius: BorderRadius.circular(15),
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
                // --- KARTU INFORMASI UTAMA (Elegan & Colorful) ---
                Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header Card Info
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                          border: Border(bottom: BorderSide(color: Colors.indigo.shade100)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.info_outline_rounded, color: Colors.indigo.shade600, size: 18),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Subject Details",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                              ],
                            ),
                            // Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: widget.sessionData['status'] == 'Active' ? Colors.green.shade50 : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: widget.sessionData['status'] == 'Active' ? Colors.green.shade200 : Colors.red.shade200,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: widget.sessionData['status'] == 'Active' ? Colors.green : Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.sessionData['status'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: widget.sessionData['status'] == 'Active' ? Colors.green.shade700 : Colors.red.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      // Isi Detail Card (Grid Layout)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Judul Utama (Nama Mapel)
                            Text(
                              widget.sessionData['className'],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3142),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Code: ${widget.sessionData['classCode']}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Info Grid
                            Row(
                              children: [
                                Expanded(
                                  child: _buildBeautifulInfoTile(
                                      Icons.person_pin_circle_rounded,
                                      "Teacher",
                                      widget.sessionData['teacher'],
                                      Colors.orange
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildBeautifulInfoTile(
                                      Icons.class_rounded,
                                      "Class/Grade",
                                      "${widget.sessionData['class']} (Gr. ${widget.sessionData['grade']})",
                                      Colors.blue
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildBeautifulInfoTile(
                                      Icons.menu_book_rounded,
                                      "Subject Name",
                                      widget.sessionData['subjectName'],
                                      Colors.purple
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildBeautifulInfoTile(
                                      Icons.calendar_month_rounded,
                                      "Period Year",
                                      widget.sessionData['period'],
                                      Colors.teal
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

                // --- BAGIAN TABEL SESSION ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.format_list_bulleted_rounded, color: Colors.green.shade600, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Session List",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                        ],
                      ),

                      // Tombol Add Session (Gradient)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade400, Colors.indigo.shade600],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          // ✅ MENERIMA DATA DARI HALAMAN ADD SESSION DI SINI
                          onPressed: () async {
                            final newSession = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddSessionPage(subjectData: widget.sessionData),
                              ),
                            );

                            // Jika ada data yang dikembalikan, masukkan ke dalam List tabel
                            if (newSession != null) {
                              setState(() {
                                _sessionList.add(newSession);
                              });
                            }
                          },
                          icon: const Icon(Icons.add_circle_outline_rounded, size: 18, color: Colors.white),
                          label: const Text("Add Session", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Search Bar untuk Tabel Session
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
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search sessions...",
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                              icon: Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.filter_alt_off_rounded, color: Colors.grey.shade600),
                          onPressed: () {},
                          tooltip: "Clear Search",
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Container untuk Tabel
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
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
                    border: Border.all(color: Colors.indigo.shade50),
                  ),
                  child: Column(
                    children: [
                      // Header Tabel
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.indigo.shade400, Colors.indigo.shade700],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Expanded(flex: 2, child: Text("ID", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                            Expanded(flex: 3, child: Text("Session Name", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                            Expanded(flex: 3, child: Text("Date", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                            Expanded(flex: 2, child: Text("Action", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
                          ],
                        ),
                      ),

                      // Isi Tabel
                      _sessionList.isEmpty
                          ? Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.history_edu_rounded, size: 50, color: Colors.grey.shade300),
                            ),
                            const SizedBox(height: 15),
                            Text(
                                "No Sessions Found",
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                )
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Click 'Add Session' to create a new one.",
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _sessionList.length,
                        itemBuilder: (context, index) {
                          final session = _sessionList[index];
                          // ✅ DESAIN BARIS TABEL YANG SUDAH DIPERBAIKI
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
                              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Kolom 1: ID
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    session['id'],
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.indigo),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),

                                // Kolom 2: Session Name
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    session['name'],
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2D3142)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),

                                // Kolom 3: Date & Time
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          session['date'],
                                          style: const TextStyle(fontSize: 11, color: Colors.black87),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${session['startTime']} - ${session['endTime']}",
                                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )
                                ),
                                const SizedBox(width: 4),

                                // Kolom 4: Action (Edit & Delete)
                                Expanded(
                                  flex: 2,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: [
                                      InkWell(
                                        onTap: (){},
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                                          child: Icon(Icons.edit_rounded, color: Colors.orange.shade600, size: 14),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            _sessionList.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                                          child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade600, size: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // HELPER UNTUK KOTAK INFORMASI WARNA-WARNI
  Widget _buildBeautifulInfoTile(IconData icon, String label, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.shade100.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color.shade600),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color.shade900,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HALAMAN BARU: ADD SESSION
// ============================================================================

class AddSessionPage extends StatefulWidget {
  final Map<String, dynamic> subjectData;

  const AddSessionPage({super.key, required this.subjectData});

  @override
  State<AddSessionPage> createState() => _AddSessionPageState();
}

class _AddSessionPageState extends State<AddSessionPage> {
  // Controllers untuk form
  final _sessionNameCtrl = TextEditingController();
  final _questionNameCtrl = TextEditingController();
  final _examPeriodCtrl = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _endDateCtrl = TextEditingController();
  final _startTimeCtrl = TextEditingController();
  final _endTimeCtrl = TextEditingController();
  final _passingScoreCtrl = TextEditingController(text: "70");
  final _maxAttemptCtrl = TextEditingController(text: "1");

  @override
  void dispose() {
    _sessionNameCtrl.dispose();
    _questionNameCtrl.dispose();
    _examPeriodCtrl.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    _startTimeCtrl.dispose();
    _endTimeCtrl.dispose();
    _passingScoreCtrl.dispose();
    _maxAttemptCtrl.dispose();
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
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.indigo.shade600,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.indigo.shade600,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        controller.text = formattedDate;
      });
    }
  }

  // --- FUNGSI UNTUK MEMUNCULKAN JAM (TIME PICKER) ---
  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.indigo.shade600,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.indigo.shade600,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        final String hour = pickedTime.hour.toString().padLeft(2, '0');
        final String minute = pickedTime.minute.toString().padLeft(2, '0');
        controller.text = "$hour:$minute";
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
              colors: [Colors.indigo.shade400, Colors.blue.shade600],
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
          "Add New Session",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),

      // --- BODY SCROLL FORM ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
        child: Column(
          children: [
            // 1. SECTION: SUBJECT CLASS (Read Only)
            _buildSectionCard(
              title: "Subject Class",
              icon: Icons.school_rounded,
              iconColor: Colors.purple,
              children: [
                _buildReadOnlyField("Subject Class Code", widget.subjectData['classCode']),
                const SizedBox(height: 15),
                _buildReadOnlyField("Subject Class Name", widget.subjectData['className'], isRequired: true),
              ],
            ),
            const SizedBox(height: 20),

            // 2. SECTION: SESSION DETAILS
            _buildSectionCard(
              title: "Session Details",
              icon: Icons.topic_rounded,
              iconColor: Colors.orange,
              children: [
                _buildReadOnlyField("Session ID", "Auto-generated", isRequired: true),
                const SizedBox(height: 15),
                _buildInputField(
                    label: "Session Name",
                    controller: _sessionNameCtrl,
                    hint: "Enter session name",
                    icon: Icons.edit_note_rounded,
                    isRequired: true
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 3. SECTION: EXAM CONFIGURATION
            _buildSectionCard(
              title: "Exam Configuration",
              icon: Icons.settings_suggest_rounded,
              iconColor: Colors.blue,
              children: [
                _buildInputField(
                    label: "Question Name",
                    controller: _questionNameCtrl,
                    hint: "Input Question",
                    icon: Icons.quiz_rounded,
                    isRequired: true
                ),
                const SizedBox(height: 15),
                _buildInputField(
                    label: "Exam Period Name",
                    controller: _examPeriodCtrl,
                    hint: "Input Exam Period",
                    icon: Icons.date_range_rounded,
                    isRequired: true
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4. SECTION: TIME & SCORING
            _buildSectionCard(
              title: "Time & Scoring",
              icon: Icons.access_time_filled_rounded,
              iconColor: Colors.teal,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _buildInputField(
                            label: "Start Date",
                            controller: _startDateCtrl,
                            hint: "Select date",
                            icon: Icons.calendar_today_rounded,
                            isRequired: true,
                            readOnly: true,
                            onTap: () => _selectDate(context, _startDateCtrl)
                        )
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                        child: _buildInputField(
                            label: "End Date",
                            controller: _endDateCtrl,
                            hint: "Select date",
                            icon: Icons.event_available_rounded,
                            isRequired: true,
                            readOnly: true,
                            onTap: () => _selectDate(context, _endDateCtrl)
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                        child: _buildInputField(
                            label: "Start Time",
                            controller: _startTimeCtrl,
                            hint: "Select time",
                            icon: Icons.schedule_rounded,
                            isRequired: true,
                            readOnly: true,
                            onTap: () => _selectTime(context, _startTimeCtrl)
                        )
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                        child: _buildInputField(
                            label: "End Time",
                            controller: _endTimeCtrl,
                            hint: "Select time",
                            icon: Icons.timer_off_rounded,
                            isRequired: true,
                            readOnly: true,
                            onTap: () => _selectTime(context, _endTimeCtrl)
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                        child: _buildInputField(
                            label: "Passing Score",
                            controller: _passingScoreCtrl,
                            hint: "e.g. 70",
                            icon: Icons.verified_rounded,
                            isRequired: true,
                            isNumber: true
                        )
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                        child: _buildInputField(
                            label: "Max Attempt",
                            controller: _maxAttemptCtrl,
                            hint: "e.g. 1",
                            icon: Icons.replay_rounded,
                            isRequired: true,
                            isNumber: true
                        )
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
                // ✅ LOGIKA SUBMIT DAN MENGIRIM DATA KEMBALI
                onPressed: () {
                  if (_sessionNameCtrl.text.isNotEmpty && _startDateCtrl.text.isNotEmpty) {

                    // Membungkus data yang diinput menjadi sebuah Map
                    final newSession = {
                      "id": "SES${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
                      "name": _sessionNameCtrl.text,
                      "date": _startDateCtrl.text,
                      "startTime": _startTimeCtrl.text,
                      "endTime": _endTimeCtrl.text,
                    };

                    // Mengirim data ini ke halaman sebelumnya (EditExamManagementPage)
                    Navigator.pop(context, newSession);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Session Added Successfully!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
                    );
                  } else {
                    // Tampilkan error jika form kosong
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill the Session Name & Start Date!"), backgroundColor: Colors.red),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text("Submit Session", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
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
                  color: Color(0xFF1A237E),
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

  Widget _buildReadOnlyField(String label, String value, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontFamily: 'Roboto'),
            children: [
              if (isRequired) const TextSpan(text: " *", style: TextStyle(color: Colors.red)),
            ],
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
            prefixIcon: Icon(icon, color: Colors.indigo.shade300, size: 18),
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
              borderSide: BorderSide(color: Colors.indigo.shade400, width: 1.5),
            ),
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}