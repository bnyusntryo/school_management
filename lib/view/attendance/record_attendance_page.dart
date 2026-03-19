import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_management/view/auth/auth_provider.dart';

import '../../config/pref.dart';

class RecordAttendancePage extends StatelessWidget {
  const RecordAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);
    String currentRole = authData.role;

    if (currentRole == 'Student') {
      return const StudentAttendanceView();
    } else {
      return const AdminAttendanceView();
    }
  }
}

class AdminAttendanceView extends StatefulWidget {
  const AdminAttendanceView({super.key});

  @override
  State<AdminAttendanceView> createState() => _AdminAttendanceViewState();
}

class _AdminAttendanceViewState extends State<AdminAttendanceView>
    with TickerProviderStateMixin {
  int _currentView = 0;
  final TextEditingController _searchCtrl = TextEditingController();

  final Color attGradientStart = const Color(0xFF4A90E2);
  final Color attGradientEnd = const Color(0xFFF06292);
  final Color textDark = const Color(0xFF1E293B);

  List<Map<String, String>> _allAttendances = [];
  List<Map<String, String>> _filteredAttendances = [];

  bool _isLoading = true;

  String _targetLocationName = "Fetching location from server...";
  String _targetLat = "";
  String _targetLng = "";
  String _attendanceLimit = "0";

  int _presentCount = 0;
  int _lateCount = 0;
  int _absentCount = 0;
  double _attendancePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceList();
  }

  Future<void> _fetchAttendanceList() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      String? token = await Session().getUserToken();
      var req = await http.get(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/attendance/myattendance-list',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        if (res['data'] != null && mounted) {
          List dataList = res['data'];
          int tempPresent = 0, tempLate = 0, tempAbsent = 0;

          setState(() {
            _allAttendances = dataList.map((item) {
              String schIn = item['sch_attend_in']?.toString() ?? "00:00:00";
              String actIn = item['act_attend_in']?.toString() ?? "";
              String statusServer = item['attend_status']?.toString() ?? "";

              String finalStatus = "On Time";
              if (statusServer.isNotEmpty) {
                finalStatus = statusServer;
              } else if (actIn.isNotEmpty && actIn != "null" && actIn != "-") {
                if (actIn.compareTo(schIn) > 0) finalStatus = "Late";
              }

              if (finalStatus == "On Time")
                tempPresent++;
              else if (finalStatus == "Late")
                tempLate++;
              else
                tempAbsent++;

              return {
                "name": item['full_name']?.toString() ?? "Unknown",
                "date": item['attendance_date']?.toString() ?? "-",
                "schIn": schIn,
                "schOut": item['sch_attend_out']?.toString() ?? "--:--:--",
                "actIn": actIn.isEmpty || actIn == "null" ? "--:--:--" : actIn,
                "actOut": item['act_attend_out']?.toString() ?? "--:--:--",
                "status": finalStatus,
              };
            }).toList();

            _filteredAttendances = _allAttendances;
            _presentCount = tempPresent;
            _lateCount = tempLate;
            _absentCount = tempAbsent;
            int total = _allAttendances.length;
            if (total > 0) {
              _attendancePercentage = (_presentCount + _lateCount) / total;
            } else {
              _attendancePercentage = 0.0;
            }
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aktifkan GPS / Lokasi Anda terlebih dahulu'),
        ),
      );
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Izin lokasi ditolak')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Izin lokasi ditolak permanen. Buka pengaturan HP.'),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _startChangeBasePhotoFlow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.blue)),
    );
    try {
      String? token = await Session().getUserToken();
      var refreshReq = http.get(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/attendance/refresh-token',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      var listReq = _fetchAttendanceList();
      await Future.wait([refreshReq, listReq]);
      var refreshRes = await refreshReq;

      if (!mounted) return;
      Navigator.pop(context);

      if (refreshRes.statusCode == 200 || refreshRes.statusCode != 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangeBasePhotoPage()),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Network error."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchTargetLocation() async {
    try {
      String? token = await Session().getUserToken();
      var req = await http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/attendance/get-location',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({}),
      );
      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        if (res['data'] != null && res['data'].isNotEmpty) {
          var locData = res['data'][0];
          if (mounted) {
            setState(() {
              _targetLocationName =
                  locData['location_name'] ?? "Unknown Location";
              _targetLat = locData['latitude']?.toString() ?? "";
              _targetLng = locData['longitude']?.toString() ?? "";
            });
          }
        }
      }
    } catch (e) {}
  }

  Future<void> _checkLimitAndRequestCamera() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.blue)),
    );
    try {
      String? token = await Session().getUserToken();

      var req = await http.get(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/attendance/today-attendance-limit',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (!mounted) return;
      Navigator.pop(context);

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        _attendanceLimit = res['data']?.toString() ?? "0";
      } else {
        _attendanceLimit = "0 (API Error)";
      }

      final captured = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceCameraPage(limit: _attendanceLimit),
        ),
      );

      if (captured == true) {
        _fetchAttendanceList();
        setState(() => _currentView = 0);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error menyambung ke server limit."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterData(String query) {
    setState(() {
      _filteredAttendances = _allAttendances
          .where(
            (data) =>
                data['name']!.toLowerCase().contains(query.toLowerCase()) ||
                data['date']!.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: _buildCurrentView(),
      floatingActionButton: _currentView == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                final hasPermission = await _handleLocationPermission();
                if (!hasPermission) return;
                _fetchTargetLocation();
                setState(() => _currentView = 1);
              },
              backgroundColor: Colors.blue.shade700,
              icon: const Icon(Icons.fingerprint_rounded, color: Colors.white),
              label: const Text(
                "Record Attendance",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevation: 4,
            )
          : null,
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case 0:
        return _buildMainScreen();
      case 1:
        return _buildMapValidationScreen();
      default:
        return _buildMainScreen();
    }
  }

  Widget _buildMainScreen() {
    final authData = Provider.of<AuthProvider>(context);
    int pFlex = _presentCount > 0 ? _presentCount : 1,
        lFlex = _lateCount > 0 ? _lateCount : 1,
        aFlex = _absentCount > 0 ? _absentCount : 1;
    if (_allAttendances.isEmpty) {
      pFlex = 85;
      lFlex = 5;
      aFlex = 10;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Attendance",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 15.0,
            ),
            child: OutlinedButton.icon(
              onPressed: _startChangeBasePhotoFlow,
              icon: const Icon(
                Icons.cameraswitch_rounded,
                color: Color(0xFF1E293B),
                size: 14,
              ),
              label: const Text(
                "Change Base Photo",
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1E293B)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy').format(DateTime.now()),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Hello, ${authData.role} ${authData.userName.split(' ').first}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [attGradientStart, attGradientEnd],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: attGradientEnd.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -20,
                    right: -10,
                    child: Icon(
                      Icons.stacked_bar_chart_rounded,
                      color: Colors.white.withOpacity(0.1),
                      size: 100,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Attendance Progress",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${(_attendancePercentage * 100).toInt()}%",
                            style: const TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Colors.greenAccent,
                                  size: 16,
                                ),
                                Text(
                                  "Live",
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 65,
                            height: 65,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 55,
                                  height: 55,
                                  child: CircularProgressIndicator(
                                    value: _attendancePercentage,
                                    strokeWidth: 6,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.2,
                                    ),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                  ),
                                ),
                                const Icon(
                                  Icons.school_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem(
                            "ON TIME",
                            "$_presentCount",
                            Colors.white,
                            Colors.white.withOpacity(0.7),
                          ),
                          _buildStatItem(
                            "LATE",
                            "$_lateCount",
                            Colors.yellowAccent,
                            Colors.white.withOpacity(0.7),
                          ),
                          _buildStatItem(
                            "ABSENT",
                            "$_absentCount",
                            Colors.white,
                            Colors.white.withOpacity(0.7),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: pFlex,
                              child: Container(height: 6, color: Colors.white),
                            ),
                            Expanded(
                              flex: lFlex,
                              child: Container(
                                height: 6,
                                color: Colors.yellowAccent,
                              ),
                            ),
                            Expanded(
                              flex: aFlex,
                              child: Container(
                                height: 6,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _filterData,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade500,
                    size: 22,
                  ),
                  hintText: "Search name or date...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "Attendance History",
              style: TextStyle(
                color: textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 15),

            _isLoading
                ? const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                  )
                : _filteredAttendances.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_busy_rounded,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "No records found",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredAttendances.length,
                    itemBuilder: (context, index) {
                      return _buildDynamicAttendanceCard(
                        _filteredAttendances[index],
                      );
                    },
                  ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildMapValidationScreen() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            "https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=1000",
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.srcOver,
            color: const Color(0xFFE3EEFE).withOpacity(0.8),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: attGradientStart.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: attGradientStart.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: attGradientEnd,
                    size: 45,
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: Row(
            children: [
              InkWell(
                onTap: () => setState(() => _currentView = 0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black87,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Text(
                  "Map Validation",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: attGradientStart.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green.shade500,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Location Verified",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(height: 1),
                ),
                Text(
                  "Current Address",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "SMK Islamiyah, Jalan Springs Boulevard, South Tangerang, Banten, Indonesia",
                  style: TextStyle(
                    fontSize: 15,
                    color: textDark,
                    fontWeight: FontWeight.w800,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 25),
                InkWell(
                  onTap: _checkLimitAndRequestCamera,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [attGradientStart, attGradientEnd],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: attGradientEnd.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.face_retouching_natural_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Face Recognition",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
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
    );
  }

  Widget _buildStatItem(
    String title,
    String count,
    Color countColor,
    Color titleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: titleColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: countColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicAttendanceCard(Map<String, String> data) {
    bool isLate = data['status'] == 'Late';
    Color statusColor = isLate ? Colors.orange.shade700 : Colors.green.shade700;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [attGradientStart, attGradientEnd],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: attGradientEnd.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 30,
            child: Icon(
              Icons.add,
              color: Colors.white.withOpacity(0.1),
              size: 24,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Icon(
              Icons.add,
              color: Colors.white.withOpacity(0.1),
              size: 30,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.white70,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                data['date']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        data['status']!,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.login_rounded,
                                color: Colors.green.shade500,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Attend IN",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                                child: Text(
                                  "Sch",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                data['schIn']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                                child: Text(
                                  "Act",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                data['actIn']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isLate
                                      ? Colors.orange.shade700
                                      : textDark,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.grey.shade200,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout_rounded,
                                  color: Colors.red.shade400,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Attend OUT",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    "Sch",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  data['schOut']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    "Act",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  data['actOut']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textDark,
                                    fontWeight: FontWeight.w900,
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
            ],
          ),
        ],
      ),
    );
  }
}

class StudentAttendanceView extends StatefulWidget {
  const StudentAttendanceView({super.key});
  @override
  State<StudentAttendanceView> createState() => _StudentAttendanceViewState();
}

class _StudentAttendanceViewState extends State<StudentAttendanceView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Student View")));
  }
}

class FaceScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.7);
    final centerX = size.width / 2;
    final centerY = size.height * 0.45;
    final radius = size.width * 0.35;
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addOval(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        ),
      ),
      backgroundPaint,
    );
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(centerX, centerY), radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ChangeBasePhotoPage extends StatefulWidget {
  const ChangeBasePhotoPage({super.key});

  @override
  State<ChangeBasePhotoPage> createState() => _ChangeBasePhotoPageState();
}

