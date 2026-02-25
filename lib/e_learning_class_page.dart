import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class ELearningClassPage extends StatefulWidget {
  const ELearningClassPage({super.key});

  @override
  State<ELearningClassPage> createState() => _ELearningClassPageState();
}

class _ELearningClassPageState extends State<ELearningClassPage> {
  // =========================================================
  // STATE PENGENDALI HALAMAN (ALL-IN-ONE)
  // 0: Daftar Kelas (Class List)
  // 1: Daftar Mata Pelajaran (Subject List)
  // 2: Daftar Bab/Materi (Section List)
  // 3: Detail Materi & Tugas (Section Details)
  // =========================================================
  int _currentView = 0;

  // Data Holder
  Map<String, String>? _selectedClass;
  Map<String, String>? _selectedSubject;
  Map<String, dynamic>? _selectedSection;

  int _selectedTab = 0; // 0: Material, 1: Assignment

  final TextEditingController _classSearchCtrl = TextEditingController();
  final TextEditingController _subjectSearchCtrl = TextEditingController();
  final TextEditingController _sectionSearchCtrl = TextEditingController();

  final List<Map<String, String>> _allClasses = [
    {"code": "X_AK_1", "name": "X AK 1", "period": "2025"},
    {"code": "X_BD_1", "name": "X BD 1", "period": "2025"},
    {"code": "X_DKV_1", "name": "X DKV 1", "period": "2025"},
  ];

  final Map<String, List<Map<String, String>>> _subjectDatabase = {
    "X_AK_1": [
      {"code": "APA", "name": "Aplikasi Pengolah Angka (Spreadsheet)", "teacher": "Muhammad Arafi Azis, S.E., M.M"},
      {"code": "BINDO", "name": "Bahasa Indonesia", "teacher": "Yusniarti Nurahmah, S.Pd"},
    ],
    "X_BD_1": [
      {"code": "DMNP", "name": "Dasar Manajemen Pemasaran", "teacher": "Fachrur Rozi, SM"},
      {"code": "DS", "name": "Dasar Keahlian", "teacher": "Wiwi Tarwiyah, S.E"},
    ],
    "X_DKV_1": [
      {"code": "DPPDKV", "name": "Dasar Proses Produksi DKV", "teacher": "Hafiz Alwi Ubaido, S.Kom"},
      {"code": "IT", "name": "Informatika", "teacher": "Achmadi"},
    ],
  };

  // Database Section
  final Map<String, List<Map<String, dynamic>>> _sectionDatabase = {};

  List<Map<String, String>> _filteredClasses = [];
  List<Map<String, String>> _currentClassSubjects = [];
  List<Map<String, String>> _filteredSubjects = [];
  List<Map<String, dynamic>> _currentSubjectSections = [];
  List<Map<String, dynamic>> _filteredSections = [];

  final Color elearningBaseDark = const Color(0xFF512DA8);
  final Color elearningBaseLight = const Color(0xFF9575CD);
  final Color textDark = const Color(0xFF1E293B);

  final List<Color> premiumTints = [const Color(0xFFE8F0FE), const Color(0xFFEAF5E9), const Color(0xFFFFF0EC), const Color(0xFFF3E8FF)];
  final List<Color> premiumDarkTints = [const Color(0xFF4A90E2), const Color(0xFF43A047), const Color(0xFFE57373), const Color(0xFF9C27B0)];

  @override
  void initState() {
    super.initState();
    _filteredClasses = _allClasses;
  }

  @override
  void dispose() {
    _classSearchCtrl.dispose();
    _subjectSearchCtrl.dispose();
    _sectionSearchCtrl.dispose();
    super.dispose();
  }

