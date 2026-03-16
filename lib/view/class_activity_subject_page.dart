import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/pref.dart';

class ClassActivitySubjectPage extends StatefulWidget {
  final String classCode;

  const ClassActivitySubjectPage({super.key, required this.classCode});

  @override
  State<ClassActivitySubjectPage> createState() => _ClassActivitySubjectPageState();
}

class _ClassActivitySubjectPageState extends State<ClassActivitySubjectPage> {
  bool _isLoading = true;

  Map<String, dynamic>? _classDetail;
  List<dynamic> _allSubjects = [];
  List<dynamic> _filteredSubjects = [];

  final TextEditingController _searchCtrl = TextEditingController();

  final Color primaryBlue = const Color(0xFF3B82F6);
  final Color textDark = const Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _fetchDataGanda();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchDataGanda() async {
    setState(() => _isLoading = true);

    try {
      String? token = await Session().getUserToken();
      Map<String, String> headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      var detailReq = http.post(
        Uri.parse('https://schoolapp-api-dev.zeabur.app/api/schoolactivity/classactivity/class-detail'),
        headers: headers,
        body: jsonEncode({"class_code": widget.classCode}),
      );

      var payloadList = {
        "limit": 100,
        "offset": 0,
        "sortField": "subjectclass_code",
        "sortOrder": 1,
        "filters": {},
        "global": "",
        "class_code": widget.classCode
      };

      var listReq = http.post(
        Uri.parse('https://schoolapp-api-dev.zeabur.app/api/schoolactivity/classactivity/subject-list'),
        headers: headers,
        body: jsonEncode(payloadList),
      );

      var results = await Future.wait([detailReq, listReq]);
      var detailRes = results[0];
      var listRes = results[1];

      if (!mounted) return;

      if (detailRes.statusCode == 200 && listRes.statusCode == 200) {
        var detailJson = jsonDecode(detailRes.body);
        var listJson = jsonDecode(listRes.body);

        setState(() {
          _classDetail = detailJson['data'];
          _allSubjects = listJson['data'] ?? [];
          _filteredSubjects = _allSubjects;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        _showError("Gagal mengambil data dari server.");
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
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
              icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]), child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black87, size: 16)),
              onPressed: () => Navigator.pop(context)
          ),
        ),
        title: const Text("Class Activity Subjects", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5)),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: primaryBlue))
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]),
                child: Column(
                  children: [
                    _buildHeaderRow("Class Code", _classDetail?['class_code'] ?? "-"),
                    const Divider(height: 25, color: Color(0xFFF1F5F9)),
                    _buildHeaderRow("Class Name", _classDetail?['class_name'] ?? "-"),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200, width: 1.5)),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: _filterData,
                  decoration: InputDecoration(icon: Icon(Icons.search_rounded, color: primaryBlue, size: 22), hintText: "Search subject, teacher...", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500), border: InputBorder.none),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: _filteredSubjects.isEmpty
                  ? Center(child: Text("No subjects found.", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)))
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                physics: const BouncingScrollPhysics(),
                itemCount: _filteredSubjects.length,
                itemBuilder: (context, index) {
                  return _buildSubjectCard(_filteredSubjects[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(String title, String value) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.bold))),
        const Text(":", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(width: 15),
        Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)), child: Text(value, style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 14)))),
      ],
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> data) {
    String subjectName = data['subject_name']?.toString() ?? "-";
    String subjectCode = data['subject_code']?.toString() ?? "-";
    String teacherName = data['teacher_name']?.toString() ?? "No Teacher Assigned";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            child: Column(
              children: [
                Text(subjectName, textAlign: TextAlign.center, style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 5),
                Text(subjectCode, style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade100, thickness: 1.5),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Icon(Icons.person_outline_rounded, size: 18, color: Colors.blue.shade400),
                const SizedBox(width: 10),
                Expanded(child: Text(teacherName, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Membuka Detail: $subjectName")));
                },
                icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                label: const Text("Select Subject", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}