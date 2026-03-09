import 'package:flutter/material.dart';
import 'user_session.dart'; // ✅ WAJIB IMPORT INI UNTUK LOGIKA ROLE

// ==========================================
// WARNA TEMA PREMIUM GLOBAL
// ==========================================
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
  int _selectedDateIndex = 2; // Default ke hari ini (Index 2: Sun 14)

  // =========================================================
  // 1. DATA JADWAL UNTUK SISWA
  // =========================================================
  final List<Map<String, dynamic>> _studentSchedules = [
    {
      "subject": "Matematika",
      "person": "Bpk. Yoga Pratama", // Siswa melihat nama GURU
      "room": "Ruang Kelas XII-A",
      "time": "08:00 - 09:30",
      "status": "Sedang Berlangsung",
      "color": const Color(0xFF10B981), // Hijau (Ongoing)
    },
    {
      "subject": "Bahasa Inggris",
      "person": "Ibu Siti Aminah",
      "room": "Ruang Kelas XII-A",
      "time": "10:00 - 11:30",
      "status": "Akan Datang",
      "color": const Color(0xFFF59E0B), // Oranye (Upcoming)
    },
    {
      "subject": "Pendidikan Agama",
      "person": "Bpk. Ahmad Fauzi",
      "room": "Ruang Kelas XII-A",
      "time": "13:00 - 14:30",
      "status": "Akan Datang",
      "color": const Color(0xFFF59E0B),
    },
  ];

  // =========================================================
  // 2. DATA JADWAL UNTUK GURU / KEPSEK
  // =========================================================
  final List<Map<String, dynamic>> _teacherSchedules = [
    {
      "subject": "Matematika",
      "person": "Kelas XII TKJ B", // Guru melihat nama KELAS
      "room": "Lab Komputer 1",
      "time": "08:00 - 09:30",
      "status": "Sedang Berlangsung",
      "color": const Color(0xFF10B981),
    },
    {
      "subject": "Matematika",
      "person": "Kelas XI MIPA A",
      "room": "Ruang Kelas XI-A",
      "time": "10:00 - 11:30",
      "status": "Akan Datang",
      "color": const Color(0xFFF59E0B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 🚦 KONDISI WIDGET: Cek siapa yang sedang login
    bool isStudent = UserSession.currentRole == 'Student';

    // Pilih data yang mau ditampilkan berdasarkan Role
    List<Map<String, dynamic>> currentSchedules = isStudent ? _studentSchedules : _teacherSchedules;

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
            // --- HEADER BULAN ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Aug 2023',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textDark, letterSpacing: -0.5),
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

            // --- DATE SELECTOR (Premium Version) ---
            _buildDateSelector(),
            const SizedBox(height: 35),

            // --- SECTION HEADER ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Classes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textDark),
                ),
                Text(
                  '${currentSchedules.length} Classes',
                  style: const TextStyle(fontSize: 13, color: textMuted, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- LIST JADWAL DINAMIS ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentSchedules.length,
              itemBuilder: (context, index) {
                return _buildPremiumScheduleCard(
                  data: currentSchedules[index],
                  isStudent: isStudent,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // WIDGET: DATE SELECTOR (Desain Lebih Mulus)
  // =========================================================
  Widget _buildDateSelector() {
    final List<Map<String, dynamic>> dates = [
      {'day': 'Fri', 'date': '11'},
      {'day': 'Sat', 'date': '12'},
      {'day': 'Sun', 'date': '14'},
      {'day': 'Mon', 'date': '15'},
      {'day': 'Tue', 'date': '16'},
    ];

    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: dates.length,
        itemBuilder: (context, index) {
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
                borderRadius: BorderRadius.circular(20), // Sudut kapsul premium
                boxShadow: isActive
                    ? [BoxShadow(color: primaryBlue.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))]
                    : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))],
                border: isActive ? null : Border.all(color: Colors.grey.shade200, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      dates[index]['day']!,
                      style: TextStyle(
                        color: isActive ? Colors.white.withOpacity(0.9) : textMuted,
                        fontSize: 13,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      )
                  ),
                  const SizedBox(height: 5),
                  Text(
                      dates[index]['date']!,
                      style: TextStyle(
                        color: isActive ? Colors.white : textDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      )
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // =========================================================
  // WIDGET: SCHEDULE CARD (PREMIUM & DINAMIS)
  // =========================================================
  Widget _buildPremiumScheduleCard({required Map<String, dynamic> data, required bool isStudent}) {
    Color statusColor = data['color'];
    bool isOngoing = data['status'] == "Sedang Berlangsung";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // Melengkung ala iOS
        boxShadow: [
          BoxShadow(color: const Color(0xFF94A3B8).withOpacity(0.12), blurRadius: 24, offset: const Offset(0, 8))
        ],
        border: isOngoing ? Border.all(color: statusColor.withOpacity(0.3), width: 1.5) : null, // Highlight border jika sedang kelas
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Garis Indikator Kiri
          Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(5)
              )
          ),
          const SizedBox(width: 15),

          // Konten Tengah
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Waktu & Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        data['time'],
                        style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.w900, fontSize: 13)
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                          data['status'],
                          style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                // Mata Pelajaran
                Text(
                    data['subject'],
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: textDark, letterSpacing: -0.3)
                ),
                const SizedBox(height: 8),

                // 🚦 TEKS DINAMIS BERDASARKAN ROLE
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

                // Ruangan
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 14, color: textMuted),
                    const SizedBox(width: 6),
                    Text(
                        "Ruang : ${data['room']}",
                        style: const TextStyle(color: textMuted, fontSize: 12, fontWeight: FontWeight.w500)
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}