import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'user_session.dart';

class RecordAttendancePage extends StatelessWidget {
  const RecordAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentRole = UserSession.currentRole;

    if (currentRole == 'Student') {
      return const StudentAttendanceView();
    } else {
      return const AdminAttendanceView();
    }
  }
}

// ============================================================================
// 1. TAMPILAN ADMIN (KEPALA SEKOLAH / GURU)
// ============================================================================
class AdminAttendanceView extends StatefulWidget {
  const AdminAttendanceView({super.key});

  @override
  State<AdminAttendanceView> createState() => _AdminAttendanceViewState();
}

class _AdminAttendanceViewState extends State<AdminAttendanceView> {
  final TextEditingController _searchCtrl = TextEditingController();

  final Color attGradientStart = const Color(0xFF4A90E2);
  final Color attGradientEnd = const Color(0xFFF06292);
  final Color textDark = const Color(0xFF1E293B);

  final List<Map<String, String>> _allAttendances = [
    {"name": "Savannah Nguyen", "date": "24 October 2023", "schIn": "08:00:00", "schOut": "17:00:00", "actIn": "07:45:00", "actOut": "17:15:00", "status": "On Time"},
    {"name": "Banyu Bintang", "date": "24 October 2023", "schIn": "08:00:00", "schOut": "17:00:00", "actIn": "07:50:00", "actOut": "17:00:00", "status": "On Time"},
    {"name": "Jerome Bell", "date": "24 October 2023", "schIn": "08:00:00", "schOut": "17:00:00", "actIn": "08:15:00", "actOut": "17:05:00", "status": "Late"},
    {"name": "Eleanor Pena", "date": "24 October 2023", "schIn": "08:00:00", "schOut": "17:00:00", "actIn": "07:55:00", "actOut": "17:10:00", "status": "On Time"},
  ];

  List<Map<String, String>> _filteredAttendances = [];

  @override
  void initState() {
    super.initState();
    _filteredAttendances = _allAttendances;
  }

