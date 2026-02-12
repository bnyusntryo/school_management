import 'package:flutter/material.dart';

class StudentProfilePage extends StatefulWidget {
  final Map<String, String> studentData;

  const StudentProfilePage({super.key, required this.studentData});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _nisController;
  late TextEditingController _bornDateController;
  late TextEditingController _bornPlaceController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _schoolOriginController;
  String _selectedGender = 'Select';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.studentData['name']);
    _nisController = TextEditingController(text: widget.studentData['nis']);
    _bornDateController = TextEditingController(text: '20/01/2008');
    _bornPlaceController = TextEditingController(text: 'Tangerang');
    _emailController = TextEditingController();
    _addressController = TextEditingController(text: 'Gang Haji Fulan RT 02 RW 09');
    _phoneController = TextEditingController(text: '08212134532');
    _schoolOriginController = TextEditingController(text: 'SMPN 7 Jakarta');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nisController.dispose();
    _bornDateController.dispose();
    _bornPlaceController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _schoolOriginController.dispose();
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
        title: const Text("Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                color: const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://i.pravatar.cc/150?u=${widget.studentData['nis']}',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: -40,
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_note, size: 18, color: Colors.blue),
                          label: const Text("Edit", style: TextStyle(color: Colors.blue, fontSize: 12)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.studentData['name']!,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                  ),
                  Text(
                    "NIS ${widget.studentData['nis']}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderInfo("Kelas", widget.studentData['kelas']!),
                      _buildHeaderInfo("Jurusan", widget.studentData['jurusan']!),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- PERSONAL INFORMATION FORM ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FF),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Personal Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_note, size: 18, color: Colors.blue),
                        label: const Text("Edit", style: TextStyle(color: Colors.blue, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildInputField("NIS", _nisController),
                  _buildInputField("Full Name", _nameController),
                  _buildInputField("Born/date", _bornDateController),
                  _buildInputField("Born Place", _bornPlaceController),
                  _buildGenderDropdown(),
                  _buildInputField("Email", _emailController),
                  _buildInputField("Address", _addressController, isMultiline: true),
                  _buildInputField("Phone", _phoneController),
                  _buildInputField("School Origin", _schoolOriginController),
                  
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
                          child: const Text("Delete", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A67D8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text("Submit", style: TextStyle(fontWeight: FontWeight.bold)),
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
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
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
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
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

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          const SizedBox(
            width: 100,
            child: Text("Gender", style: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedGender,
                  items: ['Select', 'Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
