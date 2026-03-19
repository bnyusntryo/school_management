import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:school_management/view/auth/auth_provider.dart';
import '../../config/pref.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedUserType;

  bool _isLoadingUsers = false;
  List<dynamic> _availableUsers = [];
  List<dynamic> _selectedUsers = [];

  Set<String> _highlightedAvailable = {};
  Set<String> _highlightedSelected = {};

  // Tema Warna Gradient khas Faryandra Tech
  final Color attGradientStart = const Color(0xFF4A90E2);
  final Color attGradientEnd = const Color(0xFFF06292);

  // =========================================================
  // ⚙️ MESIN API: PENARIK DATA USER
  // =========================================================
  Future<void> _fetchUsers(String userType) async {
    setState(() {
      _isLoadingUsers = true;
      _availableUsers.clear();
      _selectedUsers.clear();
      _highlightedAvailable.clear();
      _highlightedSelected.clear();
    });

    try {
      String? token = await Session().getUserToken();
      String payloadStatus = userType.toUpperCase();

      var req = await http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/attendance/reports/get-user',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"user_status": payloadStatus}),
      );

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        if (res['data'] != null && mounted) {
          setState(() {
            _availableUsers = (res['data'] as List)
                .where((u) => u['full_name'] != "")
                .toList();
            _isLoadingUsers = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingUsers = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingUsers = false);
    }
  }

  // =========================================================
  // ⚙️ LOGIKA TRANSFER LIST
  // =========================================================
  void _moveHighlightedToSelected() {
    setState(() {
      var toMove = _availableUsers
          .where((u) => _highlightedAvailable.contains(u['userid']))
          .toList();
      _selectedUsers.addAll(toMove);
      _availableUsers.removeWhere(
        (u) => _highlightedAvailable.contains(u['userid']),
      );
      _highlightedAvailable.clear();
    });
  }

  void _moveAllToSelected() {
    setState(() {
      _selectedUsers.addAll(_availableUsers);
      _availableUsers.clear();
      _highlightedAvailable.clear();
    });
  }

  void _moveHighlightedToAvailable() {
    setState(() {
      var toMove = _selectedUsers
          .where((u) => _highlightedSelected.contains(u['userid']))
          .toList();
      _availableUsers.addAll(toMove);
      _selectedUsers.removeWhere(
        (u) => _highlightedSelected.contains(u['userid']),
      );
      _highlightedSelected.clear();
    });
  }

  void _moveAllToAvailable() {
    setState(() {
      _availableUsers.addAll(_selectedUsers);
      _selectedUsers.clear();
      _highlightedSelected.clear();
    });
  }

  // =========================================================
  // ⚙️ PEMILIH TANGGAL
  // =========================================================
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade800,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        if (isStart)
          _startDate = picked;
        else
          _endDate = picked;
      });
    }
  }

  // =========================================================
  // 🚀 MESIN API: SUBMIT REPORT
  // =========================================================
  Future<void> _submitReport() async {
    if (_startDate == null ||
        _endDate == null ||
        _selectedUserType == null ||
        _selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and select at least 1 user!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.blue)),
    );

    try {
      String? token = await Session().getUserToken();
      String startStr = DateFormat('yyyy-MM-dd').format(_startDate!);
      String endStr = DateFormat('yyyy-MM-dd').format(_endDate!);
      List<Map<String, String>> formattedUsers = _selectedUsers
          .map((u) => {"userid": u['userid'].toString()})
          .toList();

      var payload = {
        "start_date": startStr,
        "end_date": endStr,
        "userid": formattedUsers,
      };

      var req = await http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/attendance/reports/attendance-list',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (!mounted) return;
      Navigator.pop(context);

      List<dynamic> reportData = [];

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        if (res['error'] != null || res['data'] == null) {
          reportData = [];
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No data found for selected period & users."),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          reportData = res['data'];
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewReportPage(reportData: reportData),
        ),
      );
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  // =========================================================
  // 🎨 PEMBANGUN UI UTAMA (REMASTERED MODERN UI)
  // =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black87,
                size: 16,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "Generate Report",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select parameters to generate attendance report.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: _buildModernDateField(
                      "Start Date",
                      _startDate,
                      () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildModernDateField(
                      "End Date",
                      _endDate,
                      () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildModernDropdown(),
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Target Users",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  if (_selectedUsers.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${_selectedUsers.length} Selected",
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),

              _isLoadingUsers
                  ? Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : SizedBox(
                      height: 280,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: _buildModernListBox(
                              "Available",
                              _availableUsers,
                              _highlightedAvailable,
                              (id) {
                                setState(() {
                                  if (_highlightedAvailable.contains(id))
                                    _highlightedAvailable.remove(id);
                                  else
                                    _highlightedAvailable.add(id);
                                });
                              },
                              false,
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildCircularTransferBtn(
                                  Icons.keyboard_arrow_right_rounded,
                                  _moveHighlightedToSelected,
                                ),
                                _buildCircularTransferBtn(
                                  Icons.keyboard_double_arrow_right_rounded,
                                  _moveAllToSelected,
                                ),
                                const SizedBox(height: 15),
                                _buildCircularTransferBtn(
                                  Icons.keyboard_arrow_left_rounded,
                                  _moveHighlightedToAvailable,
                                ),
                                _buildCircularTransferBtn(
                                  Icons.keyboard_double_arrow_left_rounded,
                                  _moveAllToAvailable,
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: 5,
                            child: _buildModernListBox(
                              "Selected",
                              _selectedUsers,
                              _highlightedSelected,
                              (id) {
                                setState(() {
                                  if (_highlightedSelected.contains(id))
                                    _highlightedSelected.remove(id);
                                  else
                                    _highlightedSelected.add(id);
                                });
                              },
                              true,
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [attGradientStart, attGradientEnd],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: attGradientEnd.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _submitReport,
                    icon: const Icon(
                      Icons.analytics_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      "Generate Report",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // 🧩 KOMPONEN WIDGET KECIL (MODERN)
  // =========================================================

  Widget _buildModernDateField(
    String label,
    DateTime? value,
    VoidCallback onTap,
  ) {
    return Column(
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
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value != null
                      ? DateFormat('dd MMM yy').format(value)
                      : "Select",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: value != null
                        ? Colors.black87
                        : Colors.grey.shade400,
                  ),
                ),
                Icon(
                  Icons.calendar_month_rounded,
                  size: 18,
                  color: attGradientStart,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Target Role",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedUserType,
            hint: Text(
              "Select Student or Teacher",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey.shade400,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              border: InputBorder.none,
            ),
            items: ["Student", "Teacher"].map((String val) {
              return DropdownMenuItem(
                value: val,
                child: Row(
                  children: [
                    Icon(
                      val == "Student"
                          ? Icons.school_rounded
                          : Icons.work_rounded,
                      size: 16,
                      color: attGradientEnd,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      val,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              setState(() => _selectedUserType = val);
              if (val != null) _fetchUsers(val);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCircularTransferBtn(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: attGradientStart),
          ),
        ),
      ),
    );
  }

  Widget _buildModernListBox(
    String title,
    List<dynamic> users,
    Set<String> highlightedSet,
    Function(String) onTap,
    bool isSelectedBox,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isSelectedBox
              ? attGradientEnd.withOpacity(0.3)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelectedBox
                  ? attGradientEnd.withOpacity(0.05)
                  : Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: isSelectedBox ? attGradientEnd : Colors.black87,
                  ),
                ),
                Text(
                  "${users.length} items",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: users.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelectedBox
                              ? Icons.check_circle_outline_rounded
                              : Icons.search_off_rounded,
                          color: Colors.grey.shade300,
                          size: 30,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Empty",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 8,
                    ),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var u = users[index];
                      bool isHighlighted = highlightedSet.contains(u['userid']);

                      String initial = u['full_name'].toString().isNotEmpty
                          ? u['full_name'].toString()[0].toUpperCase()
                          : "?";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: isHighlighted
                              ? attGradientStart.withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isHighlighted
                                ? attGradientStart.withOpacity(0.5)
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => onTap(u['userid']),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: isHighlighted
                                        ? attGradientStart
                                        : Colors.grey.shade200,
                                    child: Text(
                                      initial,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isHighlighted
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      u['full_name'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isHighlighted
                                            ? attGradientStart
                                            : Colors.black87,
                                        fontWeight: isHighlighted
                                            ? FontWeight.bold
                                            : FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ==============================================================================
// 🚀 HALAMAN PREVIEW REPORTS
// ==============================================================================
class PreviewReportPage extends StatelessWidget {
  final List<dynamic> reportData;

  const PreviewReportPage({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context, listen: false);
    String currentDate = DateFormat(
      'M/d/yyyy, h:mm:ss a',
    ).format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF005696),
        elevation: 0,
        title: const Text(
          "Preview Reports",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("Report Name", "Attendance List Report"),
                _buildInfoRow("Reported Date", currentDate),
                _buildInfoRow("Reported By", authData.userName),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Fitur Download Excel akan segera hadir!",
                              ),
                            ),
                          ),
                      icon: const Icon(
                        Icons.insert_drive_file_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: const Text(
                        "Download Excel",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2EBD59),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Fitur Download PDF akan segera hadir!",
                              ),
                            ),
                          ),
                      icon: const Icon(
                        Icons.picture_as_pdf_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: const Text(
                        "Download PDF",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE54D4D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: reportData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "No Data Found",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Tidak ada absensi untuk user dan tanggal terpilih.",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              const Color(0xFF2A3671),
                            ),
                            headingTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            dataTextStyle: const TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                            columns: const [
                              DataColumn(label: Text("#")),
                              DataColumn(label: Text("Attendance ID")),
                              DataColumn(label: Text("Date")),
                              DataColumn(label: Text("Full Name")),
                              DataColumn(label: Text("Schedule Attendance In")),
                              DataColumn(
                                label: Text("Schedule Attendance Out"),
                              ),
                              DataColumn(label: Text("Actual Attendance In")),
                              DataColumn(label: Text("Actual Attendance Out")),
                              DataColumn(label: Text("Attendance Status")),
                            ],
                            rows: List.generate(reportData.length, (index) {
                              var data = reportData[index];
                              return DataRow(
                                cells: [
                                  DataCell(Text((index + 1).toString())),
                                  DataCell(
                                    Text(
                                      data['attendance_id']?.toString() ?? "-",
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      data['attendance_date']?.toString() ??
                                          "-",
                                    ),
                                  ),
                                  DataCell(
                                    Text(data['full_name']?.toString() ?? "-"),
                                  ),
                                  DataCell(
                                    Text(
                                      data['sch_attend_in']?.toString() ?? "-",
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      data['sch_attend_out']?.toString() ?? "-",
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      data['act_attend_in']?.toString() ?? "-",
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      data['act_attend_out']?.toString() ?? "-",
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      data['attend_status']?.toString() ?? "-",
                                      style: TextStyle(
                                        color: data['attend_status'] == 'Late'
                                            ? Colors.red
                                            : Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          const Text(
            ":",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
