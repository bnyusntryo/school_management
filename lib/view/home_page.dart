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

// ─── Design Tokens ────────────────────────────────────────────────────────────
class _T {
  static const bg         = Color(0xFFF4F6FB);
  static const surface    = Color(0xFFFFFFFF);
  static const border     = Color(0xFFEEF0F6);
  static const textPrimary   = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textMuted     = Color(0xFF94A3B8);
  static const indigo     = Color(0xFF4F46E5);
  static const indigoLight = Color(0xFFEEF2FF);
  static const green      = Color(0xFF059669);
  static const orange     = Color(0xFFF97316);
  static const purple     = Color(0xFF7C3AED);
}

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

  // ─── Fetch methods (unchanged) ──────────────────────────────────────────────

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

  bool _isNowInSchedule(String? start, String? end) {
    if (start == null || end == null) return false;
    try {
      final now = DateTime.now();
      final s = start.split(':');
      final e = end.split(':');
      final startTime = DateTime(now.year, now.month, now.day, int.parse(s[0]), int.parse(s[1]));
      final endTime   = DateTime(now.year, now.month, now.day, int.parse(e[0]), int.parse(e[1]));
      return now.isAfter(startTime) && now.isBefore(endTime);
    } catch (_) { return false; }
  }

  void _startAutoSlider() {
    _timer?.cancel();
    if (_announcements.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (t) {
      if (mounted && _pageController.hasClients) {
        _currentPage = (_currentPage + 1) % _announcements.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  String _timeAgo(String? dateString) {
    if (dateString == null) return '';
    try {
      final diff = DateTime.now().difference(DateTime.parse(dateString));
      if (diff.inDays > 0)    return '${diff.inDays} hari lalu';
      if (diff.inHours > 0)   return '${diff.inHours} jam lalu';
      if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
      return 'Baru saja';
    } catch (_) { return ''; }
  }

  void _addNewPost() {
    if (_postController.text.isNotEmpty) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      setState(() {
        _feeds.insert(0, FeedPostModel(
          feedpostId: '',
          creator: auth.userName,
          creatorStatus: auth.role,
          createdAt: DateTime.now().toIso8601String(),
          feedpostName: _postController.text,
          feedpostTotalLike: 0,
          feedpostTotalComment: 0,
          feedpostImg: [],
          userPhoto: '',
          isLikedLocal: false,
        ));
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

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final auth        = Provider.of<AuthProvider>(context);
    final role        = auth.role;
    final isStudent   = role == 'Student';
    final isPrincipal = role == 'Principal';

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarMenu(),
      backgroundColor: _T.bg,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(auth, isStudent),
            const SizedBox(height: 22),
            _buildBannerSection(),
            const SizedBox(height: 26),
            _buildSectionHeader('Explore Dashboard', null),
            const SizedBox(height: 12),
            _buildDashboardGrid(isPrincipal, isStudent),
            const SizedBox(height: 28),
            if (!isStudent) ...[
              _buildPostBox(auth, isPrincipal),
              const SizedBox(height: 24),
            ],
            _buildSectionHeader('School Feed', 'Terbaru'),
            const SizedBox(height: 14),
            _buildFeedList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ─── AppBar ─────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _T.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: _iconButton(
          Icons.menu_rounded,
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'SMK Islamiyah',
            style: TextStyle(
              color: _T.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      actions: [
        _iconButton(Icons.search_rounded),
        const SizedBox(width: 8),
        Stack(
          children: [
            _iconButton(Icons.notifications_none_rounded),
            Positioned(
              top: 6, right: 6,
              child: Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: _T.bg, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _iconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: _T.border),
        ),
        child: Icon(icon, color: _T.textSecondary, size: 18),
      ),
    );
  }

  // ─── Greeting ───────────────────────────────────────────────────────────────

  Widget _buildGreeting(AuthProvider auth, bool isStudent) {
    final initials = auth.userName.isNotEmpty
        ? auth.userName.split(' ').take(2).map((w) => w[0]).join()
        : '?';

    return Row(
      children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              initials.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SELAMAT PAGI',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: _T.textMuted,
                letterSpacing: .6,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              auth.userName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: _T.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: _T.indigoLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                auth.role,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _T.indigo,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Banner ─────────────────────────────────────────────────────────────────

  Widget _buildBannerSection() {
    if (_isLoadingBanner) {
      return Container(
        height: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _T.border),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: _T.indigo, strokeWidth: 2),
        ),
      );
    }
    if (_announcements.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (p) => setState(() => _currentPage = p),
            itemCount: _announcements.length,
            itemBuilder: (context, index) {
              final item = _announcements[index];
              return GestureDetector(
                onTap: () => _showAnnouncementDetailModal(item),
                child: _buildBannerCard(item),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_announcements.length, (i) {
            final isActive = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 20 : 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isActive ? _T.indigo : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBannerCard(AnnouncementModel item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: const Color(0xFFCBD5E1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E3A5F), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.72),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PENGUMUMAN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Section Header ─────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, String? action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: _T.textPrimary,
          ),
        ),
        if (action != null)
          Text(
            action,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _T.indigo,
            ),
          ),
      ],
    );
  }

  // ─── Dashboard Grid ─────────────────────────────────────────────────────────

  Widget _buildDashboardGrid(bool isPrincipal, bool isStudent) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Big card (left)
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => isPrincipal
                    ? const ClassActivityPage()
                    : const SchedulePage(),
              ),
            ),
            child: _buildBigCard(isPrincipal: isPrincipal, isStudent: isStudent),
          ),
        ),
        const SizedBox(width: 12),
        // Tap In / Out column (right)
        Expanded(
          child: Column(
            children: [
              _buildTapCard(
                title: 'Tap In',
                time: '07:00',
                color: _T.orange,
                accentColor: const Color(0xFFEA6A0B),
                icon: Icons.login_rounded,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tap In berhasil dicatat!'),
                    backgroundColor: Color(0xFF059669),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildTapCard(
                title: 'Tap Out',
                time: '16:00',
                color: _T.purple,
                accentColor: const Color(0xFF6D28D9),
                icon: Icons.logout_rounded,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tap Out berhasil dicatat!'),
                    backgroundColor: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBigCard({required bool isPrincipal, required bool isStudent}) {
    final cardColor = isPrincipal ? _T.green : const Color(0xFFCA8A04);
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            bottom: -20, right: -20,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 15, right: 15,
            child: Container(
              width: 55, height: 55,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: _buildBigCardContent(isPrincipal: isPrincipal, isStudent: isStudent),
          ),
        ],
      ),
    );
  }

  Widget _buildBigCardContent({required bool isPrincipal, required bool isStudent}) {
    if (isPrincipal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6, height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4ADE80),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Monitor\nKelas Aktif',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const Spacer(),
          Text(
            '24 kelas\nberjalan hari ini',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      );
    }

    if (_isLoadingClass) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      );
    }

    if (_todayClass == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isStudent ? 'Jadwal\nHari Ini' : 'Jadwal\nMengajar',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const Spacer(),
          Text(
            'Tidak ada jadwal\nhari ini',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      );
    }

    final cls = _todayClass!;
    final subtitle = isStudent ? cls.teacherName : cls.className;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: cls.isOngoing
                ? Colors.red.shade500
                : Colors.white.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (cls.isOngoing) ...[
                Container(
                  width: 5, height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Text(
                cls.isOngoing ? 'SEDANG BERLANGSUNG' : 'BERIKUTNYA',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          cls.subjectName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: -.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.82),
            fontSize: 12,
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
              color: Colors.white.withValues(alpha: 0.75),
              size: 13,
            ),
            const SizedBox(width: 5),
            Text(
              cls.timeRange,
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

  Widget _buildTapCard({
    required String title,
    required String time,
    required Color color,
    required Color accentColor,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 99,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -12, right: -12,
            child: Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                    ),
                    child: const Text(
                      'Check In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
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

  // ─── Post Box ────────────────────────────────────────────────────────────────

  Widget _buildPostBox(AuthProvider auth, bool isPrincipal) {
    final initials = auth.userName.isNotEmpty
        ? auth.userName.split(' ').take(2).map((w) => w[0]).join()
        : '?';

    return GestureDetector(
      onTap: _showCreatePostModal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _T.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Center(
                child: Text(
                  initials.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Apa yang ingin kamu bagikan?',
                style: TextStyle(
                  color: _T.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: _T.indigoLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: _T.indigo,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Feed List ──────────────────────────────────────────────────────────────

  Widget _buildFeedList() {
    if (_isLoadingFeed) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator(color: _T.indigo, strokeWidth: 2)),
      );
    }
    if (_feeds.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Belum ada postingan.',
            style: TextStyle(color: _T.textMuted, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _feeds.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final post = _feeds[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FeedDetailPage(
                post: {
                  'id': post.feedpostId,
                  'name': post.creator,
                  'role': post.creatorStatus,
                  'time': _timeAgo(post.createdAt),
                  'content': post.feedpostName,
                  'likes': post.feedpostTotalLike,
                  'totalComment': post.feedpostTotalComment, // ← fix: kirim total komentar dari API
                  'commentList': [],
                  'isLiked': post.isLikedLocal,
                },
                avatarUrl: post.avatarUrl,
              ),
            ),
          ),
          child: _buildFeedCard(post, index),
        );
      },
    );
  }

  Widget _buildFeedCard(FeedPostModel post, int index) {
    final initials = post.creator.isNotEmpty
        ? post.creator.split(' ').take(2).map((w) => w[0]).join()
        : '?';

    // Vary avatar colors by index
    final avatarColors = [
      [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
      [const Color(0xFF10B981), const Color(0xFF047857)],
      [const Color(0xFFF59E0B), const Color(0xFFB45309)],
      [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],
    ];
    final colors = avatarColors[index % avatarColors.length];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _T.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Text(
                    initials.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.creator,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: _T.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      post.creatorStatus,
                      style: const TextStyle(
                        fontSize: 11,
                        color: _T.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _timeAgo(post.createdAt),
                style: const TextStyle(
                  fontSize: 11,
                  color: _T.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),

          // Body
          Text(
            post.feedpostName,
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w500,
            ),
          ),

          // Images
          if (post.feedpostImg.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: post.feedpostImg.length,
                itemBuilder: (context, i) {
                  final url = post.feedpostImg[i].startsWith('http')
                      ? post.feedpostImg[i]
                      : 'https://schoolapp-api-dev.zeabur.app/public/uploads/${post.feedpostImg[i]}';
                  return Container(
                    width: MediaQuery.of(context).size.width *
                        (post.feedpostImg.length > 1 ? 0.7 : 0.8),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.broken_image_rounded, color: Color(0xFFCBD5E1), size: 32),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
          ),

          // Actions
          Row(
            children: [
              _feedActionBtn(
                icon: post.isLikedLocal
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: '${post.feedpostTotalLike} Suka',
                isActive: post.isLikedLocal,
                activeColor: Colors.red,
                activeBg: Colors.red.shade50,
                onTap: () => setState(() {
                  _feeds[index] = post.copyWith(
                    isLikedLocal: !post.isLikedLocal,
                    feedpostTotalLike: post.isLikedLocal
                        ? post.feedpostTotalLike - 1
                        : post.feedpostTotalLike + 1,
                  );
                }),
              ),
              const SizedBox(width: 8),
              _feedActionBtn(
                icon: Icons.chat_bubble_outline_rounded,
                label: '${post.feedpostTotalComment} Komentar',
                isActive: false,
                activeColor: _T.indigo,
                activeBg: _T.indigoLight,
                onTap: null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _feedActionBtn({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required Color activeBg,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? activeBg : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: isActive ? activeColor : _T.textMuted,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? activeColor : _T.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Modals ─────────────────────────────────────────────────────────────────

  void _showAnnouncementDetailModal(AnnouncementModel item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 10, 8),
              child: Row(
                children: [
                  const Text(
                    'Detail Pengumuman',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _T.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20, color: _T.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  item.imageUrl,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(Icons.broken_image_rounded, color: _T.textMuted, size: 36),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: _T.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.cleanDescription,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _T.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _T.indigo,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildCreatePostSheet(),
    );
  }

  Widget _buildCreatePostSheet() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final initials = auth.userName.isNotEmpty
        ? auth.userName.split(' ').take(2).map((w) => w[0]).join()
        : '?';

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36, height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Buat Postingan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _T.textPrimary),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: _T.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _T.border),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Center(
                        child: Text(
                          initials.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(auth.userName, style: const TextStyle(fontWeight: FontWeight.w700, color: _T.textPrimary)),
                        const Text('Buat postingan baru', style: TextStyle(fontSize: 11, color: _T.textMuted)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _postController,
                  maxLines: 5,
                  style: const TextStyle(fontSize: 14, color: _T.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Apa yang ingin kamu bagikan?',
                    hintStyle: TextStyle(color: _T.textMuted, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur galeri segera hadir!')),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: _T.indigoLight.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFBFCBFF)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _T.indigo,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Text(
                            'Pilih Foto',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Atau drag & drop hingga 3 file',
                          style: TextStyle(color: _T.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _T.indigo,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (_postController.text.isNotEmpty) {
                        _addNewPost();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Posting',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
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