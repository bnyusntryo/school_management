import 'package:flutter/material.dart';
import '../../model/teacher_info_model.dart';
import '../../viewmodel/teacher_viewmodel.dart';
import '../sidebar_menu.dart';
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
  final ScrollController _scrollController = ScrollController();
  final _viewmodel = TeacherViewmodel();

  List<TeacherInfoModel> _teachers = [];
  List<TeacherInfoModel> _filteredTeachers = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 20;

  String _currentSearchQuery = '';

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
    _scrollController.addListener(_onScroll); // ✅ listen scroll event
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _fetchTeachers() async {
    setState(() {
      _isLoading = true;
      _currentPage = 0;
      _teachers.clear();
      _hasMore = true;
    });

    await _loadTeachersFromApi(offset: 0);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _filteredTeachers = _teachers;
      });
    }
  }

  // ✅ Load more data saat scroll
  Future<void> _loadMore() async {
    // ✅ Guard: jangan load jika sudah loading atau tidak ada data lagi
    if (_isLoadingMore || !_hasMore || _isLoading) return;

    setState(() => _isLoadingMore = true);

    final nextOffset = (_currentPage + 1) * _pageSize;
    await _loadTeachersFromApi(offset: nextOffset);

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
        _currentPage++;
        _filteredTeachers = _teachers;
      });
    }
  }

  // ✅ Core API call - reusable untuk initial load dan pagination
  // ✅ ARCH-1: Network call lewat ViewModel, bukan langsung HTTP
  Future<void> _loadTeachersFromApi({required int offset}) async {
    try {
      // ✅ Panggil ViewModel, bukan HTTP langsung
      final resp = await _viewmodel.getTeacherList(
        limit: _pageSize,
        offset: offset,
        nameFilter: _currentSearchQuery.isEmpty ? null : _currentSearchQuery,
      );

      if (!mounted) return; // ✅ WAJIB mounted check - FLUTTER-1

      // ✅ Debug logging
      debugPrint("📋 Response: $resp");
      debugPrint("📋 Response code: ${resp.code}");
      debugPrint("📋 Response data type: ${resp.data?.runtimeType}");

      // ✅ Check success: code 200-299 atau code null (jika Network tidak wrap)
      final bool isSuccess =
          resp.code == null || (resp.code! >= 200 && resp.code! < 300);

      if (isSuccess && resp.data != null) {
        // ✅ Data bisa langsung List atau wrapped di Map
        final List data;

        if (resp.data is List) {
          // ✅ Case 1: Network return langsung array
          data = resp.data;
        } else if (resp.data is Map) {
          // ✅ Case 2: Network return {data: [...], message: ...}
          // Tapi karena sudah di-wrap di Network, seharusnya langsung List
          data = resp.data['data'] ?? resp.data;
        } else {
          debugPrint("🚨 Unexpected data type: ${resp.data.runtimeType}");
          if (mounted) setState(() => _hasMore = false);
          return;
        }

        debugPrint("✅ Got ${data.length} teachers from API");

        // ✅ Check pagination
        if (data.isEmpty || data.length < _pageSize) {
          _hasMore = false;
        }

        // ✅ Parse ke TeacherInfoModel
        List<TeacherInfoModel> fetchedTeachers = data
            .map(
              (item) => TeacherInfoModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();

        debugPrint("✅ Parsed ${fetchedTeachers.length} teachers successfully");

        if (mounted) {
          setState(() {
            _teachers.addAll(fetchedTeachers);
          });
        }
      } else {
        // ✅ Error response
        debugPrint("🚨 API Error: code=${resp.code}, message=${resp.message}");
        if (mounted) setState(() => _hasMore = false);
      }
    } catch (e, stackTrace) {
      debugPrint("🚨 Exception: $e");
      debugPrint("Stack: $stackTrace");
      if (mounted) setState(() => _hasMore = false);
    }
  }

  // ✅ Filter dengan reset pagination
  void _filterTeachers(String query) {
    _currentSearchQuery = query;

    if (query.isEmpty) {
      // ✅ Kalau search kosong, tampilkan semua data yang sudah di-load
      setState(() {
        _filteredTeachers = _teachers;
      });
    } else {
      // ✅ Filter lokal dari data yang sudah di-load
      setState(() {
        _filteredTeachers = _teachers
            .where(
              (t) =>
                  t.fullName.toLowerCase().contains(query.toLowerCase()) ||
                  t.userid.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      });
    }
  }

  // ✅ Refresh data (pull to refresh)
  Future<void> _refreshTeachers() async {
    await _fetchTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarMenu(),
      backgroundColor: const Color(0xFFF5F7FA),
      body: RefreshIndicator(
        // ✅ Tambah pull to refresh
        onRefresh: _refreshTeachers,
        color: Colors.pink,
        child: CustomScrollView(
          controller: _scrollController, // ✅ attach scroll controller
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Colors.white),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.person_add_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    tooltip: "Add Teacher",
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTeacherPage(),
                        ),
                      );

                      // ✅ Terima TeacherModel dari AddTeacherPage
                      if (result != null && result is TeacherInfoModel) {
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pink.withOpacity(0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              border: Border.all(color: Colors.pink.shade50),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: _filterTeachers,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.search_rounded,
                                  color: Colors.pink.shade400,
                                  size: 22,
                                ),
                                hintText: "Search by name or subject...",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
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
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _filterTeachers('');
                            },
                            icon: Icon(
                              Icons.filter_alt_off_rounded,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.school_rounded,
                            size: 14,
                            color: Colors.pink.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${_filteredTeachers.length} teachers found",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
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
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.pink),
                      ),
                    )
                  : _filteredTeachers.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.person_off_rounded,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "No teachers found",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // ✅ Tampilkan loading indicator di akhir list
                          if (index == _filteredTeachers.length) {
                            return _isLoadingMore
                                ? const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.pink,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeacherProfilePage(
                                    teacherData: _filteredTeachers[index],
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: _buildTeacherCard(
                              _filteredTeachers[index],
                              index,
                            ),
                          );
                        },
                        // ✅ +1 untuk slot loading indicator
                        childCount:
                            _filteredTeachers.length + (_isLoadingMore ? 1 : 0),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherCard(TeacherInfoModel teacher, int index) {
    final cardColor = _cardColors[index % _cardColors.length];

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
              Container(width: 6, color: cardColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: cardColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: cardColor.withOpacity(0.1),
                          backgroundImage: NetworkImage(teacher.avatarUrl),
                          onBackgroundImageError: (_, __) {},
                          child: !teacher.hasPhoto
                              ? Icon(Icons.person_rounded, color: cardColor)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              teacher.displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF2D3142),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "NIP: ${teacher.userid}",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                if (teacher.gender.isNotEmpty)
                                  _buildInfoBadge(
                                    Icons.person_outline_rounded,
                                    teacher.gender,
                                    Colors.indigo,
                                  ),
                                if (teacher.joinDate.isNotEmpty)
                                  _buildInfoBadge(
                                    Icons.calendar_today_rounded,
                                    teacher.joinDate,
                                    Colors.blue,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey.shade300,
                        size: 28,
                      ),
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
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color.shade600),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: color.shade700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
