import 'package:flutter/material.dart';
import 'add_comment_page.dart'; // Import halaman baru

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
  // Data Dummy Komentar
  late List<Map<String, String>> _richComments;

  @override
  void initState() {
    super.initState();
    _richComments = [
      {
        "firstName": "Yoga",
        "fullName": "Yoga Pratama",
        "text": "Y'all ready for this next post?",
        "avatar": "https://i.pravatar.cc/150?img=11"
      },
      {
        "firstName": "Nina",
        "fullName": "Nina Thompson",
        "text": "Can't wait to share this new flow!",
        "avatar": "https://i.pravatar.cc/150?img=5"
      },
      {
        "firstName": "Mark",
        "fullName": "Mark Ellison",
        "text": "What a transformative session today!",
        "avatar": "https://i.pravatar.cc/150?img=13"
      },
    ];
  }

  // FUNGSI TOGGLE LIKE
  void _toggleLike() {
    setState(() {
      bool isCurrentlyLiked = widget.post['isLiked'];
      widget.post['isLiked'] = !isCurrentlyLiked;

      if (!isCurrentlyLiked) {
        widget.post['likes']++; // Tambah angka
      } else {
        widget.post['likes']--; // Kurangi angka
      }
    });
  }

  // FUNGSI MEMBUKA HALAMAN KOMENTAR BARU
  Future<void> _openAddCommentPage() async {
    // Menunggu kembalian teks dari layar AddCommentPage
    final newComment = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCommentPage()),
    );

    // Jika pengguna mengetik sesuatu dan menekan "Add"
    if (newComment != null && newComment.toString().isNotEmpty) {
      setState(() {
        _richComments.insert(0, {
          "firstName": "Me",
          "fullName": "Kristo William",
          "text": newComment.toString(),
          "avatar": "https://i.pravatar.cc/150?img=12"
        });

        // Update counter di objek post asli agar di Home juga bertambah
        widget.post['commentList'].add(newComment.toString());
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment posted!"), backgroundColor: Colors.green),
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Tombol Floating Action Button (FAB) "+" SUDAH DIHAPUS DARI SINI

      body: Column(
        children: [
          // --- BAGIAN POSTINGAN UTAMA ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 25, backgroundImage: NetworkImage(widget.avatarUrl)),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.post['name'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1E293B))),
                        const SizedBox(height: 2),
                        Text(widget.post['role'], style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Spacer(),
                    Text(widget.post['time'], style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(height: 1, thickness: 1),
                ),

                Text(
                  widget.post['content'],
                  style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    // TOMBOL LIKE
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Row(
                        children: [
                          Icon(
                              widget.post['isLiked'] ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 20,
                              color: widget.post['isLiked'] ? Colors.red : Colors.grey.shade500
                          ),
                          const SizedBox(width: 6),
                          Text(
                              "${widget.post['likes']} Likes",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: widget.post['isLiked'] ? Colors.red : Colors.grey.shade700
                              )
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 25),

                    // ✅ TOMBOL COMMENTS (Sekarang bisa diklik dan mengarah ke halaman AddCommentPage)
                    GestureDetector(
                      onTap: _openAddCommentPage, // Panggil fungsi ke halaman Add Comment di sini
                      child: Row(
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.grey.shade500),
                          const SizedBox(width: 6),
                          Text(
                              "${_richComments.length} Comment${_richComments.length > 1 ? 's' : ''}",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)
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

          // --- DAFTAR KOMENTAR ---
          Expanded(
            child: ListView.separated(
              // Padding bawah dikurangi karena tidak ada tombol Plus lagi
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              itemCount: _richComments.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
              itemBuilder: (context, index) {
                final comment = _richComments[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 20, backgroundImage: NetworkImage(comment['avatar']!)),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.favorite, size: 12, color: Colors.grey.shade400),
                                const SizedBox(width: 5),
                                Text("${comment['firstName']} Commented", style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(comment['fullName']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF1E293B))),
                            const SizedBox(height: 4),
                            Text(comment['text']!, style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4)),
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