import 'package:flutter/material.dart';
import '../viewmodel/ClassActivity_viewmodel.dart';
import 'class_activity_list_page.dart';

class ClassActivitySubjectPage extends StatefulWidget {
  final String classCode;

  const ClassActivitySubjectPage({super.key, required this.classCode});

  @override
  State<ClassActivitySubjectPage> createState() => _ClassActivitySubjectPageState();
}

class _ClassActivitySubjectPageState extends State<ClassActivitySubjectPage> {
  final ClassActivityViewmodel _viewModel = ClassActivityViewmodel();

  bool _isLoading = true;
  Map<String, dynamic>? _classDetail;
  List<dynamic> _allSubjects = [];
  List<dynamic> _filteredSubjects = [];
  final TextEditingController _searchCtrl = TextEditingController();

  final Color gradientStart = const Color(0xFFEC4899);
  final Color gradientEnd = const Color(0xFF6366F1);
  final Color gradientSecondary = const Color(0xFF38BDF8);
  final Color bgSlate = const Color(0xFFF1F5F9);
  final Color textDark = const Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _fetchDataFromViewModel();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchDataFromViewModel() async {
    setState(() => _isLoading = true);
    try {
      var results = await Future.wait([
        _viewModel.fetchClassDetail(widget.classCode),
        _viewModel.fetchSubjectList(widget.classCode)
      ]);

      if (!mounted) return;

      var detailResp = results[0];
      var listResp = results[1];

      if (detailResp.data != null || listResp.data != null) {
        setState(() {
          _classDetail = detailResp.data;
          _allSubjects = listResp.data ?? [];
          _filteredSubjects = _allSubjects;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        _showError(detailResp.message ?? "Gagal mengambil data dari server.");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError("Terjadi kesalahan sistem: $e");
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: gradientStart));
    }
  }

  void _filterData(String query) {
    setState(() {
      _filteredSubjects = _allSubjects.where((data) {
        final subName = data['subject_name']?.toString().toLowerCase() ?? '';
        final teacherName = data['teacher_name']?.toString().toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return subName.contains(searchLower) || teacherName.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSlate,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: gradientEnd))
          : CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: gradientEnd,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 16)),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [gradientStart, gradientEnd]))),

                  Positioned(right: -80, top: -50, child: Container(width: 250, height: 250, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)))),
                  Positioned(left: -30, bottom: 40, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: gradientSecondary.withOpacity(0.15)))),
                  Positioned(left: 100, top: 60, child: Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)))),

                  Positioned(
                    bottom: 40, left: 20, right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text(_classDetail?['class_code']?.toString() ?? "-", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1))),
                        const SizedBox(height: 12),
                        Text(_classDetail?['class_name']?.toString() ?? "Subjects", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28, height: 1.1, letterSpacing: -1)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: gradientEnd.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))]),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: _filterData,
                  decoration: InputDecoration(
                    prefixIcon: Padding(padding: const EdgeInsets.only(left: 20, right: 10), child: Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 22)),
                    hintText: "Search subject or teacher...",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ),
          ),

          if (_filteredSubjects.isEmpty)
            SliverFillRemaining(child: Center(child: Text("No subjects found.", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold))))
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildModernSubjectCard(_filteredSubjects[index]),
                  childCount: _filteredSubjects.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernSubjectCard(Map<String, dynamic> data) {
    String subjectName = data['subject_name']?.toString() ?? "-";
    String subjectCode = data['subject_code']?.toString() ?? "-";
    String teacherName = data['teacher_name']?.toString() ?? "No Teacher Assigned";
    if (teacherName.isEmpty) teacherName = "No Teacher Assigned";

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 10)),
          BoxShadow(color: gradientEnd.withOpacity(0.01), blurRadius: 5, offset: const Offset(0, -2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildSubjectIcon(subjectName),
                const SizedBox(width: 12),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: bgSlate, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade100)), child: Text(subjectCode, style: TextStyle(color: gradientEnd, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5))),

                const Spacer(),

                _buildModernSelectButton(subjectName, data['subjectclass_code']?.toString() ?? ""),
              ],
            ),
            const SizedBox(height: 20),

            Text(subjectName, style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 19, height: 1.1, letterSpacing: -0.5)),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 5))]),
              child: Row(
                children: [
                  CircleAvatar(radius: 12, backgroundColor: Colors.grey.shade100, child: Icon(Icons.person_outline_rounded, size: 14, color: Colors.grey.shade600)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(teacherName, style: TextStyle(fontSize: 13, color: textDark.withOpacity(0.8), fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectIcon(String name) {
    String firstChar = name.isNotEmpty ? name[0].toUpperCase() : "?";
    List<Color> iconColors = (firstChar.codeUnitAt(0) % 2 == 0) ? [gradientEnd, gradientSecondary] : [gradientStart, const Color(0xFFFBBF24)];

    return Container(
      height: 36, width: 36,
      decoration: BoxDecoration(gradient: LinearGradient(colors: [iconColors[0].withOpacity(0.1), iconColors[1].withOpacity(0.1)]), shape: BoxShape.circle),
      child: Center(child: Text(firstChar, style: TextStyle(color: iconColors[0], fontWeight: FontWeight.bold, fontSize: 16))),
    );
  }

  Widget _buildModernSelectButton(String subjectName, String subjectClassCode) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [gradientStart, gradientEnd]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: gradientEnd.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]
      ),
      child: ElevatedButton(
        onPressed: () {
          if (subjectClassCode.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassActivityListPage(
                  classCode: widget.classCode,
                  subjectClassCode: subjectClassCode,
                ),
              ),
            );
          } else {
            _showError("Kode Subjek tidak valid.");
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), visualDensity: VisualDensity.compact),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(width: 5),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }
}