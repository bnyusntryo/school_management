import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:school_management/view/auth/auth_provider.dart';
import 'package:school_management/view/school_activity/class_activity_page.dart';
import '../model/announcement_model.dart';
import '../model/feed_model.dart';
import '../model/today_class_model.dart';
import '../viewmodel/home_viewmodel.dart';
import 'sidebar_menu.dart';
import 'schedule_page.dart';
import 'feed_detail_page.dart';

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
  final _viewmodel = HomeViewmodel();
  int _currentPage = 0;
  Timer? _timer;

  List<AnnouncementModel> _announcements = [];
  bool _isLoadingBanner = true;

  List<FeedPostModel> _feeds = [];
  bool _isLoadingFeed = true;

  TodayClassModel? _todayClass;
  bool _isLoadingClass = true;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
    _fetchTodayClass();
    _fetchFeedList();
  }

  void _showAnnouncementDetailModal(AnnouncementModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 10,
                  top: 10,
                  bottom: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Announcement Detail",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.imageUrl,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      height: 160,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.cleanDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
                    const Text(
                      "Create Post",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
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
                                : 'https://i.pravatar.cc/150?img=12',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authData.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Create a new post",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
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
                          const SnackBar(
                            content: Text("Gallery feature coming soon!"),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.blue.shade100,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "Choose",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Drag and drop up to 3 files to upload.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_postController.text.isNotEmpty) {
                            _addNewPost();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Post",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Future<void> _fetchAnnouncements() async {
    try {
      final resp = await _viewmodel.getAnnouncements();
      if (!mounted) return;
      if (resp.data is List) {
        final list = (resp.data as List)
            .map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
            .where((a) => a.shouldShow)
            .toList();
        setState(() {
          _announcements = list;
          _isLoadingBanner = false;
        });
        _startAutoSlider();
      } else {
        setState(() => _isLoadingBanner = false);
      }
    } catch (e) {
      debugPrint('Error fetch announcements: $e');
      if (mounted) setState(() => _isLoadingBanner = false);
    }
  }

  Future<void> _fetchTodayClass() async {
    try {
      final resp = await _viewmodel.getTodayClass();
      if (!mounted) return;

      final dataNode = resp.data;
      List classList = dataNode is List
          ? dataNode
          : (dataNode is Map ? (dataNode['data'] ?? []) : []);

      TodayClassModel? activeOrNext;
      if (classList.isNotEmpty) {
        for (var c in classList) {
          if (_isNowInSchedule(
            c['schedule_time_start']?.toString(),
            c['schedule_time_end']?.toString(),
          )) {
            activeOrNext = TodayClassModel.fromJson(
              c as Map<String, dynamic>,
              isOngoing: true,
            );
            break;
          }
        }
        activeOrNext ??= TodayClassModel.fromJson(
          classList.first as Map<String, dynamic>,
          isOngoing: false,
        );
      }

      setState(() {
        _todayClass = activeOrNext;
        _isLoadingClass = false;
      });
    } catch (e) {
      debugPrint('Error fetch today class: $e');
      if (mounted) setState(() => _isLoadingClass = false);
    }
  }

  Future<void> _fetchFeedList() async {
    try {
      final resp = await _viewmodel.getFeedList();
      if (!mounted) return;
      if (resp.data is List) {
        final list = (resp.data as List)
            .map((e) => FeedPostModel.fromJson(e as Map<String, dynamic>))
            .toList();
        setState(() {
          _feeds = list;
          _isLoadingFeed = false;
        });
      } else {
        setState(() => _isLoadingFeed = false);
      }
    } catch (e) {
      debugPrint('Error fetch feed: $e');
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

      final startTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(startParts[0]),
        int.parse(startParts[1]),
      );
      final endTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );

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
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _addNewPost() {
    if (_postController.text.isNotEmpty) {
      final authData = Provider.of<AuthProvider>(context, listen: false);

      setState(() {
        _feeds.insert(
          0,
          FeedPostModel(
            feedpostId: '',
            creator: authData.userName,
            creatorStatus: authData.role,
            createdAt: DateTime.now().toIso8601String(),
            feedpostName: _postController.text,
            feedpostTotalLike: 0,
            feedpostTotalComment: 0,
            feedpostImg: [],
            userPhoto: '',
            isLikedLocal: false,
          ),
        );
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
            Text(
              "SMK",
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              "Islamiyah",
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF0F172A), size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Color(0xFF0F172A),
              size: 22,
            ),
            onPressed: () {},
          ),
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
                    isStudent
                        ? 'https://i.pravatar.cc/150?img=11'
                        : 'https://i.pravatar.cc/150?img=12',
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello $currentRole",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      authData.userName,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                  onPageChanged: (int page) =>
                      setState(() => _currentPage = page),
                  itemCount: _announcements.length,
                  itemBuilder: (context, index) {
                    final item = _announcements[index];

                    return GestureDetector(
                      onTap: () => _showAnnouncementDetailModal(item),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.broken_image_rounded,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 90,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.7),
                                    ],
                                  ),
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
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                children: List.generate(
                  _announcements.length,
                  (index) => Container(
                    width: _currentPage == index ? 20 : 8,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFF3B82F6)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Explore Dashboard",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Icon(
                  Icons.dashboard_rounded,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SchedulePage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ClassActivityPage(),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      height: 225,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isPrincipal
                              ? [
                                  const Color(0xFF10B981),
                                  const Color(0xFF059669),
                                ]
                              : [
                                  const Color(0xFFFFCA28),
                                  const Color(0xFFFF9800),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: (isPrincipal ? Colors.green : Colors.orange)
                                .withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: Icon(
                              isPrincipal
                                  ? Icons.bar_chart_rounded
                                  : Icons.menu_book_rounded,
                              color: Colors.white.withValues(alpha: 0.2),
                              size: 120,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: _buildScheduleCardContent(
                              isPrincipal: isPrincipal,
                              isStudent: isStudent,
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
                        colors: [
                          const Color(0xFFFF8A65),
                          const Color(0xFFF4511E),
                        ],
                        title: "Tap In",
                        time: "07:00",
                        buttonText: "Check In",
                        icon: Icons.login_rounded,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Tap In Recorded!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildActionCard(
                        colors: [
                          const Color(0xFF9FA8DA),
                          const Color(0xFF5E35B1),
                        ],
                        title: "Tap Out",
                        time: "16:00",
                        buttonText: "Check In",
                        icon: Icons.logout_rounded,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Tap Out Recorded!"),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
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
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=${isPrincipal ? 12 : 15}',
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              "What's on your mind?",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.send_rounded,
                              color: Color(0xFF3B82F6),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ],

            const Text(
              "School Feed",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 15),

            if (_isLoadingFeed)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
                ),
              )
            else if (_feeds.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: Text(
                    "No posts yet.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _feeds.length,
                itemBuilder: (context, index) {
                  final post = _feeds[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedDetailPage(
                            post: {
                              "id": post.feedpostId,
                              "name": post.creator,
                              "role": post.creatorStatus,
                              "time": _timeAgo(post.createdAt),
                              "content": post.feedpostName,
                              "likes": post.feedpostTotalLike,
                              "commentList": [],
                              "isLiked": post.isLikedLocal,
                            },
                            avatarUrl: post.avatarUrl,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF94A3B8).withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: NetworkImage(post.avatarUrl),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.creator,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15,
                                        color: Color(0xFF0F172A),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      post.creatorStatus,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                _timeAgo(post.createdAt),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            post.feedpostName,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              color: Color(0xFF334155),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          if (post.feedpostImg.isNotEmpty)
                            Container(
                              height: 180,
                              margin: const EdgeInsets.only(top: 15),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: post.feedpostImg.length,
                                itemBuilder: (context, imgIndex) {
                                  final imageName = post.feedpostImg[imgIndex];
                                  final fullImageUrl =
                                      imageName.startsWith('http')
                                      ? imageName
                                      : 'https://schoolapp-api-dev.zeabur.app/public/uploads/$imageName';

                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        (post.feedpostImg.length > 1
                                            ? 0.75
                                            : 0.85),
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Center(
                                                child: Icon(
                                                  Icons.broken_image_rounded,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Divider(
                              color: Color(0xFFF1F5F9),
                              thickness: 1.5,
                            ),
                          ),

                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _feeds[index] = post.copyWith(
                                      isLikedLocal: !post.isLikedLocal,
                                      feedpostTotalLike: post.isLikedLocal
                                          ? post.feedpostTotalLike - 1
                                          : post.feedpostTotalLike + 1,
                                    );
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: post.isLikedLocal
                                        ? Colors.red.shade50
                                        : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        post.isLikedLocal
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        size: 18,
                                        color: post.isLikedLocal
                                            ? Colors.red
                                            : Colors.grey.shade500,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "${post.feedpostTotalLike} Likes",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: post.isLikedLocal
                                              ? Colors.red.shade700
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 18,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "${post.feedpostTotalComment} Comments",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildScheduleCardContent({
    required bool isPrincipal,
    required bool isStudent,
  }) {
    if (isPrincipal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Monitor\nActive Class",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "24 Classes\nActive Today",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      );
    }

    if (_isLoadingClass) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_todayClass == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isStudent ? "My Schedule\nClass" : "Teaching\nSchedule",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "No class\nschedule\ntoday",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      );
    }

    final todayClass = _todayClass!;
    final String subtitle = isStudent ? todayClass.teacherName : todayClass.className;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (todayClass.isOngoing)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade500,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.circle, color: Colors.white, size: 8),
                SizedBox(width: 4),
                Text(
                  "ONGOING",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              "UPCOMING",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),

        const SizedBox(height: 12),
        Text(
          todayClass.subjectName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              color: Colors.white.withValues(alpha: 0.8),
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              todayClass.timeRange,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required List<Color> colors,
    required String title,
    required String time,
    required String buttonText,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 105,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.last.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -15,
            right: -15,
            child: Icon(icon, size: 80, color: Colors.white.withValues(alpha: 0.15)),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
