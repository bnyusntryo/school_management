import 'package:flutter/material.dart';
import 'sidebar_menu.dart';
import 'student_profile_page.dart';
import 'add_student_page.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  
  final List<Map<String, String>> _students = [
    {"name": "Yoga Pratama", "nis": "30291737282", "kelas": "XII", "jurusan": "Teknik Komputer Jaringan"},
    {"name": "Budi Santoso", "nis": "30291737283", "kelas": "XII", "jurusan": "Rekayasa Perangkat Lunak"},
    {"name": "Diana Sari", "nis": "30291737284", "kelas": "XII", "jurusan": "Desain Komunikasi Visual"},
    {"name": "Eko Prabowo", "nis": "30291737285", "kelas": "XII", "jurusan": "Sistem Informasi"},
    {"name": "Fani Lestari", "nis": "30291737286", "kelas": "XI", "jurusan": "Akuntansi"},
  ];

  List<Map<String, String>> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _filteredStudents = _students;
  }

  void _filterStudents(String query) {
    setState(() {
      _filteredStudents = _students
          .where((s) => s['name']!.toLowerCase().contains(query.toLowerCase()) || 
                        s['jurusan']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarMenu(),
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text("Student Directory", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Elegant Search Bar Area
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterStudents,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search, color: Colors.blueAccent),
                      hintText: "Search student or major...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_filteredStudents.length} students found",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddStudentPage()),
                        );
                        if (result != null && result is Map<String, String>) {
                          setState(() {
                            _students.insert(0, result);
                            _filteredStudents = _students;
                          });
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: const Text("Add Student", style: TextStyle(fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Student List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentProfilePage(studentData: student)),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: _buildStudentCard(student),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, String> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Class Color Indicator
              Container(
                width: 6,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFA726), Color(0xFFF57C00)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      // Avatar with ring
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.orangeAccent.withOpacity(0.2), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${student['nis']}'),
                          onBackgroundImageError: (exception, stackTrace) {
                            // Menangani error pemuatan gambar
                          },
                          child: student['name'] == null ? const Icon(Icons.person, color: Colors.grey) : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student['name']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "NIS: ${student['nis']}",
                              style: TextStyle(color: Colors.grey[500], fontSize: 11),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildInfoBadge(Icons.class_outlined, student['kelas']!),
                                const SizedBox(width: 10),
                                _buildInfoBadge(Icons.school_outlined, student['jurusan']!),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[300]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.blueAccent),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5C6AC4)),
          ),
        ],
      ),
    );
  }
}
