import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  static List<Map<String, String>> announcements = [
    {
      "id": "20-Jan-2025 10:00",
      "title": "Testing Announcement",
      "show": "Yes",
      "description": "This is a detailed description.",
      "image": "https://img.freepik.com/free-vector/hand-drawn-phone-social-media-concept_23-2149118557.jpg",
      "isLocal": "false"
    },
  ];

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.teal.shade400, Colors.teal.shade800],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Announcements",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: AnnouncementPage.announcements.isEmpty
                ? SliverToBoxAdapter(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Icon(Icons.campaign_rounded, size: 80, color: Colors.grey.shade300),
                    const SizedBox(height: 15),
                    Text("No Announcements Yet", style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = AnnouncementPage.announcements[index];
                  return _buildAnnouncementCard(item, index);
                },
                childCount: AnnouncementPage.announcements.length,
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: Colors.teal.shade600,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildAnnouncementCard(Map<String, String> item, int index) {
    bool isShow = item['show'] == 'Yes';
    bool isLocal = item['isLocal'] == "true";
    String imagePath = item['image'] ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: imagePath.isEmpty
                    ? Icon(Icons.image_not_supported_rounded, color: Colors.grey.shade400, size: 30)
                    : (isLocal
                    ? Image.file(File(imagePath), fit: BoxFit.cover)
                    : Image.network(imagePath, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image_rounded, color: Colors.grey.shade400))),
              ),
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        item['id']!,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isShow ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isShow ? Colors.green.shade200 : Colors.red.shade200),
                    ),
                    child: Text(
                      isShow ? "Visible" : "Hidden",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isShow ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: Icon(Icons.edit_note_rounded, color: Colors.teal.shade500, size: 26),
              onPressed: () => _showAddEditDialog(existingData: item, index: index),
              tooltip: "Edit",
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEditDialog({Map<String, String>? existingData, int? index}) {
    final titleCtrl = TextEditingController(text: existingData?['title']);
    final descCtrl = TextEditingController(text: existingData?['description']);
    String showValue = existingData?['show'] ?? 'Yes';
    String? currentImagePath = existingData?['image'];
    bool isImageLocal = existingData?['isLocal'] == "true";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          existingData == null ? "Add Announcement" : "Edit Announcement",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal.shade800)
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),

                  _buildModalInputField("Announcement Title", titleCtrl, Icons.title_rounded, maxLines: 1),
                  const SizedBox(height: 15),
                  _buildModalInputField("Description", descCtrl, Icons.description_rounded, maxLines: 3),
                  const SizedBox(height: 15),

                  Text("Show Announcement", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: showValue,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.teal.shade400),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.visibility_rounded, color: Colors.teal.shade400, size: 20),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    ),
                    items: ['Yes', 'No'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontWeight: FontWeight.w500)))).toList(),
                    onChanged: (v) => showValue = v!,
                  ),

                  const SizedBox(height: 20),
                  Text("Thumbnail Image", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: () async {
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setModalState(() {
                          currentImagePath = image.path;
                          isImageLocal = true;
                        });
                      }
                    },
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.teal.shade200, width: 2, style: BorderStyle.solid),
                      ),
                      child: currentImagePath == null || currentImagePath!.isEmpty
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.teal.shade100, shape: BoxShape.circle),
                            child: Icon(Icons.add_photo_alternate_rounded, size: 30, color: Colors.teal.shade700),
                          ),
                          const SizedBox(height: 10),
                          Text("Tap to upload image", style: TextStyle(color: Colors.teal.shade700, fontWeight: FontWeight.bold)),
                        ],
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: isImageLocal
                            ? Image.file(File(currentImagePath!), fit: BoxFit.cover, width: double.infinity)
                            : Image.network(currentImagePath!, fit: BoxFit.cover, width: double.infinity),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          final newData = {
                            "id": existingData?['id'] ?? DateFormat('dd-MMM-yyyy HH:mm').format(DateTime.now()),
                            "title": titleCtrl.text,
                            "show": showValue,
                            "description": descCtrl.text,
                            "image": currentImagePath ?? "",
                            "isLocal": isImageLocal.toString(),
                          };
                          if (index == null) {
                            AnnouncementPage.announcements.insert(0, newData);
                          } else {
                            AnnouncementPage.announcements[index] = newData;
                          }
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Announcement saved successfully!"),
                              backgroundColor: Colors.teal.shade600,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            )
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                        shadowColor: Colors.teal.withOpacity(0.4),
                      ),
                      child: const Text("Save Announcement", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalInputField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            prefixIcon: maxLines == 1 ? Icon(icon, color: Colors.teal.shade400, size: 20) : null,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.teal.shade300, width: 1.5)),
          ),
        ),
      ],
    );
  }
}