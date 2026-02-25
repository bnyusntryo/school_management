import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StaffProfilePage extends StatefulWidget {
  final Map<String, String> staffData;

  const StaffProfilePage({super.key, required this.staffData});

  @override
  State<StaffProfilePage> createState() => _StaffProfilePageState();
}

class _StaffProfilePageState extends State<StaffProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _userIdCtrl;
  late TextEditingController _staffNameCtrl;
  late TextEditingController _bornDateCtrl;
  late TextEditingController _bornPlaceCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _positionCtrl;
  late TextEditingController _joinDateCtrl;

  String _selectedGender = 'Select Option';

  @override
  void initState() {
    super.initState();
    _userIdCtrl = TextEditingController(text: widget.staffData['id']);
    _staffNameCtrl = TextEditingController(text: widget.staffData['name']);
    _positionCtrl = TextEditingController(text: widget.staffData['position']);

    _bornDateCtrl = TextEditingController(text: widget.staffData['born_date'] ?? '04/01/2000');
    _bornPlaceCtrl = TextEditingController(text: widget.staffData['born_place'] ?? 'Jakarta');
    _selectedGender = widget.staffData['gender'] ?? 'Female';
    _emailCtrl = TextEditingController(text: widget.staffData['email'] ?? '${widget.staffData['id']}@mail.com');
    _addressCtrl = TextEditingController(text: widget.staffData['address'] ?? 'Jakarta');
    _phoneCtrl = TextEditingController(text: widget.staffData['phone'] ?? '08123456789');
    _joinDateCtrl = TextEditingController(text: widget.staffData['join_date'] ?? '01 Jan 2021');
  }

  @override
  void dispose() {
    _userIdCtrl.dispose();
    _staffNameCtrl.dispose();
    _bornDateCtrl.dispose();
    _bornPlaceCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _positionCtrl.dispose();
    _joinDateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  colors: [Colors.indigo.shade400, Colors.blueGrey.shade700],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Staff Information Detail",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.indigo.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5)),
                      ],
                      border: Border.all(color: Colors.indigo.shade50, width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.indigo.shade100, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.indigo.shade50,
                            child: Icon(Icons.assignment_ind_rounded, size: 35, color: Colors.indigo.shade400),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _buildSummaryItem("User ID", widget.staffData['id']!)),
                                  Expanded(child: _buildSummaryItem("Staff Name", widget.staffData['name']!)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _buildSummaryItem("Position", widget.staffData['position']!)),
                                  Expanded(child: _buildSummaryItem("Join Date", _joinDateCtrl.text)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.contact_mail_rounded, color: Colors.indigo.shade400, size: 22),
                              const SizedBox(width: 10),
                              const Text(
                                "Personal Information",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Divider(height: 1),
                          ),

                          _buildLabel("Userid *"),
                          _buildTextField(_userIdCtrl, Icons.badge_outlined, "Enter User ID", isReadOnly: true),

                          _buildLabel("Full Name *"),
                          _buildTextField(_staffNameCtrl, Icons.person_outline, "Enter Full Name"),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel("Born Date *"),
                                    _buildDateField(context, _bornDateCtrl, "Select Date"),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel("Born Place *"),
                                    _buildTextField(_bornPlaceCtrl, Icons.location_on_outlined, "City"),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          _buildLabel("Gender *"),
                          _buildGenderDropdown(),

                          _buildLabel("Email *"),
                          _buildTextField(_emailCtrl, Icons.email_outlined, "example@mail.com", keyboardType: TextInputType.emailAddress),

                          _buildLabel("Address *"),
                          _buildTextField(_addressCtrl, Icons.home_work_outlined, "Street name, City...", maxLines: 3),

                          _buildLabel("Phone Number *"),
                          _buildTextField(_phoneCtrl, Icons.phone_android_rounded, "0812...", keyboardType: TextInputType.phone),

                          _buildLabel("Position Name *"),
                          _buildTextField(_positionCtrl, Icons.work_outline_rounded, "e.g. Tata Usaha"),

                          _buildLabel("Join Date"),
                          _buildDateField(context, _joinDateCtrl, "Select Join Date"),

                          const SizedBox(height: 30),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, {
                                      'action': 'delete',
                                      'id': widget.staffData['id']
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE53E3E),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  ),
                                  child: const Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      Map<String, String> updatedStaff = {
                                        "id": _userIdCtrl.text,
                                        "name": _staffNameCtrl.text,
                                        "position": _positionCtrl.text,
                                        "born_date": _bornDateCtrl.text,
                                        "born_place": _bornPlaceCtrl.text,
                                        "gender": _selectedGender,
                                        "email": _emailCtrl.text,
                                        "address": _addressCtrl.text,
                                        "phone": _phoneCtrl.text,
                                        "join_date": _joinDateCtrl.text,
                                      };

                                      Navigator.pop(context, {
                                        'action': 'update',
                                        'data': updatedStaff
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo.shade600,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    elevation: 4,
                                    shadowColor: Colors.indigo.withOpacity(0.4),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  ),
                                  child: const Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildSummaryItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hint, {int maxLines = 1, TextInputType keyboardType = TextInputType.text, bool isReadOnly = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: isReadOnly ? Colors.grey.shade700 : Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: isReadOnly ? Colors.grey.shade400 : Colors.indigo.shade300, size: 20),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.normal),
          filled: true,
          fillColor: isReadOnly ? Colors.grey.shade200 : Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          focusedBorder: isReadOnly
              ? OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
              : OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.indigo.shade300, width: 1.5)),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, TextEditingController controller, String hint) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(2100),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Colors.indigo.shade600)),
            child: child!,
          ),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
          });
        }
      },
      child: IgnorePointer(
        child: _buildTextField(controller, Icons.calendar_today_rounded, hint),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.indigo.shade300),
          items: <String>['Select Option', 'Male', 'Female'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: value == 'Select Option' ? Colors.grey.shade400 : Colors.black87, fontSize: 14, fontWeight: FontWeight.w600)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedGender = newValue!;
            });
          },
        ),
      ),
    );
  }
}