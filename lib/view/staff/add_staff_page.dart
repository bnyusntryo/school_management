import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddStaffPage extends StatefulWidget {
  const AddStaffPage({super.key});

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  final _formKey = GlobalKey<FormState>();

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

  Future<void> _selectDate(BuildContext context, bool isBornDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3B82F6),
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
        if (isBornDate) {
          _bornDate = picked;
        } else {
          _joinDate = picked;
        }
      });
    }
  }

  InputDecoration _luminousInputDecoration(String label, {bool isRequired = false}) {
    return InputDecoration(
      labelText: isRequired ? '$label *' : label,
      labelStyle: TextStyle(
        color: isRequired ? Colors.redAccent : const Color(0xFF64748B),
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_bornDate == null || _selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Born Date dan Gender wajib diisi!'), backgroundColor: Colors.redAccent),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form valid! Siap dikirim ke server...'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Add New Staff',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E293B).withOpacity(0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _useridCtrl,
                    decoration: _luminousInputDecoration('User ID', isRequired: true),
                    validator: (val) => val!.isEmpty ? 'User ID wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _nameCtrl,
                    decoration: _luminousInputDecoration('Staff Name', isRequired: true),
                    validator: (val) => val!.isEmpty ? 'Staff Name wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  InkWell(
                    onTap: () => _selectDate(context, true),
                    child: IgnorePointer(
                      child: TextFormField(
                        decoration: _luminousInputDecoration('Born Date', isRequired: true).copyWith(
                          suffixIcon: const Icon(Icons.calendar_today_rounded, color: Color(0xFF94A3B8)),
                        ),
                        controller: TextEditingController(
                          text: _bornDate != null ? DateFormat('yyyy-MM-dd').format(_bornDate!) : '',
                        ),
                        validator: (val) => _bornDate == null ? 'Born Date wajib dipilih' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _bornPlaceCtrl,
                    decoration: _luminousInputDecoration('Born Place', isRequired: true),
                    validator: (val) => val!.isEmpty ? 'Born Place wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    decoration: _luminousInputDecoration('Gender', isRequired: true),
                    value: _selectedGender,
                    items: ['Male', 'Female'].map((String val) {
                      return DropdownMenuItem(value: val, child: Text(val));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedGender = val),
                    validator: (val) => val == null ? 'Gender wajib dipilih' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _luminousInputDecoration('Email'),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _addressCtrl,
                    maxLines: 3,
                    decoration: _luminousInputDecoration('Address', isRequired: true),
                    validator: (val) => val!.isEmpty ? 'Address wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: _luminousInputDecoration('Phone Number', isRequired: true),
                    validator: (val) => val!.isEmpty ? 'Phone Number wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _positionCtrl,
                    decoration: _luminousInputDecoration('Position Name', isRequired: true),
                    validator: (val) => val!.isEmpty ? 'Position wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  InkWell(
                    onTap: () => _selectDate(context, false),
                    child: IgnorePointer(
                      child: TextFormField(
                        decoration: _luminousInputDecoration('Join Date').copyWith(
                          suffixIcon: const Icon(Icons.calendar_today_rounded, color: Color(0xFF94A3B8)),
                        ),
                        controller: TextEditingController(
                          text: _joinDate != null ? DateFormat('yyyy-MM-dd').format(_joinDate!) : '',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}