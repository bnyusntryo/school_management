import 'package:flutter/material.dart';

import '../model/feed_model.dart';
import '../viewmodel/feed_viewmodel.dart';
import 'add_comment_page.dart';

// ─── Design Tokens (same as home_page.dart) ───────────────────────────────────
class _T {
  static const bg            = Color(0xFFF8F9FC);
  static const surface       = Color(0xFFFFFFFF);
  static const border        = Color(0xFFEEF0F6);
  static const divider       = Color(0xFFF8FAFC);
  static const textPrimary   = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textMuted     = Color(0xFF94A3B8);
  static const textHint      = Color(0xFFCBD5E1);
  static const indigo        = Color(0xFF4F46E5);
  static const indigoLight   = Color(0xFFEEF2FF);
}

// ─── Avatar color palette (cycles by index / hash) ───────────────────────────
List<Color> _avatarGradient(String name) {
  final palettes = [
    [const Color(0xFF6366F1), const Color(0xFF8B5CF6)], // indigo-purple
    [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)], // blue
    [const Color(0xFF10B981), const Color(0xFF047857)], // green
    [const Color(0xFFF59E0B), const Color(0xFFB45309)], // amber
    [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)], // purple
    [const Color(0xFF0EA5E9), const Color(0xFF0369A1)], // sky
    [const Color(0xFFEF4444), const Color(0xFFB91C1C)], // red
  ];
  final idx = name.isNotEmpty ? name.codeUnitAt(0) % palettes.length : 0;
  return palettes[idx];
}

String _initials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  if (parts[0].isNotEmpty) return parts[0][0].toUpperCase();
  return '?';
}

class FeedDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;
  final String avatarUrl;

  const FeedDetailPage({
    super.key,
    required this.post,
    required this.avatarUrl,
  });

  @override
  State<FeedDetailPage> createState() => _FeedDetailPageState();
}

class _FeedDetailPageState extends State<FeedDetailPage> {
  final _viewmodel = FeedViewmodel();

  List<CommentModel> _comments = [];
  bool _isLoadingComments = true;

  // Pakai total dari API feed sebagai nilai awal,
  // baru di-update setelah fetch komentar selesai.
  late int _commentCount;

  @override
  void initState() {
    super.initState();
    // Seed dari total komentar yang sudah ada di model feed,
    // supaya angka tidak loncat/berubah saat fetch selesai.
    _commentCount = (widget.post['totalComment'] as int?)
        ?? (widget.post['commentCount'] as int?)
        ?? 0;
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final feedpostId = widget.post['id']?.toString() ?? '';
    if (feedpostId.isEmpty) {
      if (mounted) setState(() => _isLoadingComments = false);
      return;
    }
    try {
      final resp = await _viewmodel.getComments(feedpostId: feedpostId);
      if (!mounted) return;
      setState(() {
        _comments = resp.data != null
            ? (resp.data as List).map((e) => CommentModel.fromJson(e)).toList()
            : [];
        // Setelah fetch selesai, update ke jumlah yang benar dari API.
        // Ini menyelaraskan angka yang sebelumnya bisa beda
        // antara feed list (totalComment) vs hasil fetch komentar.
        _commentCount = _comments.length;
        _isLoadingComments = false;
      });
    } catch (e) {
      debugPrint('Error fetch comments: $e');
      if (mounted) setState(() => _isLoadingComments = false);
    }
  }

