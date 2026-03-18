import 'package:flutter/material.dart';
import '../viewmodel/ClassActivity_viewmodel.dart';
import 'class_activity_subject_page.dart';

class ClassActivityPage extends StatefulWidget {
  const ClassActivityPage({super.key});

  @override
  State<ClassActivityPage> createState() => _ClassActivityPageState();
}

class _ClassActivityPageState extends State<ClassActivityPage> {
  final ClassActivityViewmodel _viewModel = ClassActivityViewmodel();

  bool _isLoading = true;
  List<dynamic> _allClasses = [];
  List<dynamic> _filteredClasses = [];
  final TextEditingController _searchCtrl = TextEditingController();

  final Color gradientStart = const Color(0xFF6366F1);
  final Color gradientEnd = const Color(0xFF38BDF8);
  final Color accentPink = const Color(0xFFEC4899);
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
      var resp = await _viewModel.fetchClassList();
      if (!mounted) return;

      if (resp.data != null) {
        setState(() {
          _allClasses = resp.data ?? [];
          _filteredClasses = _allClasses;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        _showError(resp.message ?? "Gagal mengambil data dari server.");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError("Terjadi kesalahan sistem: $e");
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: accentPink, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
    }
  }

  void _filterData(String query) {
    setState(() {
      _filteredClasses = _allClasses.where((data) {
        final className = data['class_name']?.toString().toLowerCase() ?? '';
        final gradeCode = data['grade_code']?.toString().toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return className.contains(searchLower) || gradeCode.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSlate,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: gradientStart,
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 16)),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text("Class Activity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.5)),
              background: Container(
                decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [gradientStart, gradientEnd])),
                child: Stack(
                  children: [
                    Positioned(right: -30, top: -20, child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withOpacity(0.1))),
                    Positioned(left: 40, top: 50, child: CircleAvatar(radius: 15, backgroundColor: accentPink.withOpacity(0.2))),
                    Positioned(right: 80, bottom: -40, child: CircleAvatar(radius: 40, backgroundColor: Colors.white.withOpacity(0.05))),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: gradientStart.withOpacity(0.06), blurRadius: 25, offset: const Offset(0, 10))]),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: _filterData,
                  decoration: InputDecoration(
                    prefixIcon: Padding(padding: const EdgeInsets.only(left: 20, right: 10), child: Icon(Icons.search_rounded, color: gradientStart, size: 22)),
                    hintText: "Search class name or grade...",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ),
          ),

          if (_isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else if (_filteredClasses.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildModernClassCard(_filteredClasses[index]),
                  childCount: _filteredClasses.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernClassCard(Map<String, dynamic> data) {
    String className = data['class_name']?.toString() ?? "Unknown";
    String gradeCode = data['grade_code']?.toString() ?? "-";
    String periodYear = data['periodyear_code']?.toString() ?? "2025";
    String classCode = data['class_code']?.toString() ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
          BoxShadow(color: gradientStart.withOpacity(0.01), blurRadius: 5, offset: const Offset(0, -2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            if (classCode.isNotEmpty) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ClassActivitySubjectPage(classCode: classCode)));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  height: 60, width: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [gradientStart.withOpacity(0.15), gradientEnd.withOpacity(0.05)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(child: Icon(Icons.school_outlined, color: gradientStart, size: 28)),
                ),
                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(className, style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 16, height: 1.1)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildModernChip("Grade $gradeCode", gradientStart.withOpacity(0.1), gradientStart),
                          const SizedBox(width: 8),
                          _buildModernChip(periodYear, accentPink.withOpacity(0.1), accentPink),
                        ],
                      )
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
                  child: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: textDark.withOpacity(0.6)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: gradientStart.withOpacity(0.1), blurRadius: 20)]),
            child: Icon(Icons.class_outlined, size: 70, color: gradientStart.withOpacity(0.4)),
          ),
          const SizedBox(height: 24),
          Text("No Classes Found", style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 8),
          Text("There is no class data for this role.", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        ],
      ),
    );
  }
}