import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../config/pref.dart';
import 'sidebar_menu.dart';
import 'schedule_page.dart';
import 'announcement_page.dart';
import 'feed_detail_page.dart';
import 'auth_provider.dart';
import 'class_activity_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  int _currentPage = 0;
  Timer? _timer;

  List<dynamic> _announcements = [];
  bool _isLoadingBanner = true;

  List<dynamic> _apiFeeds = [];
  bool _isLoadingFeed = true;

  final String baseImageUrl = 'https://fastly.picsum.photos/id/517/1600/900.jpg?hmac=CdnOMbQEo4LItWYoyDHPpmPs3HPyGBFBnOFiel377XI/';

  Map<String, dynamic>? _todayClass;
  bool _isLoadingClass = true;

  @override
  void initState() {
    super.initState();
    fetchAnnouncements();
    fetchTodayClass();
    fetchSchoolFeed();
  }

  void _showAnnouncementDetailModal(Map<String, dynamic> item, String imageUrl) {
    showDialog(
        context: context,
        builder: (context) {
          String title = item['announcement_title'] ?? 'No Title';

          String rawDescription = item['announcement_desc'] ?? item['announcement_description'] ?? 'Tidak ada deskripsi untuk pengumuman ini.';

          String cleanDescription = rawDescription.replaceAll(RegExp(r'<[^>]*>'), '').trim();

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Dialog
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Announcement Detail",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),

                // Gambar Pengumuman
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 160,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Judul & Deskripsi (Yang sudah bersih)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cleanDescription, // <-- Menampilkan teks bersih
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Tombol Close Ungu
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  void _showCreatePostModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCreatePostSheet(),
    );
  }

  Widget _buildCreatePostSheet() {
    final authData = Provider.of<AuthProvider>(context, listen: false);

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Create Post", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              const Divider(height: 1),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              authData.role == 'Student'
                                  ? 'https://i.pravatar.cc/150?img=11'
                                  : 'https://i.pravatar.cc/150?img=12'
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(authData.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const Text("Create a new post", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _postController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "What's on your mind?",
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Gallery feature coming soon!"))
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blue.shade100, style: BorderStyle.solid),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                                  child: const Text("Choose", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.cloud_upload_outlined, color: Colors.grey),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text("Drag and drop up to 3 files to upload.", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (_postController.text.isNotEmpty) {
                            _addNewPost();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Post", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchAnnouncements() async {
    try {
      String? token = await Session().getUserToken();
      final response = await http.post(
        Uri.parse('https://schoolapp-api-dev.zeabur.app/api/home/announcement'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _announcements = (result['data'] as List)
                .where((item) => item['show_announcement'] == 'Y')
                .toList();
            _isLoadingBanner = false;
          });
          _startAutoSlider();
        }
      } else {
        if (mounted) setState(() => _isLoadingBanner = false);
      }
    } catch (e) {
      print("🚨 ERROR FATAL: $e");
      if (mounted) setState(() => _isLoadingBanner = false);
    }
  }

  Future<void> fetchTodayClass() async {
    try {
      String? token = await Session().getUserToken();
      final response = await http.post(
        Uri.parse('https://schoolapp-api-dev.zeabur.app/api/home/mytodayclass'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        final dataNode = result['data'];
        List classList = dataNode is List ? dataNode : (dataNode?['data'] ?? []);

        Map<String, dynamic>? activeOrNextClass;

        if (classList.isNotEmpty) {
          for (var c in classList) {
            if (_isNowInSchedule(c['schedule_time_start'], c['schedule_time_end'])) {
              activeOrNextClass = Map<String, dynamic>.from(c);
              activeOrNextClass['is_ongoing'] = true;
              break;
            }
          }
          if (activeOrNextClass == null) {
            activeOrNextClass = Map<String, dynamic>.from(classList.first);
            activeOrNextClass['is_ongoing'] = false;
          }
        }

        if (mounted) {
          setState(() {
            _todayClass = activeOrNextClass;
            _isLoadingClass = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingClass = false);
      }
    } catch (e) {
      print("🚨 Error fetch class: $e");
      if (mounted) setState(() => _isLoadingClass = false);
    }
  }

  Future<void> fetchSchoolFeed() async {
    try {
      String? token = await Session().getUserToken();
      final response = await http.post(
        Uri.parse('https://schoolapp-api-dev.zeabur.app/api/home/feeds/list'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _apiFeeds = List<Map<String, dynamic>>.from(result['data'] ?? []);
            _isLoadingFeed = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingFeed = false);
      }
    } catch (e) {
      print("🚨 Error fetch feed: $e");
      if (mounted) setState(() => _isLoadingFeed = false);
    }
  }

  String _timeAgo(String? dateString) {
    if (dateString == null) return "Unknown time";
    try {
      DateTime postTime = DateTime.parse(dateString);
      Duration diff = DateTime.now().difference(postTime);

      if (diff.inDays > 0) return "${diff.inDays} Days Ago";
      if (diff.inHours > 0) return "${diff.inHours} Hours Ago";
      if (diff.inMinutes > 0) return "${diff.inMinutes} Minutes Ago";
      return "Just Now";
    } catch (e) {
      return "Recently";
    }
  }

  bool _isNowInSchedule(String? start, String? end) {
    if (start == null || end == null) return false;
    try {
      final now = DateTime.now();
      final startParts = start.split(':');
      final endParts = end.split(':');

      final startTime = DateTime(now.year, now.month, now.day, int.parse(startParts[0]), int.parse(startParts[1]));
      final endTime = DateTime(now.year, now.month, now.day, int.parse(endParts[0]), int.parse(endParts[1]));

      return now.isAfter(startTime) && now.isBefore(endTime);
    } catch (e) {
      return false;
    }
  }

  void _startAutoSlider() {
    _timer?.cancel();

    final bannerCount = _announcements.length;
    if (bannerCount <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (mounted && _pageController.hasClients) {
        if (_currentPage < bannerCount - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic
        );
      }
    });
  }

  void _addNewPost() {
    if (_postController.text.isNotEmpty) {
      final authData = Provider.of<AuthProvider>(context, listen: false);

      setState(() {
        _apiFeeds.insert(0, {
          "creator": authData.userName,
          "creator_status": authData.role,
          "created_at": DateTime.now().toIso8601String(),
          "feedpost_name": _postController.text,
          "feedpost_total_like": 0,
          "feedpost_total_comment": 0,
          "feedpost_img": [],
          "is_liked_local": false,
        });
        _postController.clear();
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _postController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);
    String currentRole = authData.role;
    bool isStudent = currentRole == 'Student';
    bool isPrincipal = currentRole == 'Principal';

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarMenu(),
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF0F172A)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("SMK", style: TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.w900)),
            Text("Islamiyah", style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Color(0xFF0F172A), size: 22), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Color(0xFF0F172A), size: 22), onPressed: () {}),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                        isStudent ? 'https://i.pravatar.cc/150?img=11' : 'https://i.pravatar.cc/150?img=12'
                    )
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello $currentRole", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                    const SizedBox(height: 2),
                    Text(authData.userName, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),

            if (_isLoadingBanner)
              const SizedBox(
                height: 160,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
                ),
              )
            else if (_announcements.isNotEmpty) ...[
              SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) => setState(() => _currentPage = page),
                  itemCount: _announcements.length,
                  itemBuilder: (context, index) {
                    final item = _announcements[index];
                    final String title = item['announcement_title'] ?? 'No Title';
                    final List images = item['announcement_img'] ?? [];

                    final String imageUrl = images.isNotEmpty
                        ? 'https://fastly.picsum.photos/id/517/1600/900.jpg?hmac=CdnOMbQEo4LItWYoyDHPpmPs3HPyGBFBnOFiel377XI'
                        : 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?q=80&w=2000&auto=format&fit=crop';

                    // 💡 BARU: BUNGKUS BANNER DENGAN GESTURE DETECTOR
                    return GestureDetector(
                      onTap: () => _showAnnouncementDetailModal(item, imageUrl),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(child: Icon(Icons.broken_image_rounded, size: 50, color: Colors.grey));
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0, left: 0, right: 0, height: 90,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)])
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Announcement", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_announcements.length, (index) => Container(
                    width: _currentPage == index ? 20 : 8, height: 6, margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(color: _currentPage == index ? const Color(0xFF3B82F6) : Colors.grey.shade300, borderRadius: BorderRadius.circular(3))
                )),
              ),
            ],

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Explore Dashboard", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                Icon(Icons.dashboard_rounded, color: Colors.grey.shade400, size: 20),
              ],
            ),
            const SizedBox(height: 15),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      if (!isPrincipal) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SchedulePage()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ClassActivityPage()));
                      }
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      height: 225,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: isPrincipal
                                ? [const Color(0xFF10B981), const Color(0xFF059669)]
                                : [const Color(0xFFFFCA28), const Color(0xFFFF9800)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: (isPrincipal ? Colors.green : Colors.orange).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                              bottom: -10, right: -10,
                              child: Icon(
                                  isPrincipal ? Icons.bar_chart_rounded : Icons.menu_book_rounded,
                                  color: Colors.white.withOpacity(0.2), size: 120
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: _buildScheduleCardContent(isPrincipal: isPrincipal, isStudent: isStudent),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildActionCard(
                          colors: [const Color(0xFFFF8A65), const Color(0xFFF4511E)],
                          title: "Tap In",
                          time: "07:00",
                          buttonText: "Check In",
                          icon: Icons.login_rounded,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tap In Recorded!"), backgroundColor: Colors.green));
                          }
                      ),
                      const SizedBox(height: 15),
                      _buildActionCard(
                          colors: [const Color(0xFF9FA8DA), const Color(0xFF5E35B1)],
                          title: "Tap Out",
                          time: "16:00",
                          buttonText: "Check In",
                          icon: Icons.logout_rounded,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tap Out Recorded!"), backgroundColor: Colors.blue));
                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            if (!isStudent) ...[
              GestureDetector(
                onTap: _showCreatePostModal,
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${isPrincipal ? 12 : 15}')
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]
                        ),
                        child: Row(
                          children: [
                            Text(
                                "What's on your mind?",
                                style: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500)
                            ),
                            const Spacer(),
                            const Icon(Icons.send_rounded, color: Color(0xFF3B82F6), size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ],

            const Text("School Feed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
            const SizedBox(height: 15),

            if (_isLoadingFeed)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6))),
              )
            else if (_apiFeeds.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(child: Text("No posts yet.", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _apiFeeds.length,
                itemBuilder: (context, index) {
                  final post = _apiFeeds[index];

                  String name = post['creator'] ?? 'Unknown';
                  String role = post['creator_status'] ?? '-';
                  String time = _timeAgo(post['created_at']);
                  String content = post['feedpost_name'] ?? '';
                  int likes = post['feedpost_total_like'] ?? 0;
                  int comments = post['feedpost_total_comment'] ?? 0;

                  List imagesRaw = post['feedpost_img'] ?? [];
                  final List<String> displayImages = imagesRaw.map((e) => e.toString()).toList();

                  String rawPhoto = post['user_photo'] ?? '';
                  String avatarUrl = rawPhoto.isNotEmpty ? rawPhoto : 'https://ui-avatars.com/api/?name=${name.replaceAll(' ', '+')}&background=random';

                  bool isLiked = post['is_liked_local'] ?? false;

                  return GestureDetector(
                    onTap: () {
                      Map<String, dynamic> mappedPost = {
                        "id": post['feedpost_id'] ?? '',
                        "name": name,
                        "role": role,
                        "time": time,
                        "content": content,
                        "likes": likes,
                        "commentList": [],
                        "isLiked": isLiked,
                      };

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FeedDetailPage(post: mappedPost, avatarUrl: avatarUrl))
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: const Color(0xFF94A3B8).withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarUrl)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF0F172A)), overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 2),
                                      Text(role, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)
                                    ]
                                ),
                              ),
                              Text(time, style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(content, style: const TextStyle(fontSize: 13, height: 1.6, color: Color(0xFF334155), fontWeight: FontWeight.w500)),

                          if (displayImages.isNotEmpty)
                            Container(
                              height: 180,
                              margin: const EdgeInsets.only(top: 15),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: displayImages.length,
                                itemBuilder: (context, imgIndex) {
                                  String imageName = displayImages[imgIndex];
                                  String fullImageUrl = imageName.startsWith('http')
                                      ? imageName
                                      : 'https://schoolapp-api-dev.zeabur.app/public/uploads/$imageName';

                                  return Container(
                                    width: MediaQuery.of(context).size.width * (displayImages.length > 1 ? 0.75 : 0.85),
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.network(
                                        fullImageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Center(
                                              child: Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey)
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5)),

                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    post['is_liked_local'] = !isLiked;
                                    if (!isLiked) {
                                      post['feedpost_total_like'] = likes + 1;
                                    } else {
                                      post['feedpost_total_like'] = likes - 1;
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: isLiked ? Colors.red.shade50 : Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Icon(isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 18, color: isLiked ? Colors.red : Colors.grey.shade500),
                                      const SizedBox(width: 6),
                                      Text("$likes Likes", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isLiked ? Colors.red.shade700 : Colors.grey.shade600)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.grey.shade500),
                                    const SizedBox(width: 6),
                                    Text("$comments Comments", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCardContent({required bool isPrincipal, required bool isStudent}) {
    if (isPrincipal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Monitor\nActive Class", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, height: 1.2)),
          const SizedBox(height: 15),
          Text("24 Classes\nActive Today", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w600, height: 1.3)),
        ],
      );
    }

    if (_isLoadingClass) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (_todayClass == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isStudent ? "My Schedule\nClass" : "Teaching\nSchedule", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, height: 1.2)),
          const SizedBox(height: 15),
          Text("No class\nschedule\ntoday", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w600, height: 1.3)),
        ],
      );
    }

    String subject = _todayClass!['subjectclass_name'] ?? 'Unknown Subject';
    String subtitle = isStudent ? (_todayClass!['teacher_name'] ?? '-') : (_todayClass!['class_name'] ?? '-');
    String time = "${_todayClass!['schedule_time_start']} - ${_todayClass!['schedule_time_end']}";
    bool isOngoing = _todayClass!['is_ongoing'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isOngoing)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.red.shade500, borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.circle, color: Colors.white, size: 8),
                SizedBox(width: 4),
                Text("ONGOING", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(6)),
            child: const Text("UPCOMING", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          ),

        const SizedBox(height: 12),
        Text(subject, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
        const Spacer(),
        Row(
          children: [
            Icon(Icons.access_time_rounded, color: Colors.white.withOpacity(0.8), size: 14),
            const SizedBox(width: 6),
            Text(time, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({required List<Color> colors, required String title, required String time, required String buttonText, required IconData icon, VoidCallback? onTap}) {
    return Container(
      width: double.infinity,
      height: 105,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: colors.last.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6))],
      ),
      child: Stack(
        children: [
          Positioned(bottom: -15, right: -15, child: Icon(icon, size: 80, color: Colors.white.withOpacity(0.15))),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 2),
                Text(time, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w600)),
                const Spacer(),
                Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                            width: 90,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Center(
                                child: Text(buttonText, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))
                            )
                        )
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}