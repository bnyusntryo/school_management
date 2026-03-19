import 'package:flutter/material.dart';

import '../model/feed_model.dart';
import '../viewmodel/feed_viewmodel.dart';
import 'add_comment_page.dart';

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

  @override
  void initState() {
    super.initState();
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
        _isLoadingComments = false;
      });
    } catch (e) {
      debugPrint('Error fetch comments: $e');
      if (mounted) setState(() => _isLoadingComments = false);
    }
  }

  String _timeAgo(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final time = DateTime.parse(dateString);
      final diff = DateTime.now().difference(time);
      if (diff.inDays > 0) return '${diff.inDays}d';
      if (diff.inHours > 0) return '${diff.inHours}h';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m';
      return 'Now';
    } catch (_) {
      return '';
    }
  }

  void _toggleLike() {
    setState(() {
      bool isCurrentlyLiked = widget.post['isLiked'] ?? false;
      widget.post['isLiked'] = !isCurrentlyLiked;
      widget.post['likes'] += isCurrentlyLiked ? -1 : 1;
    });
  }

  Future<void> _openAddCommentPage() async {
    final newComment = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCommentPage()),
    );

    if (newComment != null && newComment.toString().isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _comments.insert(
          0,
          CommentModel(
            commenter: 'Me (Local)',
            commentText: newComment.toString(),
            createdAt: DateTime.now().toIso8601String(),
            userPhoto: 'https://i.pravatar.cc/150?img=12',
          ),
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment posted!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(widget.avatarUrl),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post['name'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: Color(0xFF1E293B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.post['role'] ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.post['time'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(height: 1, thickness: 1),
                ),

                Text(
                  widget.post['content'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Row(
                        children: [
                          Icon(
                            widget.post['isLiked'] == true
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 20,
                            color: widget.post['isLiked'] == true
                                ? Colors.red
                                : Colors.grey.shade500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.post['likes'] ?? 0} Likes',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.post['isLiked'] == true
                                  ? Colors.red
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 25),

                    GestureDetector(
                      onTap: _openAddCommentPage,
                      child: Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 18,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_comments.length} Comment${_comments.length != 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
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

          Container(height: 8, color: Colors.grey.shade100),

          if (_isLoadingComments)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            )
          else if (_comments.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 60,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'No comments yet.',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                itemCount: _comments.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, indent: 70),
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(comment.avatarUrl),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      comment.commenter,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        color: Color(0xFF1E293B),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    _timeAgo(comment.createdAt),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                comment.commentText,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF334155),
                                  height: 1.4,
                                ),
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
        ],
      ),
    );
  }
}