  void _filterData(String query) {
    setState(() {
      _filteredAttendances = _allAttendances.where((data) =>
      data['name']!.toLowerCase().contains(query.toLowerCase()) ||
          data['date']!.toLowerCase().contains(query.toLowerCase())
      ).toList();
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
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Attendance",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Text("Oct 01 - Oct 24, 2023", style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Hello, ${UserSession.currentRole} ${UserSession.currentUserName.split(' ').first}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [attGradientStart, attGradientEnd]),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: attGradientEnd.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]
              ),
              child: Stack(
                children: [
                  Positioned(top: -20, right: -10, child: Icon(Icons.stacked_bar_chart_rounded, color: Colors.white.withOpacity(0.1), size: 100)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("School-wide Attendance", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("88%", style: TextStyle(fontSize: 45, fontWeight: FontWeight.w900, color: Colors.white, height: 1.0)),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: const [
                                Icon(Icons.arrow_upward_rounded, color: Colors.greenAccent, size: 16),
                                Text("+2.4%", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 65, height: 65, alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 55, height: 55,
                                  child: CircularProgressIndicator(value: 0.88, strokeWidth: 6, backgroundColor: Colors.white.withOpacity(0.2), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white)),
                                ),
                                const Icon(Icons.school_rounded, color: Colors.white, size: 28),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem("PRESENT", "850", Colors.white, Colors.white.withOpacity(0.7)),
                          _buildStatItem("ABSENT", "45", Colors.white, Colors.white.withOpacity(0.7)),
                          _buildStatItem("LATE", "12", Colors.yellowAccent, Colors.white.withOpacity(0.7)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          children: [
                            Expanded(flex: 85, child: Container(height: 6, color: Colors.white)),
                            Expanded(flex: 5, child: Container(height: 6, color: Colors.yellowAccent)),
                            Expanded(flex: 10, child: Container(height: 6, color: Colors.white.withOpacity(0.3))),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))], border: Border.all(color: Colors.grey.shade200)),
              child: TextField(
                  controller: _searchCtrl, onChanged: _filterData,
                  decoration: InputDecoration(icon: Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 22), hintText: "Search name or date...", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13), border: InputBorder.none)
              ),
            ),
            const SizedBox(height: 25),
            Text("Attendance History", style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            const SizedBox(height: 15),

            _filteredAttendances.isEmpty
                ? Padding(padding: const EdgeInsets.only(top: 50), child: Center(child: Column(children: [Icon(Icons.event_busy_rounded, size: 80, color: Colors.grey.shade300), const SizedBox(height: 15), Text("No records found", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold))])) )
                : ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: _filteredAttendances.length, itemBuilder: (context, index) { return _buildDynamicAttendanceCard(_filteredAttendances[index]); }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String count, Color countColor, Color titleColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: titleColor, letterSpacing: 0.5)), const SizedBox(height: 5), Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: countColor))],
    );
  }

  Widget _buildDynamicAttendanceCard(Map<String, String> data) {
    bool isLate = data['status'] == 'Late';
    Color statusColor = isLate ? Colors.orange.shade700 : Colors.green.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [attGradientStart, attGradientEnd]), borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: attGradientEnd.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
      child: Stack(
        children: [
          Positioned(top: 10, right: 30, child: Icon(Icons.add, color: Colors.white.withOpacity(0.1), size: 24)),
          Positioned(bottom: 20, left: 20, child: Icon(Icons.add, color: Colors.white.withOpacity(0.1), size: 30)),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 24)), const SizedBox(width: 15),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data['name']!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 4), Row(children: [const Icon(Icons.calendar_month_rounded, color: Colors.white70, size: 12), const SizedBox(width: 4), Text(data['date']!, style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w600))])])),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)]), child: Text(data['status']!, style: TextStyle(color: statusColor, fontWeight: FontWeight.w900, fontSize: 11)))
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 6, right: 6, bottom: 6), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.login_rounded, color: Colors.green.shade500, size: 18), const SizedBox(width: 8), const Text("Attend IN", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87))]), const SizedBox(height: 12), Row(children: [SizedBox(width: 30, child: Text("Sch", style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w600))), Text(data['schIn']!, style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w600))]), const SizedBox(height: 6), Row(children: [SizedBox(width: 30, child: Text("Act", style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w600))), Text(data['actIn']!, style: TextStyle(fontSize: 14, color: isLate ? Colors.orange.shade700 : textDark, fontWeight: FontWeight.w900))])])),
                    Container(height: 50, width: 1, color: Colors.grey.shade200),
                    Expanded(child: Padding(padding: const EdgeInsets.only(left: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 18), const SizedBox(width: 8), const Text("Attend OUT", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87))]), const SizedBox(height: 12), Row(children: [SizedBox(width: 30, child: Text("Sch", style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w600))), Text(data['schOut']!, style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w600))]), const SizedBox(height: 6), Row(children: [SizedBox(width: 30, child: Text("Act", style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w600))), Text(data['actOut']!, style: TextStyle(fontSize: 14, color: textDark, fontWeight: FontWeight.w900))])])))
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 2. TAMPILAN MURID (STUDENT) - DESAIN BARU FIGMA + KARTU GRADIEN
// ============================================================================
class StudentAttendanceView extends StatefulWidget {
  const StudentAttendanceView({super.key});

  @override
  State<StudentAttendanceView> createState() => _StudentAttendanceViewState();
}

class _StudentAttendanceViewState extends State<StudentAttendanceView> with SingleTickerProviderStateMixin {
  int _currentView = 0; // 0 = Home, 1 = Map, 2 = Face Scan

  final TextEditingController _searchCtrl = TextEditingController();

  final List<Map<String, String>> _allAttendances = [
    {"name": "Yoga Pratama", "date": "18 January 2026", "schIn": "08:00:00", "schOut": "17:00:00", "actIn": "08:10:00", "actOut": "17:10:00", "status": "Late"},
    {"name": "Yoga Pratama", "date": "17 January 2026", "schIn": "08:00:00", "schOut": "17:00:00", "actIn": "07:55:00", "actOut": "17:05:00", "status": "On Time"},
  ];

  List<Map<String, String>> _filteredAttendances = [];

  final Color attGradientStart = const Color(0xFF4A90E2);
  final Color attGradientEnd = const Color(0xFFF06292);
  final Color textDark = const Color(0xFF1E293B);

