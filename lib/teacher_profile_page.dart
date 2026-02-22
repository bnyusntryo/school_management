import 'package:flutter/material.dart';

class TeacherProfilePage extends StatefulWidget {
  final Map<String, String> teacherData;

  const TeacherProfilePage({super.key, required this.teacherData});

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _nipController;
  late TextEditingController _subjectController;
  late TextEditingController _classController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.teacherData['name']);
    _nipController = TextEditingController(text: widget.teacherData['nip']);
    _subjectController = TextEditingController(text: widget.teacherData['subject']);
    _classController = TextEditingController(text: widget.teacherData['class']);
    _emailController = TextEditingController(text: 'teacher@school.com');
    _phoneController = TextEditingController(text: '081234567890');
    _addressController = TextEditingController(text: 'Jl. Pendidikan No. 123, Jakarta');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nipController.dispose();
    _subjectController.dispose();
    _classController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text("Teacher Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- TOP PROFILE CARD ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F5), // Light Pink for Teacher
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.pinkAccent.withOpacity(0.2), width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(widget.teacherData['image']!),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: -40,
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_note, size: 18, color: Colors.pinkAccent),
                          label: const Text("Edit", style: TextStyle(color: Colors.pinkAccent, fontSize: 12)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.teacherData['name']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                  ),
                  Text(
                    "NIP: ${widget.teacherData['nip']}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderInfo("Subject", widget.teacherData['subject']!),
                      _buildHeaderInfo("Main Class", widget.teacherData['class']!),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- TEACHER DETAILS FORM ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Professional Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_note, size: 18, color: Colors.pinkAccent),
                        label: const Text("Edit", style: TextStyle(color: Colors.pinkAccent, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildInputField("Full Name", _nameController),
                  _buildInputField("NIP", _nipController),
                  _buildInputField("Expertise", _subjectController),
                  _buildInputField("Email", _emailController),
                  _buildInputField("Phone", _phoneController),
                  _buildInputField("Address", _addressController, isMultiline: true),
                  
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53E3E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text("Remove", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC2185B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pinkAccent.withOpacity(0.1)),
              ),
              child: TextField(
                controller: controller,
                maxLines: isMultiline ? 3 : 1,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
