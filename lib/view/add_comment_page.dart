import 'package:flutter/material.dart';

class AddCommentPage extends StatefulWidget {
  const AddCommentPage({super.key});

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final TextEditingController _textController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Dengarkan perubahan teks untuk mengaktifkan/menonaktifkan tombol "Add"
    _textController.addListener(() {
      setState(() {
        _isButtonEnabled = _textController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.pop(context), // Batal & Kembali
          child: const Text(
            "Cancel",
            style: TextStyle(color: Color(0xFF4A90E2), fontSize: 16),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ElevatedButton(
              // Jika tombol aktif, kembalikan teksnya ke halaman sebelumnya
              onPressed: _isButtonEnabled
                  ? () => Navigator.pop(context, _textController.text.trim())
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonEnabled ? const Color(0xFF4A90E2) : const Color(0xFFB3D4F6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Text("Add", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- AREA INPUT TEKS ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar User (Dummy Kristo William)
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      autofocus: true,
                      maxLines: null, // Bisa mengetik banyak baris ke bawah
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 18, color: Color(0xFF1E293B)),
                      decoration: InputDecoration(
                        hintText: "What's happening?",
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 18),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- AREA TOOLBAR BAWAH (Mockup Visual Sesuai Gambar) ---
          Container(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                // Mockup Galeri Foto
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      // Tombol Kamera
                      Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF4A90E2)),
                      ),

                      // Mockup Gambar 1 (Menggunakan picsum.photos yang lebih stabil)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          'https://picsum.photos/id/10/150/150',
                          width: 60, height: 60, fit: BoxFit.cover,
                          // ✅ Mencegah error layar merah jika gambar gagal dimuat
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60, height: 60, color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported_rounded, color: Colors.grey, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Mockup Gambar 2
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          'https://picsum.photos/id/13/150/150',
                          width: 60, height: 60, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60, height: 60, color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported_rounded, color: Colors.grey, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Mockup Gambar 3
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          'https://picsum.photos/id/14/150/150',
                          width: 60, height: 60, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60, height: 60, color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported_rounded, color: Colors.grey, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Mockup Icon Toolbar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.image_outlined, color: Colors.blue.shade400, size: 24),
                      const SizedBox(width: 20),
                      Icon(Icons.gif_box_outlined, color: Colors.blue.shade400, size: 24),
                      const SizedBox(width: 20),
                      Icon(Icons.poll_outlined, color: Colors.blue.shade400, size: 24),
                      const SizedBox(width: 20),
                      Icon(Icons.location_on_outlined, color: Colors.blue.shade400, size: 24),
                      const Spacer(),
                      Container(
                        width: 20, height: 20,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300, width: 2)),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.shade50),
                        child: Icon(Icons.add, color: Colors.blue.shade400, size: 16),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}