class _ChangeBasePhotoPageState extends State<ChangeBasePhotoPage> {
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  String? _currentServerPhotoUrl =
      "https://sms-recognition.s3.us-east-1.amazonaws.com/dummy_kepsek";

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Change Base Photo",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.shade300,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Current Photo",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Builder(
                      builder: (context) {
                        if (_selectedImage != null) {
                          return Image.file(
                            File(_selectedImage!.path),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          );
                        }
                        if (_currentServerPhotoUrl != null &&
                            _currentServerPhotoUrl!.isNotEmpty) {
                          return Image.network(
                            _currentServerPhotoUrl!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                width: 150,
                                height: 150,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 150,
                                  height: 150,
                                  color: Colors.grey.shade200,
                                  child: Icon(
                                    Icons.broken_image_rounded,
                                    color: Colors.grey.shade400,
                                    size: 50,
                                  ),
                                ),
                          );
                        }
                        return Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.grey.shade400,
                            size: 80,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  InkWell(
                    onTap: _pickImage,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: const Text(
                            "Browse...",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedImage != null
                                ? _selectedImage!.name
                                : "No file selected.",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            if (_selectedImage != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Base Photo Updated Successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cloud_upload_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Save & Upload Photo",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AttendanceCameraPage extends StatefulWidget {
  final String limit;
  const AttendanceCameraPage({super.key, required this.limit});

  @override
  State<AttendanceCameraPage> createState() => _AttendanceCameraPageState();
}

class _AttendanceCameraPageState extends State<AttendanceCameraPage>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  late AnimationController _scanController;
  bool _isScanning = false;
  bool _cameraError = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _cameraError = true);
        return;
      }
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      print("🚨 Kamera Absen gagal: $e");
      setState(() => _cameraError = true);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _scanController.dispose();
    super.dispose();
  }

  void _processCapturePhoto() {
    setState(() => _isScanning = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _cameraError
                ? const Center(
                    child: Text(
                      "Kamera Tidak Tersedia di Perangkat Ini",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : _cameraController != null &&
                      _cameraController!.value.isInitialized
                ? CameraPreview(_cameraController!)
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
          ),
          Positioned.fill(
            child: CustomPaint(painter: FaceScannerOverlayPainter()),
          ),

          Positioned(
            top: 50,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context, false),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 80,
            right: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Attendance Check",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Limit : ${widget.limit}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isScanning)
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                return Positioned(
                  top:
                      MediaQuery.of(context).size.height * 0.25 +
                      (_scanController.value *
                          (MediaQuery.of(context).size.height * 0.4)),
                  left: 40,
                  right: 40,
                  child: Container(
                    height: 3,
                    decoration: const BoxDecoration(
                      color: Colors.pinkAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent,
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _isScanning ? null : _processCapturePhoto,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: _isScanning
                          ? const CircularProgressIndicator(color: Colors.grey)
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
