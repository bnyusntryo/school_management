import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/pref.dart';

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

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.studentData['name']);
    _nisController = TextEditingController(text: widget.studentData['nis']);

    _bornDateController = TextEditingController();
    _bornPlaceController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _schoolOriginController = TextEditingController();

    _fetchCompleteProfile();
  }

  Future<void> _fetchCompleteProfile() async {
    try {
      String? token = await Session().getUserToken();
      String nis = widget.studentData['nis']?.trim() ?? '';

      String exactPayload = jsonEncode({"student_userid": nis});

      print("🕵️‍♂️ [SADAP] Mengirim payload ke server: $exactPayload");

      var personalRequest = http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/student/student-info/personal',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: exactPayload,
      );

      var detailRequest = http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/student/student-info/detail',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: exactPayload,
      );

      var responses = await Future.wait([personalRequest, detailRequest]);
      var personalRes = responses[0];
      var detailRes = responses[1];

      print(
        "🕵️‍♂️ [SADAP PERSONAL] Status: ${personalRes.statusCode} | Body: ${personalRes.body}",
      );
      print(
        "🕵️‍♂️ [SADAP DETAIL] Status: ${detailRes.statusCode} | Body: ${detailRes.body}",
      );

      if (mounted) {
        setState(() {
          if (personalRes.statusCode == 200) {
            var decodedPersonal = jsonDecode(personalRes.body);

            if (decodedPersonal['data'] != null) {
              var personalData = decodedPersonal['data'];

              String rawDate = personalData['born_date']?.toString() ?? '';
              _bornDateController.text = rawDate.isNotEmpty
                  ? rawDate.split('T')[0]
                  : '';

              _bornPlaceController.text =
                  personalData['born_place']?.toString() ?? '';

              String email = personalData['email']?.toString() ?? '';
              _emailController.text = (email == '0' || email.isEmpty)
                  ? 'Belum ada email'
                  : email;

              _addressController.text =
                  personalData['address']?.toString() ?? '';
              _phoneController.text =
                  personalData['phone_no']?.toString() ?? '';
              _schoolOriginController.text =
                  personalData['schoolorigin_code']?.toString() ?? '';

              String gender = personalData['gender']?.toString() ?? '';
              if (gender == 'L') {
                _selectedGender = 'Male';
              } else if (gender == 'P') {
                _selectedGender = 'Female';
              }
            }
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      print("🚨 Error Dual Fetch: $e");
      if (mounted) setState(() => _isLoading = false);
    }
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
    String photoUrl = widget.studentData['photo'] ?? '';
    if (photoUrl.isEmpty)
      photoUrl = 'https://i.pravatar.cc/150?u=${widget.studentData['nis']}';

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
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.orange.shade400,
                          Colors.deepOrange.shade700,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(photoUrl),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          widget.studentData['name']!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "NIS: ${widget.studentData['nis']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
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
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    ),
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildAcademicInfo(
                                Icons.bookmark_added_rounded,
                                "Kelas",
                                widget.studentData['kelas'] ?? "-",
                                Colors.blue,
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey.shade200,
                              ),
                              _buildAcademicInfo(
                                Icons.school_rounded,
                                "Jurusan",
                                widget.studentData['jurusan'] ?? "-",
                                Colors.deepOrange,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.contact_mail_rounded,
                                        color: Colors.orange.shade500,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "Personal Info",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2D3142),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit_note_rounded,
                                          size: 14,
                                          color: Colors.blue.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Edit",
                                          style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Divider(height: 1),
                              ),

                              _buildInputField(
                                "NIS",
                                _nisController,
                                Icons.badge_rounded,
                              ),
                              _buildInputField(
                                "Full Name",
                                _nameController,
                                Icons.person_rounded,
                              ),
                              _buildInputField(
                                "Born Date",
                                _bornDateController,
                                Icons.cake_rounded,
                              ),
                              _buildInputField(
                                "Born Place",
                                _bornPlaceController,
                                Icons.location_city_rounded,
                              ),
                              _buildGenderDropdown(),
                              _buildInputField(
                                "Email",
                                _emailController,
                                Icons.email_rounded,
                              ),
                              _buildInputField(
                                "Address",
                                _addressController,
                                Icons.home_rounded,
                                isMultiline: true,
                              ),
                              _buildInputField(
                                "Phone",
                                _phoneController,
                                Icons.phone_android_rounded,
                              ),
                              _buildInputField(
                                "School Origin",
                                _schoolOriginController,
                                Icons.account_balance_rounded,
                              ),

                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFE57373,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange.shade600,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        elevation: 4,
                                        shadowColor: Colors.orange.withOpacity(
                                          0.4,
                                        ),
                                      ),
                                      child: const Text(
                                        "Submit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

  Widget _buildAcademicInfo(
    IconData icon,
    String label,
    String value,
    MaterialColor color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color.shade500, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: isMultiline ? 3 : 1,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: !isMultiline
                  ? Icon(icon, color: Colors.orange.shade300, size: 20)
                  : null,
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.orange.shade400,
                  width: 1.5,
                ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.orange.shade400,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.wc_rounded,
                color: Colors.orange.shade300,
                size: 20,
              ),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.orange.shade400,
                  width: 1.5,
                ),
              ),
            ),
            items: ['Select', 'Male', 'Female'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
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