  String _timeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final diff = DateTime.now().difference(DateTime.parse(dateString));
      if (diff.inDays > 0)    return '${diff.inDays} hari lalu';
      if (diff.inHours > 0)   return '${diff.inHours} jam lalu';
      if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
      return 'Baru saja';
    } catch (_) { return ''; }
  }

  void _toggleLike() {
    setState(() {
      final isLiked = widget.post['isLiked'] ?? false;
      widget.post['isLiked'] = !isLiked;
      widget.post['likes'] = (widget.post['likes'] ?? 0) + (isLiked ? -1 : 1);
    });
  }

  Future<void> _openAddCommentPage() async {
    final newComment = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddCommentPage()),
    );
    if (newComment != null && newComment.toString().isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _comments.insert(
          0,
          CommentModel(
            commenter: 'Saya',
            commentText: newComment.toString(),
            createdAt: DateTime.now().toIso8601String(),
            userPhoto: '',
          ),
        );
        _commentCount++; // sync counter dengan list lokal
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Komentar berhasil dikirim!'),
          backgroundColor: Color(0xFF059669),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLiked = widget.post['isLiked'] ?? false;
    final likeCount = widget.post['likes'] ?? 0;
    final posterName = widget.post['name'] ?? '';
    final posterRole = widget.post['role'] ?? '';
    final postTime   = widget.post['time'] ?? '';
    final content    = widget.post['content'] ?? '';

    return Scaffold(
      backgroundColor: _T.bg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Post card ──────────────────────────────────────────────────────
          Container(
            color: _T.surface,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster row
                Row(
                  children: [
                    _buildAvatar(posterName, size: 44, radius: 14),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            posterName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: _T.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            posterRole,
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
                      postTime,
                      style: const TextStyle(
                        fontSize: 11,
                        color: _T.textHint,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Post content
                const SizedBox(height: 14),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.65,
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Divider
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                ),

                // Actions
                Row(
                  children: [
                    _buildActionPill(
                      icon: isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      label: '$likeCount Suka',
                      isActive: isLiked,
                      activeColor: Colors.red,
                      activeBg: Colors.red.shade50,
                      onTap: _toggleLike,
                    ),
                    const SizedBox(width: 8),
                    _buildActionPill(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: '$_commentCount Komentar',
                      isActive: false,
                      activeColor: _T.indigo,
                      activeBg: _T.indigoLight,
                      onTap: _openAddCommentPage,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Section divider ────────────────────────────────────────────────
          Container(height: 8, color: const Color(0xFFF1F5F9)),

          // ── Comments header ────────────────────────────────────────────────
          Container(
            color: _T.surface,
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Komentar',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _T.textPrimary,
                  ),
                ),
                if (!_isLoadingComments)
                  Text(
                    '$_commentCount komentar',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _T.textMuted,
                    ),
                  ),
              ],
            ),
          ),

          // ── Comment list ───────────────────────────────────────────────────
          Expanded(child: _buildCommentList()),
        ],
      ),

      // ── Bottom add-comment bar ─────────────────────────────────────────────
      bottomNavigationBar: _buildAddCommentBar(posterName),
    );
  }

  // ─── AppBar ─────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _T.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: _T.surface,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: _T.border),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _T.textSecondary,
              size: 16,
            ),
          ),
        ),
      ),
      title: const Text(
        'Detail Postingan',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: _T.textPrimary,
        ),
      ),
    );
  }

  // ─── Action pill ────────────────────────────────────────────────────────────

  Widget _buildActionPill({
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
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? activeBg : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isActive ? activeColor : _T.textMuted),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isActive ? activeColor : _T.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Comment list ────────────────────────────────────────────────────────────

  Widget _buildCommentList() {
    if (_isLoadingComments) {
      return const Center(
        child: CircularProgressIndicator(color: _T.indigo, strokeWidth: 2),
      );
    }

    if (_comments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _comments.length,
      itemBuilder: (context, index) {
        final comment = _comments[index];
        return Column(
          children: [
            _buildCommentItem(comment),
            if (index < _comments.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 62),
                child: Divider(height: 1, thickness: 1, color: Color(0xFFF8FAFC)),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
    return Container(
      color: _T.surface,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(comment.commenter, size: 34, radius: 11),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        comment.commenter,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _T.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _timeAgo(comment.createdAt),
                      style: const TextStyle(
                        fontSize: 10,
                        color: _T.textHint,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  comment.commentText,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.55,
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 28,
              color: _T.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Belum ada komentar',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _T.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Jadilah yang pertama berkomentar',
            style: TextStyle(
              fontSize: 12,
              color: _T.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bottom add-comment bar ──────────────────────────────────────────────────

  Widget _buildAddCommentBar(String posterName) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: _T.bg,
          border: Border(top: BorderSide(color: _T.border, width: 1)),
        ),
        child: Row(
          children: [
            _buildAvatar(posterName, size: 34, radius: 11),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: _openAddCommentPage,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _T.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _T.border),
                  ),
                  child: const Text(
                    'Tulis komentar...',
                    style: TextStyle(
                      fontSize: 12,
                      color: _T.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _openAddCommentPage,
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: _T.indigo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Shared: Rounded-square avatar ──────────────────────────────────────────

  Widget _buildAvatar(String name, {required double size, required double radius}) {
    final colors = _avatarGradient(name);
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: Text(
          _initials(name),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.32,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}