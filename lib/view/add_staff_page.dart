import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddStaffPage extends StatefulWidget {
  const AddStaffPage({super.key});

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  final _formKey = GlobalKey<FormState>();

  final _userIdCtrl = TextEditingController();
  final _staffNameCtrl = TextEditingController();
  final _bornDateCtrl = TextEditingController();
  final _bornPlaceCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _positionCtrl = TextEditingController();
  final _joinDateCtrl = TextEditingController();

  String _selectedGender = 'Select Option';

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
                  "Add New Staff",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
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
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(color: Colors.indigo.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_add_rounded, color: Colors.indigo.shade400),
                          const SizedBox(width: 10),
                          const Text(
                            "Personal Information",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(),
                      ),

                      _buildLabel("User ID *"),
                      _buildTextField(_userIdCtrl, Icons.badge_outlined, "Enter User ID"),

                      _buildLabel("Staff Name *"),
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

                      _buildLabel("Email"),
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
                                if (_userIdCtrl.text.isNotEmpty &&
                                    _staffNameCtrl.text.isNotEmpty &&
                                    _positionCtrl.text.isNotEmpty) {

                                  Map<String, String> newStaff = {
                                    "id": _userIdCtrl.text,
                                    "name": _staffNameCtrl.text,
                                    "position": _positionCtrl.text,
                                  };

                                  Navigator.pop(context, newStaff);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Staff Added Successfully!"),
                                        backgroundColor: Colors.green
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Please fill all required fields (*)"),
                                        backgroundColor: Colors.red
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo.shade600,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                elevation: 0,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hint, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.indigo.shade300, size: 20),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.indigo.shade200, width: 1.5)),
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
            controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
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
              child: Text(value, style: TextStyle(color: value == 'Select Option' ? Colors.grey.shade400 : Colors.black87, fontSize: 14)),
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