  late AnimationController _scanController;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _filteredAttendances = _allAttendances;

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scanController.dispose();
    super.dispose();
  }

  void _filterData(String query) {
    setState(() {
      _filteredAttendances = _allAttendances.where((data) =>
      data['name']!.toLowerCase().contains(query.toLowerCase()) ||
          data['date']!.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  void _recordAttendanceNow() {
    String today = DateFormat('dd MMMM yyyy').format(DateTime.now());
    String timeNow = DateFormat('HH:mm:ss').format(DateTime.now());

    int existingIndex = _allAttendances.indexWhere((att) => att['date'] == today);

    setState(() {
      if (existingIndex == -1) {
        _allAttendances.insert(0, {
          "name": UserSession.currentUserName, "date": today, "schIn": "08:00:00", "schOut": "17:00:00",
          "actIn": timeNow, "actOut": "--:--:--", "status": "On Time"
        });
      } else {
        _allAttendances[existingIndex]['actOut'] = timeNow;
      }
      _filterData(_searchCtrl.text);
      _currentView = 0; // Kembali ke layar utama
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attendance Successfully Recorded!"), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating)
    );
  }

  void _startFaceRecognition() {
    setState(() {
      _currentView = 2;
      _isScanning = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isScanning = false);
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) _recordAttendanceNow();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: _buildCurrentView(),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case 0: return _buildMainScreen();
      case 1: return _buildMapValidationScreen();
      case 2: return _buildFaceRecognitionScreen();
      default: return _buildMainScreen();
    }
  }

  // LAYAR UTAMA MURID (Sesuai Desain Figma)
  Widget _buildMainScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FB),
        elevation: 0,
        centerTitle: true,
        title: const Text("Attendance", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER & LIVE UPDATES ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Text("Oct 01 - Oct 24, 2023", style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(15)),
                  child: Text("Live Updates", style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Hello, ${UserSession.currentRole} ${UserSession.currentUserName.split(' ').first}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 25),

            // --- SUMMARY CARD (Sama dengan Admin, dengan Angka Murid) ---
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [attGradientStart, attGradientEnd]),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: attGradientEnd.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]
              ),
              child: Stack(
                children: [
                  Positioned(top: -20, right: -10, child: Icon(Icons.stacked_bar_chart_rounded, color: Colors.white.withOpacity(0.1), size: 100)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("School-wide Attendance", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("88%", style: TextStyle(fontSize: 45, fontWeight: FontWeight.w900, color: Colors.white, height: 1.0)),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: const [
                                Icon(Icons.arrow_upward_rounded, color: Colors.greenAccent, size: 16),
                                Text("+2.4%", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 65, height: 65, alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 55, height: 55,
                                  child: CircularProgressIndicator(value: 0.88, strokeWidth: 6, backgroundColor: Colors.white.withOpacity(0.2), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white)),
                                ),
                                const Icon(Icons.school_rounded, color: Colors.white, size: 28),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem("PRESENT", "120", Colors.white, Colors.white.withOpacity(0.7)),
                          _buildStatItem("ABSENT", "12", Colors.white, Colors.white.withOpacity(0.7)),
                          _buildStatItem("LATE", "4", Colors.yellowAccent, Colors.white.withOpacity(0.7)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          children: [
                            Expanded(flex: 85, child: Container(height: 6, color: Colors.white)),
                            Expanded(flex: 5, child: Container(height: 6, color: Colors.yellowAccent)),
                            Expanded(flex: 10, child: Container(height: 6, color: Colors.white.withOpacity(0.3))),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- TOMBOL TAP IN & TAP OUT ---
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                      colors: [const Color(0xFFFF8A65), const Color(0xFFF4511E)],
                      title: "Tap In", time: "07:00", buttonText: "Check In",
                      imagePath: 'assets/images/tap_in_illustration.png',
                      onTap: () => setState(() => _currentView = 1) // ✅ Pindah ke Layar Map Validation
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildActionCard(
                      colors: [const Color(0xFF9FA8DA), const Color(0xFF5E35B1)],
                      title: "Tap Out", time: "16:00", buttonText: "Check In",
                      imagePath: 'assets/images/tap_out_illustration.png',
                      onTap: () => setState(() => _currentView = 1) // ✅ Pindah ke Layar Map Validation
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // --- SEARCH BAR & HISTORY ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))], border: Border.all(color: Colors.grey.shade200)),
              child: TextField(
                  controller: _searchCtrl, onChanged: _filterData,
                  decoration: InputDecoration(icon: Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 22), hintText: "Search name or date...", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13), border: InputBorder.none)
              ),
            ),
            const SizedBox(height: 20),

            _filteredAttendances.isEmpty
                ? Padding(padding: const EdgeInsets.only(top: 30), child: Center(child: Column(children: [Icon(Icons.event_busy_rounded, size: 80, color: Colors.grey.shade300), const SizedBox(height: 15), Text("No records found", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold))])) )
                : ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: _filteredAttendances.length, itemBuilder: (context, index) { return _buildDynamicAttendanceCard(_filteredAttendances[index]); }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Komponen Reusable untuk Kartu Tap In / Tap Out
  Widget _buildActionCard({required List<Color> colors, required String title, required String time, required String buttonText, required String imagePath, VoidCallback? onTap}) {
    return Container(
      height: 105,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
              bottom: 0, right: 0,
              child: ClipRRect(borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)), child: Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const SizedBox.shrink()))
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 2),
                Text(time, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                const Spacer(),
                Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                            width: 80, height: 28,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.2))),
                            child: Center(child: Text(buttonText, style: const TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold)))
                        )
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String count, Color countColor, Color titleColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: titleColor, letterSpacing: 0.5)), const SizedBox(height: 5), Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: countColor))],
    );
  }

  Widget _buildDynamicAttendanceCard(Map<String, String> data) {
    bool isLate = data['status'] == 'Late';
    Color statusColor = isLate ? Colors.orange.shade700 : Colors.green.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [attGradientStart, attGradientEnd]), borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: attGradientEnd.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
      child: Stack(
        children: [
          Positioned(top: 10, right: 30, child: Icon(Icons.add, color: Colors.white.withOpacity(0.1), size: 24)),
          Positioned(bottom: 20, left: 20, child: Icon(Icons.add, color: Colors.white.withOpacity(0.1), size: 30)),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 24)), const SizedBox(width: 15),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data['name']!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 4), Row(children: [const Icon(Icons.calendar_month_rounded, color: Colors.white70, size: 12), const SizedBox(width: 4), Text(data['date']!, style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w600))])])),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)]), child: Text(data['status']!, style: TextStyle(color: statusColor, fontWeight: FontWeight.w900, fontSize: 11)))
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 6, right: 6, bottom: 6), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.login_rounded, color: Colors.green.shade500, size: 18), const SizedBox(width: 8), const Text("Attend IN", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87))]), const SizedBox(height: 12), Row(children: [SizedBox(width: 30, child: Text("Sch", style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w600))), Text(data['schIn']!, style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w600))]), const SizedBox(height: 6), Row(children: [SizedBox(width: 30, child: Text("Act", style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w600))), Text(data['actIn']!, style: TextStyle(fontSize: 14, color: isLate ? Colors.orange.shade700 : textDark, fontWeight: FontWeight.w900))])])),
                    Container(height: 50, width: 1, color: Colors.grey.shade200),
                    Expanded(child: Padding(padding: const EdgeInsets.only(left: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 18), const SizedBox(width: 8), const Text("Attend OUT", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87))]), const SizedBox(height: 12), Row(children: [SizedBox(width: 30, child: Text("Sch", style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w600))), Text(data['schOut']!, style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w600))]), const SizedBox(height: 6), Row(children: [SizedBox(width: 30, child: Text("Act", style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w600))), Text(data['actOut']!, style: TextStyle(fontSize: 14, color: textDark, fontWeight: FontWeight.w900))])])))
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // --- MAP VALIDATION & FACE SCAN (Sama dengan sebelumnya) ---
  Widget _buildMapValidationScreen() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network("https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=1000", fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: const Color(0xFFE3EEFE).withOpacity(0.8)),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: attGradientStart.withOpacity(0.2), shape: BoxShape.circle), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: attGradientStart.withOpacity(0.4), shape: BoxShape.circle), child: Icon(Icons.location_on, color: attGradientEnd, size: 45))),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Positioned(
          top: 50, left: 20, right: 20,
          child: Row(
            children: [
              InkWell(onTap: () => setState(() => _currentView = 0), child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]), child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20))),
              const SizedBox(width: 15),
              Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]), child: const Text("Map Validation", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87)))
            ],
          ),
        ),
        Positioned(
          bottom: 30, left: 20, right: 20,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: attGradientStart.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle), child: Icon(Icons.check_circle_rounded, color: Colors.green.shade500, size: 20)), const SizedBox(width: 15), const Text("Location Verified", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green))]),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1)),
                Text("Current Address", style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("SMK Islamiyah, Jalan Springs Boulevard, South Tangerang, Banten, Indonesia", style: TextStyle(fontSize: 15, color: textDark, fontWeight: FontWeight.w800, height: 1.4)),
                const SizedBox(height: 25),
                InkWell(
                  onTap: _startFaceRecognition,
                  child: Container(
                    width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [attGradientStart, attGradientEnd]), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: attGradientEnd.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))]),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.face_retouching_natural_rounded, color: Colors.white, size: 20), SizedBox(width: 10), Text("Face Recognition", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)), SizedBox(width: 5), Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18)]),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFaceRecognitionScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: Image.network("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=800", fit: BoxFit.cover, colorBlendMode: BlendMode.darken, color: Colors.black.withOpacity(0.4))),
          Positioned.fill(child: CustomPaint(painter: FaceScannerOverlayPainter())),
          if (_isScanning)
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                return Positioned(
                  top: MediaQuery.of(context).size.height * 0.25 + (_scanController.value * (MediaQuery.of(context).size.height * 0.4)),
                  left: 40, right: 40,
                  child: Container(height: 3, decoration: BoxDecoration(color: attGradientEnd, boxShadow: [BoxShadow(color: attGradientEnd, blurRadius: 15, spreadRadius: 2)])),
                );
              },
            ),
          Positioned(
            top: 60, left: 0, right: 0,
            child: Column(children: [const Text("Face Recognition", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1)), const SizedBox(height: 8), Text(_isScanning ? "Scanning your face..." : "Match Confirmed!", style: TextStyle(color: _isScanning ? Colors.white70 : Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold))]),
          ),
          if (!_isScanning) Center(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.green.withOpacity(0.9), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 30, spreadRadius: 10)]), child: const Icon(Icons.check_rounded, color: Colors.white, size: 60))),
          Positioned(
            bottom: 40, left: 0, right: 0,
            child: Center(child: InkWell(onTap: () => setState(() => _currentView = 1), child: Container(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white54)), child: const Text("Cancel Scanning", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))),
          )
        ],
      ),
    );
  }
}

class FaceScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.65);
    final rectWidth = size.width * 0.75;
    final rectHeight = size.height * 0.45;
    final rectLeft = (size.width - rectWidth) / 2;
    final rectTop = (size.height - rectHeight) / 2.5;

    final cutoutRect = RRect.fromLTRBAndCorners(rectLeft, rectTop, rectLeft + rectWidth, rectTop + rectHeight, topLeft: const Radius.circular(40), topRight: const Radius.circular(40), bottomLeft: const Radius.circular(40), bottomRight: const Radius.circular(40));

    canvas.drawPath(Path.combine(PathOperation.difference, Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)), Path()..addRRect(cutoutRect)), backgroundPaint);

    final borderPaint = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 4.0;
    double cl = 30.0;

    canvas.drawPath(Path()..moveTo(rectLeft, rectTop + cl)..lineTo(rectLeft, rectTop)..lineTo(rectLeft + cl, rectTop), borderPaint);
    canvas.drawPath(Path()..moveTo(rectLeft + rectWidth - cl, rectTop)..lineTo(rectLeft + rectWidth, rectTop)..lineTo(rectLeft + rectWidth, rectTop + cl), borderPaint);
    canvas.drawPath(Path()..moveTo(rectLeft, rectTop + rectHeight - cl)..lineTo(rectLeft, rectTop + rectHeight)..lineTo(rectLeft + cl, rectTop + rectHeight), borderPaint);
    canvas.drawPath(Path()..moveTo(rectLeft + rectWidth - cl, rectTop + rectHeight)..lineTo(rectLeft + rectWidth, rectTop + rectHeight)..lineTo(rectLeft + rectWidth, rectTop + rectHeight - cl), borderPaint);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}