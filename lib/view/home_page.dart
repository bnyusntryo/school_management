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

  final String baseImageUrl = 'https://fastly.picsum.photos/id/517/1600/900.jpg?hmac=CdnOMbQEo4LItWYoyDHPpmPs3HPyGBFBnOFiel377XI/';

  final List<Map<String, dynamic>> _feeds = [
    {
      "name": "Lisa Tran",
      "role": "Guru Matematika",
      "time": "10 Minutes Ago",
      "content": "Hi everyone! I've been thinking about some new teaching strategies to engage our students more. Would love to hear your ideas!",
      "likes": 8,
      "commentList": ["Great idea!", "Let's discuss tomorrow.", "Very inspiring."],
      "isLiked": false,
    },
    {
      "name": "Mike Johnson",
      "role": "Kepala Departemen",
      "time": "15 Minutes Ago",
      "content": "Hello team! Excited to kick off this project. Let's collaborate and bring our best selves to the table!",
      "likes": 10,
      "commentList": ["Ready!", "Let's go team", "Can't wait", "Awesome"],
      "isLiked": false,
    },
    {
      "name": "Alex Richardson",
      "role": "Kepala Sekolah",
      "time": "5 Minutes Ago",
      "content": "Hey there! Just wanted to share some thoughts with you. It's all about keeping things light and fun, right? Let's dive into the good stuff!",
      "likes": 12,
      "commentList": ["Great insights, Alex!", "Agreed, keep it positive."],
      "isLiked": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    try {
      String? token = await Session().getUserToken();
      print("🎫 CEK TOKEN DI HP: $token");

      final response = await http.post(
        Uri.parse('https://schoolapp-api-dev.zeabur.app/api/home/announcement'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({}),
      );

      print("📡 STATUS DARI SERVER: ${response.statusCode}");
      print("📦 BALASAN SERVER: ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (mounted) {
          setState(() {
            _announcements = (result['data'] as List)
                .where((item) => item['show_announcement'] == 'Y')
                .toList();
            _isLoadingBanner = false;
          });
          print("✅ BERHASIL! Jumlah pengumuman: ${_announcements.length}");
          _startAutoSlider();
        }
      } else {
        print("❌ GAGAL! Server menolak. Status: ${response.statusCode}");
        if (mounted) setState(() => _isLoadingBanner = false);
      }
    } catch (e) {
      print("🚨 ERROR FATAL: $e");
      if (mounted) setState(() => _isLoadingBanner = false);
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
        _feeds.insert(0, {
          "name": authData.userName,
          "role": authData.role,
          "time": "Just Now",
          "content": _postController.text,
          "likes": 0,
          "commentList": <String>[],
          "isLiked": false,
        });
        _postController.clear();
      });
      FocusScope.of(context).unfocus();
    }
  }

  void _toggleLike(int index) {
    setState(() {
      bool currentStatus = _feeds[index]['isLiked'];
      _feeds[index]['isLiked'] = !currentStatus;
      if (!currentStatus) {
        _feeds[index]['likes']++;
      } else {
        _feeds[index]['likes']--;
      }
    });
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
                    return Container(
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
              Row(
                children: [
                  CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${isPrincipal ? 12 : 15}')),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]
                      ),
                      child: TextField(
                        controller: _postController,
                        onSubmitted: (value) => _addNewPost(),
                        decoration: InputDecoration(
                          hintText: "Share an announcement or idea...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500),
                          suffixIcon: IconButton(icon: const Icon(Icons.send_rounded, color: Color(0xFF3B82F6), size: 20), onPressed: _addNewPost),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
            ],

            const Text("School Feed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _feeds.length,
              itemBuilder: (context, index) {
                final post = _feeds[index];
                String avatarUrl = 'https://i.pravatar.cc/150?img=${10 + index}';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FeedDetailPage(post: post, avatarUrl: avatarUrl)));
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
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post['name'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF0F172A))),
                                  const SizedBox(height: 2),
                                  Text(post['role'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500))
                                ]
                            ),
                            const Spacer(),
                            Text(post['time'], style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(post['content'], style: const TextStyle(fontSize: 13, height: 1.6, color: Color(0xFF334155), fontWeight: FontWeight.w500)),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5)),

                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleLike(index),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: post['isLiked'] ? Colors.red.shade50 : Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Icon(post['isLiked'] ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 18, color: post['isLiked'] ? Colors.red : Colors.grey.shade500),
                                    const SizedBox(width: 6),
                                    Text("${post['likes']} Likes", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: post['isLiked'] ? Colors.red.shade700 : Colors.grey.shade600)),
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
                                  Text("${post['commentList'].length} Comments", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
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

    bool hasOngoingClass = true;

    if (hasOngoingClass) {
      Map<String, String> data = isStudent
          ? {"subject": "Matematika", "subtitle": "Bpk. Yoga Pratama", "time": "08:00 - 09:30", "room": "Kelas XII-A"}
          : {"subject": "Matematika", "subtitle": "Kelas XII TKJ B", "time": "08:00 - 09:30", "room": "Lab Komputer 1"};

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          ),
          const SizedBox(height: 12),
          Text(data['subject']!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
          const SizedBox(height: 4),
          Text(data['subtitle']!, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w600)),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.access_time_rounded, color: Colors.white.withOpacity(0.8), size: 14),
              const SizedBox(width: 6),
              Text(data['time']!, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: Colors.white.withOpacity(0.8), size: 14),
              const SizedBox(width: 6),
              Text(data['room']!, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isStudent ? "My Schedule\nClass" : "Teaching\nSchedule", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, height: 1.2)),
          const SizedBox(height: 15),
          Text("No class\nschedule\ntoday", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w600, height: 1.3)),
        ],
      );
    }
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