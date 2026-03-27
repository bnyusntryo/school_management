import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/staff_detail.dart';
import '../../viewmodel/staff_viewmodel.dart';

class StaffDetailPage extends StatefulWidget {
  final String userId;

  const StaffDetailPage({super.key, required this.userId});

  @override
  State<StaffDetailPage> createState() => _StaffDetailPageState();
}

class _StaffDetailPageState extends State<StaffDetailPage> {
  final _viewModel = StaffViewModel();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  String? _errorMessage;
  StaffDetailModel? _staffDetail;

  final _useridCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _bornPlaceCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _positionCtrl = TextEditingController();

  String? _selectedGender;
  DateTime? _bornDate;
  DateTime? _joinDate;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  @override
  void dispose() {
    _useridCtrl.dispose();
    _nameCtrl.dispose();
    _bornPlaceCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _positionCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchDetail() async {
    setState(() => _isLoading = true);
    try {
      final resp = await _viewModel.getStaffDetail(widget.userId);
      if (!mounted) return;

      if (resp.data != null) {
        final data = StaffDetailModel.fromJson(resp.data);
        setState(() {
          _staffDetail = data;
          _populateForm(data);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = resp.message ?? 'Gagal memuat detail';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Terjadi kesalahan jaringan';
        _isLoading = false;
      });
    }
  }

  void _populateForm(StaffDetailModel data) {
    _useridCtrl.text = data.userid;
    _nameCtrl.text = data.fullName;
    _bornPlaceCtrl.text = data.birthPlace;
    _emailCtrl.text = data.email;
    _addressCtrl.text = data.address;
    _phoneCtrl.text = data.phoneNo;
    _positionCtrl.text = data.posName;

    if (data.gender.toUpperCase() == 'M') _selectedGender = 'Male';
    if (data.gender.toUpperCase() == 'F') _selectedGender = 'Female';

    try {
      if (data.birthDate.isNotEmpty) _bornDate = DateTime.parse(data.birthDate);
      if (data.joinDate.isNotEmpty) _joinDate = DateTime.parse(data.joinDate);
    } catch (e) {
      debugPrint("Error parsing date: $e");
    }
  }

  Future<void> _selectDate(BuildContext context, bool isBornDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isBornDate ? (_bornDate ?? DateTime.now()) : (_joinDate ?? DateTime.now()),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isBornDate) _bornDate = picked;
        else _joinDate = picked;
      });
    }
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '??';
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) return words[0].substring(0, words[0].length >= 2 ? 2 : 1).toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  InputDecoration _premiumInput(String label, IconData icon, {bool isReadOnly = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isReadOnly ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(icon, color: isReadOnly ? const Color(0xFFCBD5E1) : const Color(0xFF3B82F6), size: 22),
      filled: true,
      fillColor: isReadOnly ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: isReadOnly ? Colors.transparent : const Color(0xFFE2E8F0), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
            'Staff Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 0.5)
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
          : Stack(
        children: [
          Container(
            height: 350,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF6366F1), Color(0xFF4F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 40 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 4),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                                _getInitials(_staffDetail!.fullName),
                                style: const TextStyle(color: Color(0xFF4F46E5), fontSize: 36, fontWeight: FontWeight.w900)
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _staffDetail!.fullName,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                                _staffDetail!.posName,
                                style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 0.5)
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.badge_outlined, color: Colors.white70, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'ID: ${_staffDetail!.userid}',
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '•',
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                              ),
                              const SizedBox(width: 16),
                              const Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                'Joined: ${_joinDate != null ? DateFormat('dd MMM yyyy').format(_joinDate!) : '-'}',
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 30, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.badge_rounded, color: Color(0xFF0F172A), size: 24),
                                SizedBox(width: 10),
                                Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                              ],
                            ),
                            const SizedBox(height: 24),

                            TextFormField(
                              controller: _useridCtrl,
                              readOnly: true,
                              style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                              decoration: _premiumInput('User ID (Read Only)', Icons.tag_rounded, isReadOnly: true),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(controller: _nameCtrl, decoration: _premiumInput('Staff Name', Icons.person_outline_rounded)),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(child: TextFormField(controller: _bornPlaceCtrl, decoration: _premiumInput('Born Place', Icons.location_city_rounded))),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _selectDate(context, true),
                                    child: IgnorePointer(
                                      child: TextFormField(
                                        decoration: _premiumInput('Born Date', Icons.cake_rounded),
                                        controller: TextEditingController(text: _bornDate != null ? DateFormat('yyyy-MM-dd').format(_bornDate!) : ''),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            DropdownButtonFormField<String>(
                              decoration: _premiumInput('Gender', Icons.wc_rounded),
                              value: _selectedGender,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF3B82F6)),
                              items: ['Male', 'Female'].map((String val) => DropdownMenuItem(value: val, child: Text(val, style: const TextStyle(fontWeight: FontWeight.w600)))).toList(),
                              onChanged: (val) => setState(() => _selectedGender = val),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(controller: _emailCtrl, decoration: _premiumInput('Email Address', Icons.alternate_email_rounded)),
                            const SizedBox(height: 16),
                            TextFormField(controller: _phoneCtrl, decoration: _premiumInput('Phone Number', Icons.phone_in_talk_rounded)),
                            const SizedBox(height: 16),
                            TextFormField(controller: _addressCtrl, maxLines: 2, decoration: _premiumInput('Home Address', Icons.home_work_outlined)),
                            const SizedBox(height: 16),
                            TextFormField(controller: _positionCtrl, decoration: _premiumInput('Position Name', Icons.work_outline_rounded)),

                            const SizedBox(height: 32),

                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFEF2F2),
                                      foregroundColor: const Color(0xFFEF4444),
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF6366F1)]),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(vertical: 18),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                      child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}