  void _filterClasses(String query) => setState(() => _filteredClasses = _allClasses.where((cls) => cls['name']!.toLowerCase().contains(query.toLowerCase()) || cls['code']!.toLowerCase().contains(query.toLowerCase())).toList());
  void _filterSubjects(String query) => setState(() => _filteredSubjects = _currentClassSubjects.where((sub) => sub['name']!.toLowerCase().contains(query.toLowerCase()) || sub['code']!.toLowerCase().contains(query.toLowerCase()) || sub['teacher']!.toLowerCase().contains(query.toLowerCase())).toList());
  void _filterSections(String query) => setState(() => _filteredSections = _currentSubjectSections.where((sec) => sec['name']!.toLowerCase().contains(query.toLowerCase()) || sec['remark']!.toLowerCase().contains(query.toLowerCase())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF8FAFC), Color(0xFFEEF2F6)])),
        child: _buildCurrentView(),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case 0: return _buildClassScreen();
      case 1: return _buildSubjectScreen();
      case 2: return _buildSectionScreen();
      case 3: return _buildSectionDetailScreen();
      default: return _buildClassScreen();
    }
  }

  // =========================================================
  // VIEW 0: TAMPILAN CLASS LIST
  // =========================================================
  Widget _buildClassScreen() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120, floating: false, pinned: true, backgroundColor: Colors.transparent, elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [elearningBaseDark, elearningBaseLight]), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)), boxShadow: [BoxShadow(color: elearningBaseDark.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))]),
            child: Stack(children: [Positioned(top: -30, right: -20, child: Container(width: 130, height: 130, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)))), const FlexibleSpaceBar(titlePadding: EdgeInsets.only(left: 60, bottom: 20), title: Text("E-Learning Classes", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white, letterSpacing: 0.5)))]),
          ),
          leading: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context))),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))], border: Border.all(color: Colors.grey.shade200)), child: TextField(controller: _classSearchCtrl, onChanged: _filterClasses, decoration: InputDecoration(icon: Icon(Icons.search_rounded, color: elearningBaseLight, size: 22), hintText: "Search your class...", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13), border: InputBorder.none))), const SizedBox(height: 25),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Available Classes", style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: elearningBaseDark.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Text("${_filteredClasses.length} found", style: TextStyle(color: elearningBaseDark, fontSize: 11, fontWeight: FontWeight.bold)))]),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.88),
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildClassCard(_filteredClasses[index], premiumTints[index % premiumTints.length], premiumDarkTints[index % premiumDarkTints.length]);
            }, childCount: _filteredClasses.length),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // VIEW 1: TAMPILAN SUBJECT LIST
  // =========================================================
  Widget _buildSubjectScreen() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 130, floating: false, pinned: true, backgroundColor: Colors.transparent, elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [elearningBaseDark, elearningBaseLight]), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)), boxShadow: [BoxShadow(color: elearningBaseDark.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))]),
            child: Stack(children: [Positioned(top: -30, right: -20, child: Container(width: 130, height: 130, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)))), FlexibleSpaceBar(titlePadding: const EdgeInsets.only(left: 60, bottom: 20), title: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Subject List", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white)), Text("Class: ${_selectedClass?['name']}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.white.withOpacity(0.8)))]))]),
          ),
          leading: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20), onPressed: () => setState(() { _currentView = 0; _subjectSearchCtrl.clear(); }))),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))], border: Border.all(color: Colors.grey.shade200)), child: TextField(controller: _subjectSearchCtrl, onChanged: _filterSubjects, decoration: InputDecoration(icon: Icon(Icons.search_rounded, color: elearningBaseLight, size: 22), hintText: "Search subject or teacher...", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13), border: InputBorder.none))), const SizedBox(height: 25),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Course Modules", style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: elearningBaseDark.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Text("${_filteredSubjects.length} modules", style: TextStyle(color: elearningBaseDark, fontSize: 11, fontWeight: FontWeight.bold)))]),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.70),
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildSubjectCard(_filteredSubjects[index], premiumTints[(index + 3) % premiumTints.length], premiumDarkTints[(index + 3) % premiumDarkTints.length]);
            }, childCount: _filteredSubjects.length),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // VIEW 2: TAMPILAN SECTION LIST
  // =========================================================
  Widget _buildSectionScreen() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 140, floating: false, pinned: true, backgroundColor: Colors.transparent, elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [elearningBaseDark, elearningBaseLight]), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)), boxShadow: [BoxShadow(color: elearningBaseDark.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))]),
            child: Stack(children: [Positioned(top: -30, right: -20, child: Container(width: 130, height: 130, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)))), FlexibleSpaceBar(titlePadding: const EdgeInsets.only(left: 60, bottom: 20, right: 20), title: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Section List", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white)), Text("${_selectedSubject?['name']}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.white.withOpacity(0.8)), maxLines: 1, overflow: TextOverflow.ellipsis)]))]),
          ),
          leading: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20), onPressed: () => setState(() { _currentView = 1; _sectionSearchCtrl.clear(); }))),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
            child: Row(
              children: [
                Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))], border: Border.all(color: Colors.grey.shade200)), child: TextField(controller: _sectionSearchCtrl, onChanged: _filterSections, decoration: InputDecoration(icon: Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 22), hintText: "Search section...", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13), border: InputBorder.none)))), const SizedBox(width: 15),
                InkWell(onTap: _showAddSectionModal, borderRadius: BorderRadius.circular(18), child: Container(height: 55, width: 55, decoration: BoxDecoration(color: elearningBaseDark, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: elearningBaseDark.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]), child: const Icon(Icons.add_rounded, color: Colors.white, size: 28)))
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10), child: Text("${_filteredSections.length} sections available", style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)))),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
          sliver: _filteredSections.isEmpty
              ? SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.folder_open_rounded, size: 80, color: Colors.grey.shade300), const SizedBox(height: 15),
                    Text("No Section Found", style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 5),
                    Text("Tap the '+' button to add a new section.", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  ],
                ),
              ),
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildSectionCard(_filteredSections[index]);
            }, childCount: _filteredSections.length),
          ),
        )
      ],
    );
  }

  // =========================================================
  // VIEW 3: TAMPILAN DETAIL MATERI & TUGAS
  // =========================================================
  Widget _buildSectionDetailScreen() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [elearningBaseDark, elearningBaseLight]),
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            boxShadow: [BoxShadow(color: elearningBaseDark.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => setState(() { _currentView = 2; _selectedTab = 0; }),
                    child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(child: Text(_selectedSection?['name'] ?? "Section Detail", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Expanded(child: _buildCustomTab("Material", 0, Icons.menu_book_rounded)),
                    Expanded(child: _buildCustomTab("Assignment", 1, Icons.assignment_turned_in_rounded)),
                  ],
                ),
              )
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: _selectedTab == 0 ? _buildMaterialContent() : _buildAssignmentContent(),
          ),
        )
      ],
    );
  }

  Widget _buildMaterialContent() {
    final String description = _selectedSection?['materialDesc'] ?? "Welcome to ${_selectedSection?['name']}. In this session, we will cover the foundational theories. Please watch the video above and read the attached documents before proceeding to the assignment.";
    final String fileName = _selectedSection?['fileName'] ?? "Syllabus_Guide.pdf";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity, height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))],
            image: DecorationImage(image: const NetworkImage("https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=600"), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)),
          ),
          child: Center(child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: elearningBaseDark.withOpacity(0.9), shape: BoxShape.circle, boxShadow: [BoxShadow(color: elearningBaseDark.withOpacity(0.5), blurRadius: 20)]), child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40))),
        ),
        const SizedBox(height: 25),

        Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark)), const SizedBox(height: 10),
        Text(description, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.6), textAlign: TextAlign.justify),
        const SizedBox(height: 25),

        Text("Attachments", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark)), const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
          child: Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.picture_as_pdf_rounded, color: Colors.red.shade400)), const SizedBox(width: 15),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(fileName, style: TextStyle(fontWeight: FontWeight.bold, color: textDark), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 4), Text("2.4 MB", style: TextStyle(fontSize: 11, color: Colors.grey.shade500))])),
              IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded, color: Colors.blue)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildAssignmentContent() {
    final String instructions = _selectedSection?['assignmentDesc'] ?? "1. Summarize the material in your own words.\n2. Write minimum 500 words.\n3. Upload your work in PDF format.\n4. Late submissions will receive a 10% penalty.";
    final String dueDate = _selectedSection?['dueDate'] ?? "Friday, 28 Feb 2026 - 23:59 PM";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity, padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.orange.shade200)),
          child: Row(
            children: [
              Icon(Icons.timer_rounded, color: Colors.orange.shade700, size: 28), const SizedBox(width: 15),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Due Date", style: TextStyle(fontSize: 12, color: Colors.orange.shade800, fontWeight: FontWeight.bold)), const SizedBox(height: 2), Text(dueDate, style: TextStyle(fontWeight: FontWeight.w800, color: textDark, fontSize: 14))])),
            ],
          ),
        ),
        const SizedBox(height: 25),

        Text("Instructions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark)), const SizedBox(height: 10),
        Container(
          width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
          child: Text(instructions, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.8)),
        ),
        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              // ✅ CONTOH UPLOAD ASSIGNMENT MENGGUNAKAN FILE PICKER
              try {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully uploaded: ${result.files.single.name}"), backgroundColor: Colors.green));
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Upload cancelled / failed"), backgroundColor: Colors.red));
              }
            },
            icon: const Icon(Icons.cloud_upload_rounded, color: Colors.white), label: const Text("Upload Assignment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            style: ElevatedButton.styleFrom(backgroundColor: elearningBaseDark, padding: const EdgeInsets.symmetric(vertical: 18), elevation: 4, shadowColor: elearningBaseDark.withOpacity(0.4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          ),
        )
      ],
    );
  }

  Widget _buildCustomTab(String title, int index, IconData icon) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(15), boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)] : []),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 16, color: isSelected ? elearningBaseDark : Colors.white70), const SizedBox(width: 8), Text(title, style: TextStyle(color: isSelected ? elearningBaseDark : Colors.white70, fontWeight: FontWeight.bold, fontSize: 13))]),
      ),
    );
  }

  // =========================================================
  // CARD BUILDERS
  // =========================================================
  Widget _buildClassCard(Map<String, String> cls, Color tintColor, Color darkTintColor) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: darkTintColor.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8))], border: Border.all(color: tintColor, width: 1.5)),
      child: Stack(
        children: [
          Positioned(top: -20, right: -20, child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: tintColor.withOpacity(0.5)))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: tintColor, borderRadius: BorderRadius.circular(12)), child: Icon(Icons.apartment_rounded, color: darkTintColor, size: 20)), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade200)), child: Text(cls['period']!, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w700)))]), const Spacer(), Text(cls['code']!, style: TextStyle(fontSize: 10, color: darkTintColor, fontWeight: FontWeight.w800, letterSpacing: 1), maxLines: 1), const SizedBox(height: 4), Text(cls['name']!, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: textDark), maxLines: 1, overflow: TextOverflow.ellipsis)]))),
              InkWell(onTap: () => setState(() { _selectedClass = cls; _currentClassSubjects = _subjectDatabase[cls['code']] ?? [{"code": "N/A", "name": "Belum Ada Modul", "teacher": "-"}]; _filteredSubjects = _currentClassSubjects; _currentView = 1; }), child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: tintColor.withOpacity(0.4), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Enter Class", style: TextStyle(color: darkTintColor, fontSize: 13, fontWeight: FontWeight.w800)), const SizedBox(width: 4), Icon(Icons.arrow_forward_rounded, color: darkTintColor, size: 16)]))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, String> subject, Color tintColor, Color darkTintColor) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: darkTintColor.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8))], border: Border.all(color: tintColor, width: 1.5)),
      child: Stack(
        children: [
          Positioned(top: -10, left: -10, child: Icon(Icons.auto_stories_rounded, size: 60, color: tintColor)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Align(alignment: Alignment.centerRight, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: tintColor, borderRadius: BorderRadius.circular(6)), child: Text(subject['code']!, style: TextStyle(fontSize: 10, color: darkTintColor, fontWeight: FontWeight.w900, letterSpacing: 0.5), maxLines: 1))), const SizedBox(height: 15), Text(subject['name']!, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: textDark, height: 1.3), maxLines: 3, overflow: TextOverflow.ellipsis), const Spacer(), Container(height: 1, width: 30, color: tintColor, margin: const EdgeInsets.only(bottom: 8)), Text("Teacher", style: TextStyle(fontSize: 9, color: Colors.grey.shade500, fontWeight: FontWeight.w600)), Text(subject['teacher']!, style: TextStyle(fontSize: 11, color: darkTintColor, fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis)]))),
              InkWell(onTap: () => setState(() { _selectedSubject = subject; String key = "${_selectedClass?['code']}_${subject['code']}"; if (!_sectionDatabase.containsKey(key)) _sectionDatabase[key] = [{"id": "SEC-001", "name": "Chapter 1: Introduction", "remark": "Basic concepts and overview.", "date": "24 Feb 2026", "materialDesc": "Welcome to Chapter 1.", "fileName": "Intro_Doc.pdf", "assignmentDesc": "Summarize the basic concepts.", "dueDate": "Friday, 28 Feb 2026 - 23:59 PM"}]; _currentSubjectSections = _sectionDatabase[key]!; _filteredSections = _currentSubjectSections; _currentView = 2; }), child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: elearningBaseDark, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Text("Open Module", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)), SizedBox(width: 6), Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 14)]))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(Map<String, dynamic> section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))], border: Border.all(color: Colors.grey.shade100, width: 1.5)),
      child: Material(
        color: Colors.transparent, borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setState(() { _selectedSection = section; _currentView = 3; _selectedTab = 0; }),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: elearningBaseDark.withOpacity(0.08), borderRadius: BorderRadius.circular(15)), child: Icon(Icons.folder_copy_rounded, color: elearningBaseDark, size: 26)), const SizedBox(width: 20),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(section['name']!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textDark), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 6), Text(section['remark']!, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis), const SizedBox(height: 10), Row(children: [Icon(Icons.access_time_rounded, size: 12, color: Colors.grey.shade400), const SizedBox(width: 4), Text("Added: ${section['date']}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade500))])])),
                Container(margin: const EdgeInsets.only(left: 10), padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)), child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade600))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // MODAL: ADD SECTION FORM (DENGAN FILE PICKER ASLI)
  // =========================================================
  void _showAddSectionModal() {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController remarkCtrl = TextEditingController();
    final TextEditingController materialDescCtrl = TextEditingController();
    final TextEditingController assignDescCtrl = TextEditingController();
    final TextEditingController dateCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // State Lokal untuk UI File Picker
    String uploadedFileName = "";
    bool isUploading = false;

    showModalBottomSheet(
        context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: elearningBaseDark.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.post_add_rounded, color: elearningBaseDark, size: 22)), const SizedBox(width: 15), Text("Add New Section", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: textDark))]),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 25), child: Divider(height: 30)),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFormHeader("1. General Information"),
                                Text("Section Name *", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)), const SizedBox(height: 8),
                                _buildTextField(nameCtrl, "e.g. Chapter 3: Advanced Topic"), const SizedBox(height: 15),
                                Text("Short Remark *", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)), const SizedBox(height: 8),
                                _buildTextField(remarkCtrl, "Brief overview to show on the card..."), const SizedBox(height: 25),

                                _buildFormHeader("2. Material Content"),
                                Text("Material Description", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)), const SizedBox(height: 8),
                                _buildTextField(materialDescCtrl, "Detailed explanation for students...", maxLines: 4), const SizedBox(height: 15),

                                Text("Attachment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)), const SizedBox(height: 8),

                                // ✅ FUNGSI FILE PICKER ASLI
                                InkWell(
                                  onTap: () async {
                                    if (uploadedFileName.isNotEmpty) {
                                      // Hapus file jika di-klik saat sudah ada file
                                      setModalState(() { uploadedFileName = ""; });
                                      return;
                                    }

                                    setModalState(() { isUploading = true; });

                                    try {
                                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['pdf', 'ppt', 'pptx', 'mp4', 'doc', 'docx'],
                                      );

                                      if (result != null) {
                                        setModalState(() {
                                          uploadedFileName = result.files.single.name;
                                          isUploading = false;
                                        });
                                      } else {
                                        // User membatalkan pemilihan file
                                        setModalState(() { isUploading = false; });
                                      }
                                    } catch (e) {
                                      setModalState(() { isUploading = false; });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Error selecting file: $e"), backgroundColor: Colors.red)
                                      );
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: uploadedFileName.isEmpty ? Colors.blue.shade50 : Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: uploadedFileName.isEmpty ? Colors.blue.shade100 : Colors.green.shade200, style: BorderStyle.solid)
                                    ),
                                    child: isUploading
                                        ? const Center(child: CircularProgressIndicator(color: Colors.blue))
                                        : uploadedFileName.isEmpty
                                        ? Column(
                                      children: [
                                        Icon(Icons.cloud_upload_rounded, color: Colors.blue.shade400, size: 30),
                                        const SizedBox(height: 5),
                                        Text("Tap to upload PDF, PPT, or Video", style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.w600))
                                      ],
                                    )
                                        : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 24),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(uploadedFileName, style: TextStyle(color: Colors.green.shade800, fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.close_rounded, color: Colors.red, size: 18)
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),

                                _buildFormHeader("3. Assignment Details"),
                                Text("Instructions", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)), const SizedBox(height: 8),
                                _buildTextField(assignDescCtrl, "1. Read the document...\n2. Answer the questions...", maxLines: 4), const SizedBox(height: 15),

                                Text("Due Date", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)), const SizedBox(height: 8),
                                InkWell(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030), builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF512DA8))), child: child!));
                                    if (pickedDate != null) setModalState(() => dateCtrl.text = DateFormat('EEEE, dd MMM yyyy - 23:59 PM').format(pickedDate));
                                  },
                                  child: IgnorePointer(child: _buildTextField(dateCtrl, "Select deadline...", icon: Icons.calendar_month_rounded)),
                                ),

                                const SizedBox(height: 35),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
                        child: Row(
                          children: [
                            Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), side: BorderSide(color: Colors.grey.shade300)), child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))), const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      String key = "${_selectedClass?['code']}_${_selectedSubject?['code']}";
                                      _sectionDatabase[key]!.add({
                                        "id": "SEC-00${_sectionDatabase[key]!.length + 1}",
                                        "name": nameCtrl.text,
                                        "remark": remarkCtrl.text,
                                        "date": DateFormat('dd MMM yyyy').format(DateTime.now()),
                                        "materialDesc": materialDescCtrl.text.isNotEmpty ? materialDescCtrl.text : "No detailed description provided.",
                                        "assignmentDesc": assignDescCtrl.text.isNotEmpty ? assignDescCtrl.text : "No specific assignment instructions.",
                                        "dueDate": dateCtrl.text.isNotEmpty ? dateCtrl.text : "No Deadline",
                                        "fileName": uploadedFileName.isNotEmpty ? uploadedFileName : "Uploaded_Document.pdf"
                                      });
                                      _filterSections(_sectionSearchCtrl.text);
                                    });
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Section added completely!"), backgroundColor: Colors.green));
                                  }
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: elearningBaseDark, padding: const EdgeInsets.symmetric(vertical: 16), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Save Section", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }

  Widget _buildFormHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: elearningBaseLight.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Text(title, style: TextStyle(color: elearningBaseDark, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1, IconData? icon}) {
    return TextFormField(
      controller: controller, maxLines: maxLines, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade500, size: 20) : null,
          hintText: hint, hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
          filled: true, fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: elearningBaseDark, width: 1.5))
      ),
      validator: (val) => maxLines == 1 && val!.isEmpty ? 'Required' : null,
    );
  }
}