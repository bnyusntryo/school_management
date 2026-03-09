import 'package:flutter/material.dart';
import 'user_session.dart';

class ClassActivityPage extends StatefulWidget {
  const ClassActivityPage({super.key});

  @override
  State<ClassActivityPage> createState() => _ClassActivityPageState();
}

class _ClassActivityPageState extends State<ClassActivityPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  // Filter yang sedang aktif
  String _selectedFilter = "All";
  final List<String> _filters = ["All", "TKJ", "DKV", "Perkantoran", "RPL"];

  // Warna Gradien Khas Attendance
  final Color attGradientStart = const Color(0xFF4A90E2);
  final Color attGradientEnd = const Color(0xFFF06292);

  // Data Dummy Guru & Kepsek
  final List<Map<String, String>> _teacherClasses = [
    {"code": "XII\nTKJ", "name": "X TKJ B", "wali": "Yoga Pratama", "period": "Period Year 2023", "classCode": "XII_TKJ_2"},
    {"code": "XI\nMIPA", "name": "X MIPA A", "wali": "Andi Setiawan", "period": "Period Year 2023", "classCode": "XI_MIPA_1"},
    {"code": "X\nIPS", "name": "X IPS C", "wali": "Budi Santoso", "period": "Period Year 2023", "classCode": "X_IPS_3"},
    {"code": "IX\nB", "name": "IX B", "wali": "Siti Nurhaliza", "period": "Period Year 2023", "classCode": "IX_B_1"},
    {"code": "VIII\nA", "name": "VIII A", "wali": "Rudi Hartono", "period": "Period Year 2023", "classCode": "VIII_A_1"},
  ];

  // Data Dummy Siswa
  final List<Map<String, dynamic>> _studentActivities = [
    {"type": "MID\nTEST", "title": "ASAS GANJIL 25-26", "date": "Oct 01 - Oct 24, 2023", "action": "Passed", "statusColor": Colors.green},
    {"type": "FINAL\nTEST", "title": "ASAS GENAP 25-26", "date": "Nov 01 - Nov 15, 2023", "action": "Submit Project", "statusColor": Colors.indigo},
    {"type": "MID\nTEST", "title": "TEKNIK PEMROGRAMAN", "date": "Oct 10 - Oct 31, 2023", "action": "Take Exam", "statusColor": Colors.blue},
    {"type": "MID\nTEST", "title": "ASAS GANJIL 25-26", "date": "Oct 01 - Oct 24, 2023", "action": "Take Exam", "statusColor": Colors.blue},
    {"type": "MID\nTEST", "title": "DATABASE 25-26", "date": "Oct 15 - Nov 01, 2023", "action": "Take Exam", "statusColor": Colors.blue},
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isStudent = UserSession.currentRole == 'Student';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB), // Background disamakan dengan attendance
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FB),
        elevation: 0,
        centerTitle: false,
        title: Text(
          isStudent ? "Exam Activities" : "Class Activity List",
          style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- BAGIAN HEADER ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search_rounded, color: Colors.grey, size: 22),
                      hintText: "Search class or subject...",
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline, color: Color(0xFFF06292), size: 18),
                      label: const Text("Add", style: TextStyle(color: Color(0xFFF06292), fontWeight: FontWeight.w800)),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.upload_file_rounded, color: Color(0xFF4A90E2), size: 18),
                      label: const Text("Upload", style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- FILTER KELAS (Hanya Guru/Kepsek) ---
          if (!isStudent)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    bool isActive = _selectedFilter == _filters[index];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = _filters[index]),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: isActive
                              ? LinearGradient(colors: [attGradientStart, attGradientEnd])
                              : null,
                          color: isActive ? null : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: isActive ? null : Border.all(color: Colors.grey.shade300),
                          boxShadow: isActive ? [BoxShadow(color: attGradientEnd.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
                        ),
                        child: Center(
                          child: Text(
                            _filters[index],
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // --- LIST DATA ---
          Expanded(
            child: isStudent ? _buildStudentList() : _buildTeacherList(),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // KARTU LIST KELAS (GURU / KEPSEK) - TEMA ATTENDANCE
  // =========================================================
  Widget _buildTeacherList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      physics: const BouncingScrollPhysics(),
      itemCount: _teacherClasses.length,
      itemBuilder: (context, index) {
        final data = _teacherClasses[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassActivitySubjectListPage(classData: data),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [attGradientStart, attGradientEnd]),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: attGradientEnd.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
            ),
            child: Stack(
              children: [
                // Ornamen Plus ala Attendance
                Positioned(top: 0, right: 20, child: Icon(Icons.add, color: Colors.white.withOpacity(0.15), size: 24)),
                Positioned(bottom: 10, left: 60, child: Icon(Icons.add, color: Colors.white.withOpacity(0.1), size: 30)),

                Row(
                  children: [
                    // Kotak Transparan Kiri
                    Container(
                      width: 65, height: 75,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Center(
                        child: Text(
                          data['code']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, height: 1.2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    // Informasi Kanan
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['name']!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.person_outline_rounded, size: 14, color: Colors.white.withOpacity(0.8)),
                              const SizedBox(width: 5),
                              Text(data['wali']!, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_month_rounded, size: 12, color: Colors.white.withOpacity(0.6)),
                              const SizedBox(width: 5),
                              Text(data['period']!, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Panah Kanan
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // KARTU LIST UJIAN (SISWA) - TEMA ATTENDANCE
  // =========================================================
  Widget _buildStudentList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      physics: const BouncingScrollPhysics(),
      itemCount: _studentActivities.length,
      itemBuilder: (context, index) {
        final data = _studentActivities[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [attGradientStart, attGradientEnd]),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [BoxShadow(color: attGradientEnd.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: Stack(
            children: [
              Positioned(top: 10, right: 30, child: Icon(Icons.add, color: Colors.white.withOpacity(0.1), size: 24)),

              Row(
                children: [
                  // Kotak Tipe Ujian
                  Container(
                    width: 75, height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Text(
                        data['type']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, height: 1.2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Informasi Kanan
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['title']!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 12, color: Colors.white.withOpacity(0.7)),
                            const SizedBox(width: 5),
                            Text(data['date']!, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Tombol Aksi (Dengan background putih agar menonjol dari gradien)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                          ),
                          child: Text(
                              data['action']!,
                              style: TextStyle(color: data['statusColor'], fontSize: 12, fontWeight: FontWeight.w900)
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// HALAMAN BARU: CLASS ACTIVITY LIST SUBJECT (GAMBAR 3)
// ============================================================================
class ClassActivitySubjectListPage extends StatelessWidget {
  final Map<String, String> classData;

  const ClassActivitySubjectListPage({super.key, required this.classData});

  @override
  Widget build(BuildContext context) {
    // Warna yang sama dengan Attendance
    final Color attGradientStart = const Color(0xFF4A90E2);
    final Color attGradientEnd = const Color(0xFFF06292);

    final List<Map<String, String>> subjects = [
      {"code": "MTK", "name": "Matematika", "teacher": "Yoga Pratama", "curriculum": "Kurikulum 2013"},
      {"code": "BIO", "name": "Biologi", "teacher": "Siti Nurhaliza", "curriculum": "Kurikulum 2013"},
      {"code": "FIS", "name": "Fisika", "teacher": "Ahmad Fauzi", "curriculum": "Kurikulum 2013"},
      {"code": "KIM", "name": "Kimia", "teacher": "Rina Setiawati", "curriculum": "Kurikulum 2013"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FB),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Subject List",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- KOTAK INFO KELAS (Dibuat Semi-Gradien) ---
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: attGradientStart.withOpacity(0.3), width: 1.5),
                boxShadow: [BoxShadow(color: attGradientStart.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: Column(
                children: [
                  _buildInfoField("Class Code", classData['classCode'] ?? "XII_TKJ_2", attGradientStart),
                  const SizedBox(height: 15),
                  _buildInfoField("Class Name", classData['name'] ?? "XII-A", attGradientEnd),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFB91C1C)]), // Gradien Merah
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        ),
                        child: const Text("Cancel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- SEARCH BAR ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search_rounded, color: attGradientStart, size: 22),
                  hintText: "Search subject...",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- DAFTAR MATA PELAJARAN (TEMA ATTENDANCE) ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [attGradientStart, attGradientEnd]),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [BoxShadow(color: attGradientEnd.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: Stack(
                    children: [
                      Positioned(top: 5, right: 10, child: Icon(Icons.book_outlined, color: Colors.white.withOpacity(0.1), size: 40)),
                      Row(
                        children: [
                          // Kotak Kode Mapel
                          Container(
                            width: 65, height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Center(
                              child: Text(
                                subject['code']!,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Info Mapel
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(subject['name']!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.person, size: 12, color: Colors.white.withOpacity(0.7)),
                                    const SizedBox(width: 5),
                                    Text(subject['teacher']!, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.menu_book_rounded, size: 12, color: Colors.white.withOpacity(0.6)),
                                    const SizedBox(width: 5),
                                    Text(subject['curriculum']!, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Panah
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                            child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper Info dengan Sedikit Sentuhan Warna
  Widget _buildInfoField(String label, String value, Color accentColor) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withOpacity(0.2)),
            ),
            child: Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: accentColor)
            ),
          ),
        ),
      ],
    );
  }
}