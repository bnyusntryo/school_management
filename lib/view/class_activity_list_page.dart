import 'package:flutter/material.dart';
import '../viewmodel/ClassActivity_viewmodel.dart';
import 'class_activity_edit_page.dart';

class ClassActivityListPage extends StatefulWidget {
  final String classCode;
  final String subjectClassCode;

  const ClassActivityListPage({super.key, required this.classCode, required this.subjectClassCode});

  @override
  State<ClassActivityListPage> createState() => _ClassActivityListPageState();
}

class _ClassActivityListPageState extends State<ClassActivityListPage> {
  final ClassActivityViewmodel _viewModel = ClassActivityViewmodel();

  bool _isLoading = true;
  Map<String, dynamic>? _subjectDetail;
  List<dynamic> _allActivities = [];
  List<dynamic> _filteredActivities = [];
  final TextEditingController _searchCtrl = TextEditingController();

  final Color gradientStart = const Color(0xFF0EA5E9);
  final Color gradientEnd = const Color(0xFF10B981);
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
        _viewModel.fetchSubjectDetail(widget.subjectClassCode),
        _viewModel.fetchActivityList(widget.classCode, widget.subjectClassCode)
      ]);

      if (!mounted) return;

      var detailResp = results[0];
      var listResp = results[1];

      if (detailResp.data != null || listResp.data != null) {
        setState(() {
          _subjectDetail = detailResp.data;
          _allActivities = listResp.data ?? [];
          _filteredActivities = _allActivities;
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: gradientStart, behavior: SnackBarBehavior.floating));
    }
  }

  void _filterData(String query) {
    setState(() {
      _filteredActivities = _allActivities.where((data) {
        final activityName = data['classactivity_name']?.toString().toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return activityName.contains(searchLower);
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
            expandedHeight: 240.0,
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

                  Positioned(right: -50, top: -50, child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)))),
                  Positioned(left: -30, bottom: 20, child: Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)))),

                  Positioned(
                    bottom: 40, left: 20, right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text(widget.subjectClassCode, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1))),
                        const SizedBox(height: 12),
                        Text(_subjectDetail?['subject_name']?.toString() ?? "Activity List", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 26, height: 1.2, letterSpacing: -0.5)),
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
                    hintText: "Search activity...",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ),
          ),

          if (_filteredActivities.isEmpty)
            SliverFillRemaining(child: Center(child: Text("No activities found.", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold))))
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildModernActivityCard(_filteredActivities[index]),
                  childCount: _filteredActivities.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernActivityCard(Map<String, dynamic> data) {
    String activityName = data['classactivity_name']?.toString() ?? "Unknown Activity";
    String activityId = data['classactivity_id']?.toString() ?? "-";

    String rawDate = data['classactivity_date']?.toString() ?? "-";
    String dateOnly = rawDate.contains('T') ? rawDate.split('T')[0] : rawDate;

    String startTime = data['start_time']?.toString() ?? "-";
    String endTime = data['end_time']?.toString() ?? "-";

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: gradientStart.withOpacity(0.05), borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(
              children: [
                Text(activityName, textAlign: TextAlign.center, style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 6),
                Text("ID: $activityId", style: TextStyle(color: gradientStart, fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month_rounded, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 10),
                    Text(dateOnly, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 10),
                    Text("$startTime - $endTime", style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassActivityEditPage(
                        activityId: activityId,
                        subjectClassCode: widget.subjectClassCode,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 18),
                label: const Text("Select Activity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gradientStart,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}