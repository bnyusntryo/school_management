import 'package:flutter/material.dart';
import '../viewmodel/ClassActivity_viewmodel.dart';

class ClassActivityEditPage extends StatefulWidget {
  final String activityId;
  final String subjectClassCode;

  const ClassActivityEditPage({super.key, required this.activityId, required this.subjectClassCode});

  @override
  State<ClassActivityEditPage> createState() => _ClassActivityEditPageState();
}

class _ClassActivityEditPageState extends State<ClassActivityEditPage> {
  final ClassActivityViewmodel _viewModel = ClassActivityViewmodel();

  bool _isLoading = true;

  Map<String, dynamic>? _activityDetail;
  List<Map<String, dynamic>> _studentList = [];

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _startCtrl = TextEditingController();
  final TextEditingController _endCtrl = TextEditingController();

  final Color primaryIndigo = const Color(0xFF6366F1);
  final Color primarySky = const Color(0xFF0EA5E9);
  final Color bgSlate = const Color(0xFFF8FAFC);
  final Color textDark = const Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _fetchDataFromViewModel();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _dateCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchDataFromViewModel() async {
    setState(() => _isLoading = true);
    try {
      var results = await Future.wait([
        _viewModel.fetchActivityDetail(widget.activityId, widget.subjectClassCode),
        _viewModel.fetchStudentList(widget.activityId, widget.subjectClassCode)
      ]);

      if (!mounted) return;

      var detailResp = results[0];
      var listResp = results[1];

      if (detailResp.data != null) {
        _activityDetail = detailResp.data;

        _nameCtrl.text = _activityDetail?['classactivity_name']?.toString() ?? "";
        _descCtrl.text = _activityDetail?['classactivity_desc']?.toString() ?? "";

        String rawDate = _activityDetail?['classactivity_date']?.toString() ?? "";
        _dateCtrl.text = rawDate.contains('T') ? rawDate.split('T')[0] : rawDate;

        _startCtrl.text = _activityDetail?['start_time']?.toString() ?? "";
        _endCtrl.text = _activityDetail?['end_time']?.toString() ?? "";

        List<dynamic> rawStudents = listResp.data ?? [];
        _studentList = rawStudents.map((e) => Map<String, dynamic>.from(e)).toList();

        setState(() => _isLoading = false);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: primaryIndigo));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSlate,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primarySky))
          : CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            pinned: true,
            backgroundColor: primaryIndigo,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 8, bottom: 8),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 16)),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
              title: const Text("Edit Class Activity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
              background: Container(
                decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryIndigo, primarySky])),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildFormSection(),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: primarySky.withOpacity(0.15), shape: BoxShape.circle), child: Icon(Icons.people_alt_rounded, size: 18, color: primarySky)),
                  const SizedBox(width: 10),
                  Text("Student Attendance", style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5)),
                  const Spacer(),
                  Text("${_studentList.length} Students", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ),

          _studentList.isEmpty
              ? SliverToBoxAdapter(child: Center(child: Padding(padding: const EdgeInsets.all(20), child: Text("No students data.", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)))))
              : SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildStudentCard(_studentList[index], index),
                childCount: _studentList.length,
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: _isLoading ? null : FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur Save akan segera aktif!")));
        },
        backgroundColor: textDark,
        elevation: 10,
        icon: const Icon(Icons.save_rounded, color: Colors.white, size: 20),
        label: const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))]),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoPill("Activity ID", widget.activityId),
          const SizedBox(height: 20),

          _buildModernTextField("Activity Name", _nameCtrl, icon: Icons.title_rounded),
          const SizedBox(height: 15),
          _buildModernTextField("Description", _descCtrl, icon: Icons.notes_rounded, maxLines: 3),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(flex: 5, child: _buildModernTextField("Date", _dateCtrl, icon: Icons.calendar_today_rounded, isReadOnly: true)),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: _buildModernTextField("Start", _startCtrl, icon: Icons.access_time_rounded, isReadOnly: true)),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: _buildModernTextField("End", _endCtrl, icon: Icons.timer_off_outlined, isReadOnly: true)),
            ],
          ),
          const SizedBox(height: 20),

          Text("Attachment", style: TextStyle(color: textDark, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: primarySky.withOpacity(0.05), border: Border.all(color: primarySky.withOpacity(0.3), style: BorderStyle.solid), borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Icon(Icons.cloud_upload_outlined, size: 30, color: primarySky.withOpacity(0.7)),
                const SizedBox(height: 8),
                Text(_activityDetail?['attachment']?.toString() ?? "Tap to change attachment", style: TextStyle(color: primaryIndigo, fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(color: bgSlate, borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$label: ", style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(color: textDark, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildModernTextField(String label, TextEditingController ctrl, {required IconData icon, int maxLines = 1, bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: textDark, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: isReadOnly ? bgSlate : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: TextField(
            controller: ctrl,
            readOnly: isReadOnly,
            maxLines: maxLines,
            style: TextStyle(fontSize: 13, color: textDark, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 16, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student, int index) {
    String name = student['full_name']?.toString() ?? "-";
    String userId = student['userid']?.toString() ?? "-";

    bool isPresent = student['class_attend_status']?.toString() == "Present";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isPresent ? primarySky.withOpacity(0.3) : Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(radius: 18, backgroundColor: primaryIndigo.withOpacity(0.1), child: Text((index + 1).toString(), style: TextStyle(color: primaryIndigo, fontSize: 12, fontWeight: FontWeight.bold))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(color: textDark, fontWeight: FontWeight.w800, fontSize: 14)),
                      Text("ID: $userId", style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      student['class_attend_status'] = isPresent ? "" : "Present";
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: isPresent ? primarySky : Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Icon(isPresent ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: isPresent ? Colors.white : Colors.grey.shade500, size: 14),
                        const SizedBox(width: 5),
                        Text(isPresent ? "Present" : "Absent", style: TextStyle(color: isPresent ? Colors.white : Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),

            if (!isPresent) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(color: bgSlate, borderRadius: BorderRadius.circular(12)),
                child: TextFormField(
                  initialValue: student['class_attend_reason']?.toString() ?? "",
                  onChanged: (val) {
                    student['class_attend_reason'] = val;
                  },
                  style: TextStyle(fontSize: 12, color: textDark),
                  decoration: InputDecoration(
                    hintText: "Reason for absence...",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    prefixIcon: Icon(Icons.edit_note_rounded, size: 16, color: Colors.grey.shade400),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}