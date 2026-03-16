import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/pref.dart';
import 'class_activity_subject_page.dart';

class ClassActivityPage extends StatefulWidget {
  const ClassActivityPage({super.key});

  @override
  State<ClassActivityPage> createState() => _ClassActivityPageState();
}

class _ClassActivityPageState extends State<ClassActivityPage> {
  bool _isLoading = true;
  List<dynamic> _allClasses = [];
  List<dynamic> _filteredClasses = [];
  final TextEditingController _searchCtrl = TextEditingController();

  final Color primaryBlue = const Color(0xFF4A90E2);
  final Color accentPink = const Color(0xFFF06292);
  final Color textDark = const Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _fetchClassList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchClassList() async {
    setState(() => _isLoading = true);

    try {
      String? token = await Session().getUserToken();

      var payload = {
        "limit": 100,
        "offset": 0,
        "sortField": "subjectclass_code",
        "sortOrder": 1,
        "filters": {},
        "global": ""
      };

      var req = await http.post(
        Uri.parse('https://schoolapp-api-dev.zeabur.app/api/schoolactivity/classactivity/class-list'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(payload),
      );

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        if (res['data'] != null && mounted) {
          setState(() {
            _allClasses = res['data'];
            _filteredClasses = _allClasses;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
        _showError("Gagal mengambil data (Error ${req.statusCode})");
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showError("Terjadi kesalahan jaringan.");
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
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
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
              icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]),
                  child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black87, size: 16)
              ),
              onPressed: () => Navigator.pop(context)
          ),
        ),
        title: const Text("Class Activity", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 0.5)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select a class to view or manage activities.", style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                        border: Border.all(color: Colors.grey.shade100, width: 1.5)
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: _filterData,
                      decoration: InputDecoration(
                        icon: Icon(Icons.search_rounded, color: primaryBlue, size: 22),
                        hintText: "Search class name or grade...",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: primaryBlue))
                  : _filteredClasses.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                physics: const BouncingScrollPhysics(),
                itemCount: _filteredClasses.length,
                itemBuilder: (context, index) {
                  var classData = _filteredClasses[index];
                  return _buildClassCard(classData);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> data) {
    String className = data['class_name']?.toString() ?? "Unknown Class";
    String gradeCode = data['grade_code']?.toString() ?? "-";
    String periodYear = data['periodyear_code']?.toString() ?? "2025";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))],
          border: Border.all(color: Colors.grey.shade100)
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            String code = data['class_code']?.toString() ?? "";
            if (code.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassActivitySubjectPage(classCode: code),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryBlue.withOpacity(0.2), accentPink.withOpacity(0.2)]),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Icon(Icons.meeting_room_rounded, color: primaryBlue, size: 28)),
                ),
                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(className, style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 16)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.school_rounded, size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text("Grade: $gradeCode", style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      )
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Text(periodYear, style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                      child: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: textDark),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
            child: Icon(Icons.class_rounded, size: 60, color: Colors.blue.shade200),
          ),
          const SizedBox(height: 20),
          Text("No Classes Found", style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 5),
          Text("Try searching with a different keyword.", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        ],
      ),
    );
  }
}