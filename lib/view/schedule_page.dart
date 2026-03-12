import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/pref.dart';
import 'auth_provider.dart';
import 'class_activity_page.dart';

const Color bgPremium = Color(0xFFF4F7FB);
const Color textDark = Color(0xFF0F172A);
const Color textMuted = Color(0xFF64748B);
const Color primaryBlue = Color(0xFF3B82F6);

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedDateIndex = 2;

  List<dynamic> _apiSchedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSchedule();
  }

  Future<void> _fetchSchedule() async {
    try {
      String? token = await Session().getUserToken();
      final response = await http.post(
        Uri.parse('https://schoolapp-api-dev.zeabur.app/api/home/mytodayclass'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final dataNode = result['data'];
        List classList = dataNode is List ? dataNode : (dataNode?['data'] ?? []);

        if (mounted) {
          setState(() {
            _apiSchedules = classList;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      print("🚨 Error fetch schedule: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _isNowInSchedule(String? start, String? end) {
    if (start == null || end == null) return false;
    try {
      final now = DateTime.now();
      final startParts = start.split(':');
      final endParts = end.split(':');

      final startTime = DateTime(now.year, now.month, now.day, int.parse(startParts[0]), int.parse(startParts[1]));
      final endTime = DateTime(now.year, now.month, now.day, int.parse(endParts[0]), int.parse(endParts[1]));

      return now.isAfter(startTime) && now.isBefore(endTime);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);
    bool isStudent = authData.role == 'Student';

    String currentMonthYear = DateFormat('MMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: bgPremium,
      appBar: AppBar(
        backgroundColor: bgPremium,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isStudent ? 'My Schedule' : 'Teaching Schedule',
          style: const TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currentMonthYear,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textDark, letterSpacing: -0.5),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text("Today", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 20),

            _buildDateSelector(),
            const SizedBox(height: 35),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Classes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark),
                ),
                Text(
                  '${_apiSchedules.length} Classes',
                  style: const TextStyle(fontSize: 13, color: textMuted, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: CircularProgressIndicator(color: primaryBlue),
                ),
              )
            else if (_apiSchedules.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    children: [
                      Icon(Icons.event_busy_rounded, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 15),
                      Text("No classes left today!", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _apiSchedules.length,
                itemBuilder: (context, index) {
                  final itemRaw = _apiSchedules[index];

                  bool isOngoing = _isNowInSchedule(itemRaw['schedule_time_start'], itemRaw['schedule_time_end']);

                  Map<String, dynamic> mappedData = {
                    "subject": itemRaw['subjectclass_name'] ?? 'Unknown',
                    "person": isStudent ? (itemRaw['teacher_name'] ?? '-') : (itemRaw['class_name'] ?? '-'),
                    "room": itemRaw['room_name'] ?? 'TBA',
                    "time": "${itemRaw['schedule_time_start']} - ${itemRaw['schedule_time_end']}",
                    "status": isOngoing ? "Sedang Berlangsung" : "Akan Datang",
                    "color": isOngoing ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    "activityCount": 0,
                    "avatars": 0
                  };

                  return Dismissible(
                    key: Key(mappedData['time'] + index.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: const Color(0xFFEF4444).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]
                      ),
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 32),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        _apiSchedules.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${mappedData['subject']} class removed from view!"),
                          backgroundColor: const Color(0xFFEF4444),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: _buildPremiumScheduleCard(
                      data: mappedData,
                      isStudent: isStudent,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    final now = DateTime.now();
    final List<DateTime> dateList = List.generate(5, (index) => now.add(Duration(days: index - 2)));

    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: dateList.length,
        itemBuilder: (context, index) {
          final date = dateList[index];
          final bool isActive = index == _selectedDateIndex;

          return GestureDetector(
            onTap: () => setState(() => _selectedDateIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 65,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                gradient: isActive
                    ? const LinearGradient(colors: [primaryBlue, Color(0xFF60A5FA)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : const LinearGradient(colors: [Colors.white, Colors.white]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isActive
                    ? [BoxShadow(color: primaryBlue.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))]
                    : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))],
                border: isActive ? null : Border.all(color: Colors.grey.shade200, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      DateFormat('EEE').format(date),
                      style: TextStyle(color: isActive ? Colors.white.withOpacity(0.9) : textMuted, fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.w500)
                  ),
                  const SizedBox(height: 5),
                  Text(
                      DateFormat('dd').format(date),
                      style: TextStyle(color: isActive ? Colors.white : textDark, fontWeight: FontWeight.w900, fontSize: 18)
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPremiumScheduleCard({required Map<String, dynamic> data, required bool isStudent}) {
    Color statusColor = data['color'];
    bool isOngoing = data['status'] == "Sedang Berlangsung";
    int activityCount = data['activityCount'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFF94A3B8).withOpacity(0.12), blurRadius: 24, offset: const Offset(0, 8))],
        border: isOngoing ? Border.all(color: statusColor.withOpacity(0.3), width: 1.5) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 4, height: 70,
              decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(5))
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data['time'], style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.w900, fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(data['status'], style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Flexible(
                      child: Text(data['subject'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: textDark, letterSpacing: -0.3), overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 8),
                    if (data['avatars'] > 0) _buildStackedAvatars(data['avatars']),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(isStudent ? Icons.person_rounded : Icons.meeting_room_rounded, size: 14, color: textMuted),
                    const SizedBox(width: 6),
                    Text(
                        isStudent ? "Pengajar : ${data['person']}" : "Mengajar : ${data['person']}",
                        style: const TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.w600)
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 14, color: textMuted),
                    const SizedBox(width: 6),
                    Text("Ruang : ${data['room']}", style: const TextStyle(color: textMuted, fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ClassActivityPage()));
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: activityCount > 0 ? primaryBlue.withOpacity(0.1) : Colors.grey.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: activityCount > 0 ? primaryBlue.withOpacity(0.3) : Colors.grey.shade200),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.assignment_rounded, color: activityCount > 0 ? primaryBlue : Colors.grey.shade400, size: 24),
                      if (activityCount > 0)
                        Positioned(
                          top: -6, right: -6,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                            child: Text(
                              activityCount.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, height: 1),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                  "Activity",
                  style: TextStyle(color: activityCount > 0 ? primaryBlue : Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold)
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStackedAvatars(int count) {
    return SizedBox(
      width: 24.0 + (count - 1) * 12.0,
      height: 24,
      child: Stack(
        children: List.generate(count, (i) => Positioned(
          left: i * 12.0,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
            child: CircleAvatar(radius: 10, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${i + 15}')),
          ),
        )),
      ),
    );
  }
}