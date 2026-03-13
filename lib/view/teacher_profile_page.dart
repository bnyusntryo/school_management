import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/pref.dart';

class TeacherProfilePage extends StatefulWidget {
  final Map<String, String> teacherData;

  const TeacherProfilePage({super.key, required this.teacherData});

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _nipController;
  late TextEditingController _nuptkController;
  late TextEditingController _subjectController;
  late TextEditingController _classController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _bornPlaceController;
  late TextEditingController _bornDateController;
  late TextEditingController _joinDateController;

  String _selectedGender = 'Select';
  String _activeStatus = 'Unknown';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.teacherData['name']);
    _nipController = TextEditingController(text: widget.teacherData['nip']);
    _subjectController = TextEditingController(text: widget.teacherData['subject']);
    _classController = TextEditingController(text: widget.teacherData['class']);

    _nuptkController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _bornPlaceController = TextEditingController();
    _bornDateController = TextEditingController();
    _joinDateController = TextEditingController();

    _fetchCompleteProfile();
  }

  Future<void> _fetchCompleteProfile() async {
    try {
      String? token = await Session().getUserToken();
      String nip = widget.teacherData['nip']?.trim() ?? '';

      String exactPayload = jsonEncode({
        "teacher_userid": nip
      });

      var personalRequest = http.post(
        Uri.parse('https://schoolapp-api-dev.zeabur.app/api/teacher/teacher-info/personal'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: exactPayload,
      );

      var detailRequest = http.post(
        Uri.parse('https://schoolapp-api-dev.zeabur.app/api/teacher/teacher-info/detail'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: exactPayload,
      );

      var responses = await Future.wait([personalRequest, detailRequest]);
      var personalRes = responses[0];

      if (mounted) {
        setState(() {
          if (personalRes.statusCode == 200) {
            var decodedPersonal = jsonDecode(personalRes.body);
            if (decodedPersonal['data'] != null) {
              var personalData = decodedPersonal['data'];

              _nuptkController.text = personalData['nuptk']?.toString() ?? '-';
              _bornPlaceController.text = personalData['born_place']?.toString() ?? '';

              String rawBornDate = personalData['born_date']?.toString() ?? '';
              _bornDateController.text = rawBornDate.isNotEmpty ? rawBornDate.split('T')[0] : '';

              String email = personalData['email']?.toString() ?? '';
              _emailController.text = (email == '0' || email.isEmpty) ? 'Belum ada email' : email;

              _addressController.text = personalData['address']?.toString() ?? '';
              _phoneController.text = personalData['phone_no']?.toString() ?? '';

              String rawJoinDate = personalData['join_date']?.toString() ?? '';
              _joinDateController.text = rawJoinDate.isNotEmpty ? rawJoinDate.split('T')[0] : '';

              _activeStatus = personalData['active_status']?.toString() == 'Y' ? 'Active' : 'Inactive';

              String gender = personalData['gender']?.toString() ?? '';
              if (gender == 'L') _selectedGender = 'Male';
              else if (gender == 'P') _selectedGender = 'Female';
            }
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      print("🚨 Error Dual Fetch Teacher: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nipController.dispose();
    _nuptkController.dispose();
    _subjectController.dispose();
    _classController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bornPlaceController.dispose();
    _bornDateController.dispose();
    _joinDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String photoUrl = widget.teacherData['image'] ?? '';
    bool isValidUrl = photoUrl.isNotEmpty && photoUrl.startsWith('http');
    if (!isValidUrl) {
      photoUrl = 'https://i.pravatar.cc/150?u=${widget.teacherData['nip']}';
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.pink.shade400, Colors.pink.shade700],
                      ),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.3)),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(photoUrl),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          widget.teacherData['name']!,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "NIP: ${widget.teacherData['nip']}",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: _isLoading
                ? const Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: Center(child: CircularProgressIndicator(color: Colors.pink)),
            )
                : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 5))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildProfessionalInfo(Icons.menu_book_rounded, "Subject", widget.teacherData['subject'] ?? "-", Colors.indigo),
                        Container(height: 40, width: 1, color: Colors.grey.shade200),
                        _buildProfessionalInfo(Icons.verified_rounded, "Status", _activeStatus, Colors.green),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.assignment_ind_rounded, color: Colors.pink.shade500, size: 20),
                                const SizedBox(width: 10),
                                const Text("Professional Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Icon(Icons.edit_note_rounded, size: 14, color: Colors.pink.shade600),
                                  const SizedBox(width: 4),
                                  Text("Edit", style: TextStyle(color: Colors.pink.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1)),

                        _buildInputField("Full Name", _nameController, Icons.person_rounded),
                        _buildInputField("NIP", _nipController, Icons.badge_rounded),
                        _buildInputField("NUPTK", _nuptkController, Icons.card_membership_rounded),
                        _buildGenderDropdown(),
                        _buildInputField("Born Place", _bornPlaceController, Icons.location_city_rounded),
                        _buildInputField("Born Date", _bornDateController, Icons.cake_rounded),
                        _buildInputField("Email", _emailController, Icons.email_rounded),
                        _buildInputField("Phone", _phoneController, Icons.phone_android_rounded),
                        _buildInputField("Join Date", _joinDateController, Icons.calendar_month_rounded),
                        _buildInputField("Address", _addressController, Icons.home_rounded, isMultiline: true),

                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE57373),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    elevation: 0
                                ),
                                child: const Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink.shade600,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    elevation: 4,
                                    shadowColor: Colors.pink.withOpacity(0.4)
                                ),
                                child: const Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfo(IconData icon, String label, String value, MaterialColor color) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.shade50, shape: BoxShape.circle),
            child: Icon(icon, color: color.shade500, size: 20)
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: isMultiline ? 3 : 1,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: !isMultiline ? Icon(icon, color: Colors.pink.shade300, size: 20) : null,
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.pink.shade400, width: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gender", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.pink.shade400),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.wc_rounded, color: Colors.pink.shade300, size: 20),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.pink.shade400, width: 1.5)),
            ),
            items: ['Select', 'Male', 'Female'].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)));
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedGender = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }
}