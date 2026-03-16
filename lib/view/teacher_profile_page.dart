import 'package:flutter/material.dart';
import '../config/pref.dart';
import '../model/teacher_info_model.dart';
import '../model/teacher_personal_model.dart';
import '../viewmodel/teacher_viewmodel.dart';

class TeacherProfilePage extends StatefulWidget {
  final TeacherInfoModel teacherData; // ✅ Pakai TeacherModel, bukan Map

  const TeacherProfilePage({super.key, required this.teacherData});

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  final _viewmodel = TeacherViewmodel(); // ✅ ARCH-1: pakai ViewModel

  // ✅ Controllers
  late TextEditingController _nameController;
  late TextEditingController _nipController;
  late TextEditingController _nuptkController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _bornPlaceController;
  late TextEditingController _bornDateController;
  late TextEditingController _joinDateController;

  String _selectedGender = 'Select';
  String _activeStatus = 'Unknown';

  bool _isLoading = true;
  TeacherPersonalModel? _personalData; // ✅ Simpan personal data

  @override
  void initState() {
    super.initState();

    // ✅ Initialize semua controller dengan data dari TeacherModel
    _nameController = TextEditingController(text: widget.teacherData.fullName);
    _nipController = TextEditingController(text: widget.teacherData.userid);
    _nuptkController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _bornPlaceController = TextEditingController();
    _bornDateController = TextEditingController();
    _joinDateController = TextEditingController(text: widget.teacherData.joinDate);

    _fetchCompleteProfile();
  }

  // ✅ Fetch profile dengan ViewModel - ARCH-1 compliant
  Future<void> _fetchCompleteProfile() async {
    setState(() => _isLoading = true);

    try {
      // ✅ Panggil ViewModel, bukan HTTP langsung
      final resp = await _viewmodel.getTeacherPersonal(
        teacherUserid: widget.teacherData.userid,
      );

      if (!mounted) return; // ✅ WAJIB mounted check - FLUTTER-1

      if (resp.code == 200 && resp.data != null) {
        final personalData = TeacherPersonalModel.fromJson(resp.data);

        setState(() {
          _personalData = personalData;

          // ✅ Populate controllers dengan data dari model
          _nuptkController.text = personalData.displayNuptk;
          _bornPlaceController.text = personalData.bornPlace;
          _bornDateController.text = personalData.bornDate;
          _emailController.text = personalData.displayEmail;
          _addressController.text = personalData.address;
          _phoneController.text = personalData.phoneNo;
          _joinDateController.text = personalData.joinDate;
          _activeStatus = personalData.displayActiveStatus;
          _selectedGender = personalData.displayGender;

          _isLoading = false;
        });
      } else {
        debugPrint("🚨 API Error: ${resp.message ?? 'Unknown error'}");
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("🚨 Error fetch teacher profile: $e"); // ✅ debugPrint - DART-3
      if (mounted) {
        setState(() => _isLoading = false);
        // ✅ Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load teacher profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // ✅ WAJIB dispose semua controller - FLUTTER-3
    _nameController.dispose();
    _nipController.dispose();
    _nuptkController.dispose();
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
    // ✅ Prefer avatar dari personalData jika sudah load
    String avatarUrl = _personalData?.avatarUrl ?? widget.teacherData.avatarUrl;

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
                  borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded,
                      color: Colors.white),
                  onPressed: () => Navigator.pop(context)),
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
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)),
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
                              color: Colors.white.withOpacity(0.3)),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(avatarUrl),
                            onBackgroundImageError: (_, __) {},
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          widget.teacherData.displayName,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 6),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "NIP: ${widget.teacherData.userid}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
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
                  child: CircularProgressIndicator(color: Colors.pink)),
            )
                : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ✅ Professional Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.pink.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 5))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildProfessionalInfo(
                            Icons.person_outline_rounded,
                            "Gender",
                            _selectedGender,
                            Colors.indigo),
                        Container(
                            height: 40,
                            width: 1,
                            color: Colors.grey.shade200),
                        _buildProfessionalInfo(
                            Icons.verified_rounded,
                            "Status",
                            _activeStatus,
                            Colors.green),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // ✅ Form Card
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 10))
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
                                Icon(Icons.assignment_ind_rounded,
                                    color: Colors.pink.shade500,
                                    size: 20),
                                const SizedBox(width: 10),
                                const Text("Professional Details",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2D3142))),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.pink.shade50,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Icon(Icons.edit_note_rounded,
                                      size: 14,
                                      color: Colors.pink.shade600),
                                  const SizedBox(width: 4),
                                  Text("Edit",
                                      style: TextStyle(
                                          color: Colors.pink.shade700,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Divider(height: 1)),

                        _buildInputField("Full Name", _nameController,
                            Icons.person_rounded),
                        _buildInputField(
                            "NIP", _nipController, Icons.badge_rounded),
                        _buildInputField("NUPTK", _nuptkController,
                            Icons.card_membership_rounded),
                        _buildGenderDropdown(),
                        _buildInputField("Born Place",
                            _bornPlaceController, Icons.location_city_rounded),
                        _buildInputField("Born Date",
                            _bornDateController, Icons.cake_rounded),
                        _buildInputField(
                            "Email", _emailController, Icons.email_rounded),
                        _buildInputField("Phone", _phoneController,
                            Icons.phone_android_rounded),
                        _buildInputField("Join Date",
                            _joinDateController, Icons.calendar_month_rounded),
                        _buildInputField(
                            "Address", _addressController, Icons.home_rounded,
                            isMultiline: true),

                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _handleDelete,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color(0xFFE57373),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15)),
                                    elevation: 0),
                                child: const Text("Delete",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _handleSave,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink.shade600,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15)),
                                    elevation: 4,
                                    shadowColor:
                                    Colors.pink.withOpacity(0.4)),
                                child: const Text("Save",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
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

  // ✅ Handle save dengan ViewModel
  Future<void> _handleSave() async {
    // TODO: Implement save functionality dengan _viewmodel.updateTeacherInfo()
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Save feature coming soon'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // ✅ Handle delete dengan ViewModel
  Future<void> _handleDelete() async {
    // ✅ Confirmation dialog dulu
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Teacher'),
        content: Text(
            'Are you sure you want to delete ${widget.teacherData.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // TODO: Implement delete dengan _viewmodel.deleteTeacher()
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delete feature coming soon'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Widget _buildProfessionalInfo(
      IconData icon, String label, String value, MaterialColor color) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            decoration:
            BoxDecoration(color: color.shade50, shape: BoxShape.circle),
            child: Icon(icon, color: color.shade500, size: 20)),
        const SizedBox(height: 8),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142))),
      ],
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, IconData icon,
      {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: isMultiline ? 3 : 1,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: !isMultiline
                  ? Icon(icon, color: Colors.pink.shade300, size: 20)
                  : null,
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: Colors.pink.shade400, width: 1.5)),
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
          Text("Gender",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            icon: Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.pink.shade400),
            decoration: InputDecoration(
              prefixIcon:
              Icon(Icons.wc_rounded, color: Colors.pink.shade300, size: 20),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: Colors.pink.shade400, width: 1.5)),
            ),
            items: ['Select', 'Male', 'Female'].map((String value) {
              return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)));
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