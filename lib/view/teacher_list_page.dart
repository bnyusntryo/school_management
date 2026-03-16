import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/pref.dart';
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

  List<Map<String, String>> _teachers = [];
  List<Map<String, String>> _filteredTeachers = [];
  bool _isLoading = true;

  final List<Color> _cardColors = [
    Colors.pink.shade400,
    Colors.purple.shade400,
    Colors.deepOrange.shade400,
    Colors.blue.shade400,
  ];

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
  }

  Future<void> _fetchTeachers() async {
    try {
      String? token = await Session().getUserToken();
      final response = await http.post(
        Uri.parse('https://schoolapp-api-dev.zeabur.app/api/teacher/teacher-info/list'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "limit": 100,
          "offset": 0,
          "filters": {
            "full_name": "",
            "userid": ""
          },
          "global": ""
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final List data = result['data'] ?? [];

        List<Map<String, String>> fetchedTeachers = data.map((item) {
          return {
            "name": item['full_name']?.toString() ?? 'Unknown',
            "nip": item['userid']?.toString() ?? '-',
            "subject": "-",
            "class": "-",
            "image": item['user_photo']?.toString() ?? '',
          };
        }).toList();

        if (mounted) {
          setState(() {
            _teachers = fetchedTeachers;
            _filteredTeachers = _teachers;
            _isLoading = false;
          });
        }
      } else {
        print("🚨 Server menolak: ${response.body}");
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      print("🚨 Error fetch teachers: $e");
      if (mounted) setState(() => _isLoading = false);
    }
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
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.pink.shade400, Colors.pink.shade700],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Teacher Directory",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  icon: const Icon(Icons.person_add_rounded, color: Colors.white, size: 24),
                  tooltip: "Add Teacher",
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddTeacherPage()),
                    );

                    if (result != null && result is Map<String, String>) {
                      setState(() {
                        _teachers.insert(0, result);
                        _filteredTeachers = _teachers;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.pink.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5)),
                            ],
                            border: Border.all(color: Colors.pink.shade50),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterTeachers,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              icon: Icon(Icons.search_rounded, color: Colors.pink.shade400, size: 22),
                              hintText: "Search by name or subject...",
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.normal),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _filterTeachers('');
                          },
                          icon: Icon(Icons.filter_alt_off_rounded, color: Colors.grey.shade600, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.pink.shade50, shape: BoxShape.circle),
                        child: Icon(Icons.school_rounded, size: 14, color: Colors.pink.shade600),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${_filteredTeachers.length} teachers found",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            sliver: _isLoading
                ? const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Colors.pink)),
            )
                : _filteredTeachers.isEmpty
                ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.person_off_rounded, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 15),
                      Text("No teachers found", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherProfilePage(teacherData: _filteredTeachers[index]),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: _buildTeacherCard(_filteredTeachers[index], index),
                  );
                },
                childCount: _filteredTeachers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard(Map<String, String> teacher, int index) {
    final cardColor = _cardColors[index % _cardColors.length];

    String rawPhoto = teacher['image'] ?? '';
    String avatarUrl = rawPhoto.isNotEmpty ? rawPhoto : 'https://i.pravatar.cc/150?u=${teacher['nip']}';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.pink.shade50, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 6,
                color: cardColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: cardColor.withOpacity(0.3), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: cardColor.withOpacity(0.1),
                          backgroundImage: NetworkImage(avatarUrl),
                          onBackgroundImageError: (_, __) {},
                          child: teacher['name'] == null ? Icon(Icons.person_rounded, color: cardColor) : null,
                        ),
                      ),
                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              teacher['name']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "NIP: ${teacher['nip']}",
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),

                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                _buildInfoBadge(Icons.menu_book_rounded, teacher['subject']!, Colors.indigo),
                                _buildInfoBadge(Icons.class_rounded, teacher['class']!, Colors.blue),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 28),
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

  Widget _buildInfoBadge(IconData icon, String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: color.shade100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color.shade600),
          const SizedBox(width: 4),
          Flexible(
            child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color.shade700), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}