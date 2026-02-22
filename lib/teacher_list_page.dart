import 'package:flutter/material.dart';
import 'sidebar_menu.dart';
import 'teacher_profile_page.dart';
import 'add_teacher_page.dart';

class TeacherListPage extends StatefulWidget {
  const TeacherListPage({super.key});

  @override
  State<TeacherListPage> createState() => _TeacherListPageState();
}

class _TeacherListPageState extends State<TeacherListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _teachers = [
    {
      "name": "Sarah Wijaya, M.Pd",
      "nip": "198503122010012005",
      "subject": "Mathematics",
      "class": "XII IPA 1",
      "image": "https://i.pravatar.cc/150?img=32"
    },
    {
      "name": "Bambang Hermawan, S.T",
      "nip": "197805202005011003",
      "subject": "Physics",
      "class": "XII IPA 2",
      "image": "https://i.pravatar.cc/150?img=11"
    },
    {
      "name": "Dewi Lestari, S.S",
      "nip": "199011052015032001",
      "subject": "English",
      "class": "XI BHS 1",
      "image": "https://i.pravatar.cc/150?img=45"
    },
    {
      "name": "Rahmat Hidayat, M.Kom",
      "nip": "198207152008011002",
      "subject": "Computer Science",
      "class": "XII TKJ 1",
      "image": "https://i.pravatar.cc/150?img=13"
    },
  ];

  List<Map<String, String>> _filteredTeachers = [];

  @override
  void initState() {
    super.initState();
    _filteredTeachers = _teachers;
  }

  void _filterTeachers(String query) {
    setState(() {
      _filteredTeachers = _teachers
          .where((t) => t['name']!.toLowerCase().contains(query.toLowerCase()) ||
                        t['subject']!.toLowerCase().contains(query.toLowerCase()))
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
        title: const Text(
          "Teacher Directory",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
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
                    onChanged: _filterTeachers,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search, color: Colors.blueAccent),
                      hintText: "Search by name or subject...",
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
                      "${_filteredTeachers.length} teachers found",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        // Navigasi ke Add Teacher Page
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddTeacherPage()),
                        );

                        // Jika ada data baru yang dikirim balik
                        if (result != null && result is Map<String, String>) {
                          setState(() {
                            _teachers.insert(0, result);
                            _filteredTeachers = _teachers;
                          });
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: const Text("Add Teacher", style: TextStyle(fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Teacher List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _filteredTeachers.length,
              itemBuilder: (context, index) {
                final teacher = _filteredTeachers[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherProfilePage(teacherData: teacher),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: _buildTeacherCard(teacher),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard(Map<String, String> teacher) {
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
              // Subject Color Indicator
              Container(
                width: 6,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF4081), Color(0xFFC2185B)],
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
                      // Profile Image with ring
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.pinkAccent.withOpacity(0.2), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(teacher['image']!),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              teacher['name']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "NIP: ${teacher['nip']}",
                              style: TextStyle(color: Colors.grey[500], fontSize: 11),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildInfoBadge(Icons.book_outlined, teacher['subject']!),
                                const SizedBox(width: 10),
                                _buildInfoBadge(Icons.class_outlined, teacher['class']!),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Action Icon
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
