import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'sidebar_menu.dart';
import 'schedule_page.dart';
import 'announcement_page.dart';

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

  final List<Map<String, dynamic>> _feeds = [
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
                    backgroundColor: const Color(0xFFFFD54F),
                    foregroundColor: Colors.black,
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
    final List<Map<String, String>> activeAnnouncements =
        AnnouncementPage.announcements.where((a) => a['show'] == 'Yes').toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarMenu(),
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("SMK", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Islamiyah", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
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
                const CircleAvatar(radius: 28, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Hello Principle", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                    Text("Kristo William", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            
            if (activeAnnouncements.isNotEmpty) ...[
              SizedBox(
                height: 180,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) => setState(() => _currentPage = page),
                  itemCount: activeAnnouncements.length,
                  itemBuilder: (context, index) {
                    final item = activeAnnouncements[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25), 
                              child: item['isLocal'] == 'true' 
                                ? Image.file(File(item['image']!), fit: BoxFit.cover)
                                : Image.network(item['image']!, fit: BoxFit.cover),
                            ),
                          ),
                          Positioned.fill(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.1)])))),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Announcement", style: TextStyle(color: Colors.white70, fontSize: 14)),
                                const SizedBox(height: 8),
                                Text(item['title']!, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 15),
                                ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A90E2), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Explore more")),
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
                children: List.generate(activeAnnouncements.length, (index) => Container(width: _currentPage == index ? 20 : 8, height: 6, margin: const EdgeInsets.only(right: 5), decoration: BoxDecoration(color: _currentPage == index ? Colors.blue[400] : Colors.grey[300], borderRadius: BorderRadius.circular(3)))),
              ),
            ],

            const SizedBox(height: 30),
            const Text("Explore Class", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SchedulePage())),
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 215,
                      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFA726), Color(0xFFFB8C00)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
                      child: Stack(
                        children: [
                          Positioned.fill(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), gradient: LinearGradient(begin: Alignment.topLeft, end: const Alignment(0.5, 0.5), colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0)])))),
                          Positioned(bottom: -15, left: 0, right: 0, child: ClipRRect(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)), child: Image.asset('assets/images/schedule.png', height: 110, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const SizedBox.shrink()))),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Row(children: [Icon(Icons.calendar_today_rounded, color: Colors.black, size: 16), SizedBox(width: 8), Text("Schedule", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500))]),
                                SizedBox(height: 4),
                                Text("My Class", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                                Spacer(),
                                Align(alignment: Alignment.centerRight, child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black54, size: 16)),
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
                      _buildActionCard(colors: [const Color(0xFFFF8A65), const Color(0xFFF4511E)], title: "Tap In", time: "07:00", buttonText: "Check In", imagePath: 'assets/images/tap_in.png', onTap: () {}),
                      const SizedBox(height: 15),
                      _buildActionCard(colors: [const Color(0xFF7E57C2), const Color(0xFF5E35B1)], title: "Tap Out", time: "16:00", buttonText: "Check In", imagePath: 'assets/images/tap_out.png', onTap: () {}),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFFD54F), width: 1.5)),
                    child: TextField(
                      controller: _postController,
                      onSubmitted: (value) => _addNewPost(),
                      decoration: InputDecoration(
                        hintText: "What On Your Mind?",
                        border: InputBorder.none,
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                        suffixIcon: IconButton(icon: const Icon(Icons.send, color: Color(0xFFFFD54F), size: 20), onPressed: _addNewPost),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _feeds.length,
              itemBuilder: (context, index) {
                final post = _feeds[index];
                return _buildFeedItem(
                  index: index,
                  name: post['name'],
                  role: post['role'],
                  time: post['time'],
                  content: post['content'],
                  likes: post['likes'],
                  commentList: List<String>.from(post['commentList']),
                  isLiked: post['isLiked'],
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
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: LinearGradient(begin: Alignment.topLeft, end: const Alignment(0.5, 0.5), colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0)])))),
          Positioned(bottom: 0, right: 0, child: ClipRRect(borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)), child: Image.asset(imagePath, width: 85, height: 85, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const SizedBox.shrink()))),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(time, style: const TextStyle(color: Colors.black87, fontSize: 14)),
                const Spacer(),
                Material(
                  color: Colors.transparent, 
                  child: InkWell(
                    onTap: onTap, 
                    borderRadius: BorderRadius.circular(15), 
                    child: Container(
                      width: double.infinity,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3), 
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ), 
                      child: const Center(
                        child: Text("Check In", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))
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

  Widget _buildFeedItem({required int index, required String name, required String role, required String time, required String content, required int likes, required List<String> commentList, required bool isLiked}) {
    final bool hasMoreThanFive = commentList.length > 5;
    final List<String> previewComments = hasMoreThanFive ? commentList.sublist(0, 5) : commentList;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: const Color(0xFFFFD54F).withOpacity(0.3), width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(role, style: const TextStyle(fontSize: 12, color: Colors.grey))]),
              const Spacer(),
              Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF4A4A4A))),
          const SizedBox(height: 15),
          
          if (commentList.isNotEmpty) ...[
            const Divider(height: 1),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: previewComments.map((comment) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87, fontSize: 12),
                    children: [
                      const TextSpan(text: "User: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: comment),
                    ],
                  ),
                ),
              )).toList(),
            ),
            if (hasMoreThanFive)
              GestureDetector(
                onTap: () {},
                child: Text("View all ${commentList.length} comments", style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            const SizedBox(height: 10),
          ],

          Row(
            children: [
              GestureDetector(
                onTap: () => _toggleLike(index),
                child: Row(
                  children: [
                    Icon(isLiked ? Icons.thumb_up_alt_rounded : Icons.thumb_up_off_alt_rounded, size: 18, color: isLiked ? Colors.blue : const Color(0xFFFFD54F)),
                    const SizedBox(width: 5),
                    Text("$likes Likes", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => _showCommentSheet(index),
                child: Row(
                  children: [
                    const Icon(Icons.comment_rounded, size: 18, color: Color(0xFFFFD54F)),
                    const SizedBox(width: 5),
                    Text("${commentList.length} Comment", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
