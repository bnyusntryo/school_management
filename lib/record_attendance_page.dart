import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class RecordAttendancePage extends StatefulWidget {
  const RecordAttendancePage({super.key});

  @override
  State<RecordAttendancePage> createState() => _RecordAttendancePageState();
}

class _RecordAttendancePageState extends State<RecordAttendancePage> with SingleTickerProviderStateMixin {
  int _currentView = 0;

  final TextEditingController _searchCtrl = TextEditingController();

  final List<Map<String, String>> _allAttendances = [
    {"name": "Kristo William", "date": "18 January 2026", "schIn": "08:00:00", "schOut": "17:00:00", "actIn": "08:10:00", "actOut": "17:10:00", "status": "Late"},
    {"name": "Kristo William", "date": "17 January 2026", "schIn": "08:00:00", "schOut": "17:00:00", "actIn": "07:55:00", "actOut": "17:05:00", "status": "On Time"},
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
          "name": "Kristo William", "date": today, "schIn": "08:00:00", "schOut": "17:00:00",
          "actIn": timeNow, "actOut": "--:--:--", "status": "On Time"
        });
      } else {
        _allAttendances[existingIndex]['actOut'] = timeNow;
      }
      _filterData(_searchCtrl.text);
      _currentView = 0;
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
      case 0: return _buildHistoryScreen();
      case 1: return _buildMapValidationScreen();
      case 2: return _buildFaceRecognitionScreen();
      default: return _buildHistoryScreen();
    }
  }
  Widget _buildHistoryScreen() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 130, floating: false, pinned: true, backgroundColor: Colors.transparent, elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [attGradientStart, attGradientEnd]),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              boxShadow: [BoxShadow(color: attGradientEnd.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Stack(
              children: [
                Positioned(top: 20, left: 40, child: Icon(Icons.add, color: Colors.white.withOpacity(0.15), size: 30)),
                Positioned(bottom: 40, right: 80, child: Icon(Icons.add, color: Colors.white.withOpacity(0.15), size: 20)),
                Positioned(top: -20, right: -20, child: Container(width: 130, height: 130, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)))),
                const FlexibleSpaceBar(titlePadding: EdgeInsets.only(left: 60, bottom: 20), title: Text("Record Attendance", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white, letterSpacing: 0.5))),
              ],
            ),
          ),
          leading: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context))),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Camera..."))),
                    icon: Icon(Icons.face_retouching_natural_rounded, color: attGradientStart, size: 18),
                    label: Text("Base Photo", style: TextStyle(color: attGradientStart, fontWeight: FontWeight.bold, fontSize: 13)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 5, shadowColor: Colors.black.withOpacity(0.05)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [attGradientStart, attGradientEnd]), borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: attGradientEnd.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))]),
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _currentView = 1),
                      icon: const Icon(Icons.fingerprint_rounded, color: Colors.white, size: 18),
                      label: const Text("Record Attd", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))], border: Border.all(color: Colors.grey.shade200)),
                  child: TextField(controller: _searchCtrl, onChanged: _filterData, decoration: InputDecoration(icon: Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 22), hintText: "Search name or date...", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13), border: InputBorder.none)),
                ),
                const SizedBox(height: 20),
                Text("Attendance History", style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          sliver: _filteredAttendances.isEmpty
              ? SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.only(top: 50), child: Center(child: Column(children: [Icon(Icons.event_busy_rounded, size: 80, color: Colors.grey.shade300), const SizedBox(height: 15), Text("No records found", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold))]))))
              : SliverList(delegate: SliverChildBuilderDelegate((context, index) => _buildDynamicAttendanceCard(_filteredAttendances[index]), childCount: _filteredAttendances.length)),
        )
      ],
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
                  color: attGradientStart.withOpacity(0.2), shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: attGradientStart.withOpacity(0.4), shape: BoxShape.circle),
                  child: Icon(Icons.location_on, color: attGradientEnd, size: 45),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),

        Positioned(
          top: 50, left: 20, right: 20,
          child: Row(
            children: [
              InkWell(
                onTap: () => setState(() => _currentView = 0),
                child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]), child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20)),
              ),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
                child: const Text("Map Validation", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87)),
              )
            ],
          ),
        ),

        Positioned(
          bottom: 30, left: 20, right: 20,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: attGradientStart.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle), child: Icon(Icons.check_circle_rounded, color: Colors.green.shade500, size: 20)),
                    const SizedBox(width: 15),
                    const Text("Location Verified", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.face_retouching_natural_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text("Face Recognition", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                      ],
                    ),
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
          Positioned.fill(
            child: Image.network(
              "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=800",
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          Positioned.fill(
            child: CustomPaint(
              painter: FaceScannerOverlayPainter(),
            ),
          ),

          if (_isScanning)
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                return Positioned(
                  top: MediaQuery.of(context).size.height * 0.25 + (_scanController.value * (MediaQuery.of(context).size.height * 0.4)),
                  left: 40, right: 40,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                        color: attGradientEnd,
                        boxShadow: [BoxShadow(color: attGradientEnd, blurRadius: 15, spreadRadius: 2)]
                    ),
                  ),
                );
              },
            ),

          Positioned(
            top: 60, left: 0, right: 0,
            child: Column(
              children: [
                const Text("Face Recognition", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1)),
                const SizedBox(height: 8),
                Text(_isScanning ? "Scanning your face..." : "Match Confirmed!", style: TextStyle(color: _isScanning ? Colors.white70 : Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          if (!_isScanning)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.9), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 30, spreadRadius: 10)]),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
              ),
            ),

          Positioned(
            bottom: 40, left: 0, right: 0,
            child: Center(
              child: InkWell(
                onTap: () => setState(() => _currentView = 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white54)),
                  child: const Text("Cancel Scanning", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
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

    final cutoutRect = RRect.fromLTRBAndCorners(
      rectLeft, rectTop, rectLeft + rectWidth, rectTop + rectHeight,
      topLeft: const Radius.circular(40), topRight: const Radius.circular(40),
      bottomLeft: const Radius.circular(40), bottomRight: const Radius.circular(40),
    );

    canvas.drawPath(
      Path.combine(PathOperation.difference, Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)), Path()..addRRect(cutoutRect)),
      backgroundPaint,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    double cornerLength = 30.0;

    canvas.drawPath(Path()..moveTo(rectLeft, rectTop + cornerLength)..lineTo(rectLeft, rectTop)..lineTo(rectLeft + cornerLength, rectTop), borderPaint);
    canvas.drawPath(Path()..moveTo(rectLeft + rectWidth - cornerLength, rectTop)..lineTo(rectLeft + rectWidth, rectTop)..lineTo(rectLeft + rectWidth, rectTop + cornerLength), borderPaint);
    canvas.drawPath(Path()..moveTo(rectLeft, rectTop + rectHeight - cornerLength)..lineTo(rectLeft, rectTop + rectHeight)..lineTo(rectLeft + cornerLength, rectTop + rectHeight), borderPaint);
    canvas.drawPath(Path()..moveTo(rectLeft + rectWidth - cornerLength, rectTop + rectHeight)..lineTo(rectLeft + rectWidth, rectTop + rectHeight)..lineTo(rectLeft + rectWidth, rectTop + rectHeight - cornerLength), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}