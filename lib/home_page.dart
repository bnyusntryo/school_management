import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'sidebar_menu.dart';
import 'schedule_page.dart';
import 'announcement_page.dart';
import 'feed_detail_page.dart'; // Pastikan file ini ada

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

  // Logika Dummy Feed
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
    _startAutoSlider();
  }

  // LOGIKA 1: Auto Slider Announcement
  void _startAutoSlider() {
    final bannerCount = AnnouncementPage.announcements.where((a) => a['show'] == 'Yes').length;

    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (bannerCount > 0) {
        if (_currentPage < bannerCount - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(_currentPage, duration: const Duration(milliseconds: 800), curve: Curves.easeInOutCubic);
        }
      }
    });
  }

  // LOGIKA 2: Tambah Post
  void _addNewPost() {
    if (_postController.text.isNotEmpty) {
      setState(() {
        _feeds.insert(0, {
          "name": "Kristo William",
          "role": "Principle",
          "time": "Just Now",
          "content": _postController.text,
          "likes": 0,
          "commentList": <String>[],
          "isLiked": false,
        });
        _postController.clear();
      });
      FocusScope.of(context).unfocus(); // Tutup keyboard
    }
  }

  // LOGIKA 3: Toggle Like
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

  // LOGIKA 4: Komentar (Pop up sheet di Home Page - Opsional karena sekarang ada di Detail Page)
  void _showCommentSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add Comment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 15),
              TextField(
                controller: _commentController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      setState(() {
                        _feeds[index]['commentList'].add(_commentController.text);
                      });
                      _commentController.clear();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Post Comment", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    // MENGAMBIL DATA PENGUMUMAN DARI ANNOUNCEMENT PAGE
    final List<Map<String, String>> activeAnnouncements =
    AnnouncementPage.announcements.where((a) => a['show'] == 'Yes').toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarMenu(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("SMK", style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w900)),
            Text("Islamiyah", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black87, size: 22), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black87, size: 22), onPressed: () {}),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PROFILE SECTION ---
            Row(
              children: [
                const CircleAvatar(radius: 25, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Hello Principle", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                    SizedBox(height: 2),
                    Text("Kristo William", style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),

            // --- BANNER DINAMIS (PURE IMAGE BACKGROUND) ---
            if (activeAnnouncements.isNotEmpty) ...[
              SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) => setState(() => _currentPage = page),
                  itemCount: activeAnnouncements.length,
                  itemBuilder: (context, index) {
                    final item = activeAnnouncements[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: item['isLocal'] == 'true'
                                  ? Image.file(File(item['image']!), fit: BoxFit.cover)
                                  : Image.network(item['image']!, fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            bottom: 0, left: 0, right: 0, height: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.transparent, Colors.black.withOpacity(0.5)]
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                    "Announcement",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        shadows: [Shadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 2)]
                                    )
                                ),
                                const SizedBox(height: 2),
                                Text(
                                    item['title']!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        shadows: [Shadow(color: Colors.black45, offset: Offset(0, 2), blurRadius: 4)]
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(0xFF1A237E),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                                    ),
                                    child: const Text("Explore more", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
                                ),
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
                children: List.generate(activeAnnouncements.length, (index) => Container(
                    width: _currentPage == index ? 20 : 8, height: 6, margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(color: _currentPage == index ? const Color(0xFF3B82F6) : Colors.grey.shade300, borderRadius: BorderRadius.circular(3))
                )),
              ),
            ],

            const SizedBox(height: 30),
            const Text("Explore Class", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
            const SizedBox(height: 15),

            // --- EXPLORE CLASS GRID ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SchedulePage())),
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 225,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFFFCA28), Color(0xFFFF9800)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                              bottom: 0, left: 0, right: 0,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                  child: Image.asset('assets/images/schedule_books.png', height: 90, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(height: 90, color: Colors.black12, child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 50)))
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("My Schedule\nClass", style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w900, height: 1.2)),
                                SizedBox(height: 15),
                                Text("No class\nschedule\ntoday", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, height: 1.3)),
                              ],
                            ),
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
                          imagePath: 'assets/images/tap_in_illustration.png',
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
                          imagePath: 'assets/images/tap_out_illustration.png',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tap Out Recorded!"), backgroundColor: Colors.blue));
                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- CREATE POST INPUT ---
            Row(
              children: [
                const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFFFCA28), width: 1.5)
                    ),
                    child: TextField(
                      controller: _postController,
                      onSubmitted: (value) => _addNewPost(),
                      decoration: InputDecoration(
                        hintText: "What On Your Mind?",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500),
                        suffixIcon: IconButton(icon: const Icon(Icons.send_rounded, color: Color(0xFFFFCA28), size: 20), onPressed: _addNewPost),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // --- SOSIAL FEED LIST ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _feeds.length,
              itemBuilder: (context, index) {
                final post = _feeds[index];
                String avatarUrl = 'https://i.pravatar.cc/150?img=${10 + index}';

                // ✅ GESTURE DETECTOR DITAMBAHKAN DI SINI UNTUK NAVIGASI
                return GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman detail feed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedDetailPage(
                          post: post,
                          avatarUrl: avatarUrl,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200, width: 1.5)
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
                                  Text(post['name'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF1E293B))),
                                  const SizedBox(height: 2),
                                  Text(post['role'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500))
                                ]
                            ),
                            const Spacer(),
                            Text(post['time'], style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(post['content'], style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF334155), fontWeight: FontWeight.w500)),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            // Tombol Like (Memerlukan penanganan tap terpisah agar tidak trigger tap Container)
                            GestureDetector(
                              onTap: () {
                                _toggleLike(index);
                              },
                              child: Row(
                                children: [
                                  Icon(post['isLiked'] ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 20, color: post['isLiked'] ? Colors.red : Colors.grey.shade500),
                                  const SizedBox(width: 6),
                                  Text("${post['likes']} Likes", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 25),
                            // Bagian Comment, jika ditap juga akan membuka FeedDetailPage karena inherit dari Container,
                            // namun kita bisa tambahkan onTap spesifik ke _showCommentSheet jika diinginkan.
                            // Untuk saat ini dibiarkan untuk men-trigger navigasi halaman Detail (atau membuka Bottom Sheet di Home).
                            GestureDetector(
                              onTap: () {
                                // Anda bisa memilih apakah tap icon komen membuka modal sheet atau masuk ke detail page.
                                // Sesuai permintaan desain, kita asumsikan masuk ke detail page.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FeedDetailPage(
                                      post: post,
                                      avatarUrl: avatarUrl,
                                    ),
                                  ),
                                );
                                // _showCommentSheet(index); // Buka ini jika ingin modal sheet tetap muncul di Home Page.
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.grey.shade500),
                                  const SizedBox(width: 6),
                                  Text("${post['commentList'].length} Comments", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
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

  Widget _buildActionCard({required List<Color> colors, required String title, required String time, required String buttonText, required String imagePath, VoidCallback? onTap}) {
    return Container(
      width: double.infinity,
      height: 105,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
              bottom: 0, right: 0,
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
                  child: Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const SizedBox.shrink())
              )
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 2),
                Text(time, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                const Spacer(),
                Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                            width: 90,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Center(
                                child: Text(buttonText, style: const TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold))
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