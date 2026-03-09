import 'package:flutter/material.dart';
import 'user_session.dart';

// ==========================================
// WARNA TEMA PREMIUM GLOBAL (Modern Tech Vibe)
// ==========================================
const Color bgPremium = Color(0xFFF4F7FB);
const Color textDark = Color(0xFF0F172A);
const Color textMuted = Color(0xFF64748B);
const Color primaryBlue = Color(0xFF3B82F6);
const Color primaryPink = Color(0xFFEC4899);
final Color attGradientEnd = const Color(0xFFF06292);

// ============================================================================
// HALAMAN 1: CLASS ACTIVITY LIST (HALAMAN DEPAN)
// ============================================================================
class ClassActivityPage extends StatefulWidget {
  const ClassActivityPage({super.key});

  @override
  State<ClassActivityPage> createState() => _ClassActivityPageState();
}

class _ClassActivityPageState extends State<ClassActivityPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  String _selectedFilter = "All";
  final List<String> _filters = ["All", "TKJ", "DKV", "Perkantoran", "RPL"];

  final List<Map<String, String>> _teacherClasses = [
    {"code": "XII\nTKJ", "name": "X TKJ B", "wali": "Yoga Pratama", "period": "Tahun 2023", "classCode": "XII_TKJ_2"},
    {"code": "XI\nMIPA", "name": "X MIPA A", "wali": "Andi Setiawan", "period": "Tahun 2023", "classCode": "XI_MIPA_1"},
    {"code": "X\nIPS", "name": "X IPS C", "wali": "Budi Santoso", "period": "Tahun 2023", "classCode": "X_IPS_3"},
    {"code": "IX\nB", "name": "IX B", "wali": "Siti Nurhaliza", "period": "Tahun 2023", "classCode": "IX_B_1"},
    {"code": "VIII\nA", "name": "VIII A", "wali": "Rudi Hartono", "period": "Tahun 2023", "classCode": "VIII_A_1"},
  ];

  final List<Map<String, dynamic>> _studentActivities = [
    {"type": "MID\nTEST", "title": "ASAS GANJIL 25-26", "date": "01 - 24 Oct 2023", "action": "Passed", "isDone": true},
    {"type": "FINAL\nTEST", "title": "ASAS GENAP 25-26", "date": "01 - 15 Nov 2023", "action": "Submit Project", "isDone": false},
    {"type": "MID\nTEST", "title": "TEKNIK PEMROGRAMAN", "date": "10 - 31 Oct 2023", "action": "Take Exam", "isDone": false},
    {"type": "MID\nTEST", "title": "ASAS GANJIL 25-26", "date": "01 - 24 Oct 2023", "action": "Take Exam", "isDone": false},
    {"type": "MID\nTEST", "title": "DATABASE 25-26", "date": "15 Nov - 01 Dec", "action": "Take Exam", "isDone": false},
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
      backgroundColor: bgPremium,
      appBar: AppBar(
        backgroundColor: bgPremium,
        elevation: 0,
        centerTitle: false,
        title: Text(
          isStudent ? "Exam Activities" : "Class Activity",
          style: const TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!isStudent)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                backgroundColor: primaryBlue.withOpacity(0.1),
                child: const Icon(Icons.more_horiz_rounded, color: primaryBlue),
              ),
            )
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER & SEARCH (Super Bersih Tanpa Tombol Add) ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: const Color(0xFFCBD5E1).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_rounded, color: textMuted, size: 22),
                        hintText: "Search class or subject...",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 55, width: 55,
                  decoration: BoxDecoration(
                    color: textDark,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: textDark.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune_rounded, color: Colors.white),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),

          if (!isStudent)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    bool isActive = _selectedFilter == _filters[index];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = _filters[index]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        decoration: BoxDecoration(
                          gradient: isActive
                              ? const LinearGradient(colors: [primaryBlue, Color(0xFF60A5FA)])
                              : const LinearGradient(colors: [Colors.white, Colors.white]),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isActive
                              ? [BoxShadow(color: primaryBlue.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))]
                              : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2))],
                          border: isActive ? null : Border.all(color: Colors.grey.shade200),
                        ),
                        child: Center(
                          child: Text(
                            _filters[index],
                            style: TextStyle(
                              color: isActive ? Colors.white : textMuted,
                              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
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

          Expanded(
            child: isStudent ? _buildStudentList() : _buildTeacherList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      physics: const BouncingScrollPhysics(),
      itemCount: _teacherClasses.length,
      itemBuilder: (context, index) {
        final data = _teacherClasses[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: const Color(0xFF94A3B8).withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 10))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ClassActivitySubjectListPage(classData: data)));
              },
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 65, height: 65,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                          colors: [primaryBlue, Color(0xFF818CF8)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: primaryBlue.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))],
                      ),
                      child: Center(
                        child: Text(
                          data['code']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, height: 1.2, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['name']!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: textDark, letterSpacing: -0.3)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.person_rounded, size: 14, color: Colors.grey.shade400),
                              const SizedBox(width: 6),
                              Text(data['wali']!, style: const TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Text(data['period']!, style: const TextStyle(color: textMuted, fontSize: 10, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
                      child: const Icon(Icons.arrow_forward_ios_rounded, color: textMuted, size: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStudentList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      physics: const BouncingScrollPhysics(),
      itemCount: _studentActivities.length,
      itemBuilder: (context, index) {
        final data = _studentActivities[index];
        bool isDone = data['isDone'];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: const Color(0xFF94A3B8).withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 10))],
            border: isDone ? Border.all(color: const Color(0xFF10B981).withOpacity(0.3), width: 1.5) : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 65, height: 65,
                  decoration: BoxDecoration(
                    color: isDone ? const Color(0xFFD1FAE5) : const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      data['type']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isDone ? const Color(0xFF059669) : primaryBlue,
                          fontWeight: FontWeight.w900, fontSize: 12, height: 1.2
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['title']!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: textDark, letterSpacing: -0.3), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, size: 14, color: Colors.grey.shade400),
                          const SizedBox(width: 5),
                          Text(data['date']!, style: const TextStyle(color: textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: isDone
                              ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)])
                              : const LinearGradient(colors: [primaryBlue, Color(0xFF60A5FA)]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: isDone ? const Color(0xFF10B981).withOpacity(0.3) : primaryBlue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isDone) const Icon(Icons.check_circle_rounded, color: Colors.white, size: 14),
                            if (isDone) const SizedBox(width: 6),
                            Text(data['action']!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// HALAMAN 2: CLASS ACTIVITY LIST SUBJECT
// ============================================================================
class ClassActivitySubjectListPage extends StatelessWidget {
  final Map<String, String> classData;

  const ClassActivitySubjectListPage({super.key, required this.classData});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> subjects = [
      {"code": "MTK", "name": "Matematika", "teacher": "Yoga Pratama", "curriculum": "Kurikulum 2013"},
      {"code": "BIO", "name": "Biologi", "teacher": "Siti Nurhaliza", "curriculum": "Kurikulum 2013"},
      {"code": "FIS", "name": "Fisika", "teacher": "Ahmad Fauzi", "curriculum": "Kurikulum 2013"},
      {"code": "KIM", "name": "Kimia", "teacher": "Rina Setiawati", "curriculum": "Kurikulum 2013"},
    ];

    return Scaffold(
      backgroundColor: bgPremium,
      appBar: AppBar(
        backgroundColor: bgPremium,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Subject List",
          style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: const Color(0xFF94A3B8).withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 10))],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.meeting_room_rounded, color: primaryBlue, size: 24),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Current Class", style: TextStyle(color: textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(classData['name'] ?? "XII-A", style: const TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 18)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Text(
                          classData['classCode'] ?? "CODE",
                          style: TextStyle(color: Colors.amber.shade700, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(height: 1, color: Color(0xFFF1F5F9), thickness: 1.5),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEF2F2),
                        foregroundColor: const Color(0xFFDC2626),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Close Subject List", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),

            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: const Color(0xFFCBD5E1).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded, color: textMuted, size: 22),
                  hintText: "Find subjects...",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
            const SizedBox(height: 25),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];

                List<Color> iconColors = [
                  const Color(0xFF3B82F6), const Color(0xFF10B981),
                  const Color(0xFFF59E0B), const Color(0xFF8B5CF6)
                ];
                Color currentColor = iconColors[index % iconColors.length];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: const Color(0xFF94A3B8).withOpacity(0.12), blurRadius: 24, offset: const Offset(0, 8))],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ClassActivitySubjectDetailListPage(subjectData: subject))
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Container(
                              width: 60, height: 60,
                              decoration: BoxDecoration(
                                color: currentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  subject['code']!,
                                  style: TextStyle(color: currentColor, fontWeight: FontWeight.w900, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(subject['name']!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: textDark, letterSpacing: -0.3)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.person, size: 14, color: Colors.grey.shade400),
                                      const SizedBox(width: 6),
                                      Text(subject['teacher']!, style: const TextStyle(color: textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(subject['curriculum']!, style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// HALAMAN 3: CLASS ACTIVITY SUBJECT DETAIL LIST (ADA TOMBOL ADD KHUSUS GURU)
// ============================================================================
class ClassActivitySubjectDetailListPage extends StatefulWidget {
  final Map<String, String> subjectData;

  const ClassActivitySubjectDetailListPage({super.key, required this.subjectData});

  @override
  State<ClassActivitySubjectDetailListPage> createState() => _ClassActivitySubjectDetailListPageState();
}

class _ClassActivitySubjectDetailListPageState extends State<ClassActivitySubjectDetailListPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  final List<Map<String, dynamic>> _meetings = [
    {
      "meeting": "Pertemuan 1",
      "topic": "Aljabar Linear",
      "teacher": "Yoga Pratama",
      "greeting": "Hello everyone!",
      "description": "Pertemuan pertama ini kita membahas tentang aljabar linear dan tugas untuk pekerjaan di rumah",
      "link": "https://link.tugas.com",
      "deadline": "1/9/2026",
      "timeAgo": "20 mins ago"
    },
    {
      "meeting": "Pertemuan 2",
      "topic": "Statistika Dasar",
      "teacher": "Siti Aminah",
      "greeting": "Selamat Pagi!",
      "description": "Mari kita pelajari dasar-dasar statistika dan pengumpulan data.",
      "link": "https://materi.statistika.com",
      "deadline": "8/9/2026",
      "timeAgo": "1 hour ago"
    },
    {
      "meeting": "Pertemuan 3",
      "topic": "Pemrograman Dasar",
      "teacher": "Budi Santoso",
      "greeting": "Halo Coders!",
      "description": "Siapkan laptop kalian, kita akan belajar pengenalan variabel dan tipe data.",
      "link": "https://tugas.coding.com",
      "deadline": "15/9/2026",
      "timeAgo": "5 hours ago"
    },
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🚦 KONDISI WIDGET: Cek apakah yang login adalah Guru
    bool isTeacher = UserSession.currentRole == 'Teacher';

    return Scaffold(
      backgroundColor: bgPremium,
      appBar: AppBar(
        backgroundColor: bgPremium,
        elevation: 0,
        centerTitle: false,
        title: Text(
          widget.subjectData['name'] ?? "Subject Detail",
          style: const TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: const Color(0xFF94A3B8).withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 10))],
              ),
              child: Column(
                children: [
                  _buildReadOnlyField("Subject Class Code", widget.subjectData['code'] ?? "-"),
                  const SizedBox(height: 15),
                  _buildReadOnlyField("Subject Name", widget.subjectData['name'] ?? "-"),
                ],
              ),
            ),
            const SizedBox(height: 25),

            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: const Color(0xFFCBD5E1).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
                border: Border.all(color: primaryBlue.withOpacity(0.3), width: 1.5),
              ),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded, color: textMuted, size: 22),
                  hintText: "Search Teacher",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // ✅ PERBAIKAN: Tombol Add dipindahkan ke sini dan dilindungi kondisi Role
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Meeting List", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textDark)),
                if (isTeacher)
                  Row(
                    children: [
                      _buildPremiumActionBtn(Icons.upload_file_rounded, "Upload", Colors.white, textDark, () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Upload Feature (Coming Soon)")));
                      }),
                      const SizedBox(width: 10),
                      _buildPremiumActionBtn(Icons.add_rounded, "Add", primaryBlue, Colors.white, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddClassActivityPage()));
                      }),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _meetings.length,
              itemBuilder: (context, index) {
                final meeting = _meetings[index];
                String meetingNumber = meeting['meeting']!.split(' ').last;

                List<List<Color>> attPalettes = [
                  [const Color(0xFF4A90E2), const Color(0xFFF06292)],
                  [const Color(0xFF60A5FA), const Color(0xFF818CF8)],
                  [const Color(0xFFF06292), const Color(0xFFEC4899)],
                ];
                List<Color> currentPalette = attPalettes[index % attPalettes.length];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: const Color(0xFF94A3B8).withOpacity(0.12), blurRadius: 24, offset: const Offset(0, 8))],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ClassActivityMeetingDetailPage(meetingData: meeting)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 50, height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: currentPalette),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [BoxShadow(color: currentPalette.last.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
                              ),
                              child: Center(
                                child: Text(
                                  meetingNumber,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(meeting['meeting']!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: textDark, letterSpacing: -0.3)),
                                  const SizedBox(height: 6),
                                  Text(meeting['topic']!, style: const TextStyle(color: textMuted, fontSize: 14, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.person, size: 14, color: primaryBlue),
                                      const SizedBox(width: 6),
                                      Text("Pengajar : ${meeting['teacher']}", style: const TextStyle(color: textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }

  // Widget Helper Tombol Aksi
  Widget _buildPremiumActionBtn(IconData icon, String label, Color bgColor, Color textColor, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: bgColor == Colors.white
            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
            : [BoxShadow(color: bgColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(icon, color: textColor, size: 14),
                const SizedBox(width: 6),
                Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(color: textMuted, fontSize: 14, fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: textDark)
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// HALAMAN 4: MEETING DETAIL PAGE
// ============================================================================
class ClassActivityMeetingDetailPage extends StatelessWidget {
  final Map<String, dynamic> meetingData;

  const ClassActivityMeetingDetailPage({super.key, required this.meetingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPremium,
      appBar: AppBar(
        backgroundColor: bgPremium,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Meeting Detail",
          style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: const Color(0xFF94A3B8).withOpacity(0.18), blurRadius: 30, offset: const Offset(0, 15))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 5, height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF4A90E2), Color(0xFFF06292)]),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meetingData['meeting'] ?? "Pertemuan",
                          style: const TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          meetingData['topic'] ?? "Topik Pembahasan",
                          style: const TextStyle(color: primaryBlue, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Pengajar : ${meetingData['teacher'] ?? "Nama Pengajar"}",
                          style: const TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
              ),

              Row(
                children: [
                  const Icon(Icons.waving_hand_rounded, color: Colors.amber, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    meetingData['greeting'] ?? "Hello everyone!",
                    style: const TextStyle(color: textDark, fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                meetingData['description'] ?? "Deskripsi materi pertemuan...",
                style: const TextStyle(color: textDark, fontSize: 15, height: 1.7),
              ),
              const SizedBox(height: 25),

              _buildPremiumContentBlock(
                icon: Icons.link_rounded,
                label: "Link Tugas :",
                color: primaryBlue,
                content: "[${meetingData['link'] ?? "https://link.tugas.com"}]",
                isLink: true,
              ),

              const SizedBox(height: 20),

              _buildPremiumContentBlock(
                icon: Icons.event_busy_rounded,
                label: "Batas kumpul :",
                color: attGradientEnd,
                content: meetingData['deadline'] ?? "1/9/2026",
              ),

              const SizedBox(height: 35),

              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time_filled_rounded, color: textMuted, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        meetingData['timeAgo'] ?? "20 mins ago",
                        style: const TextStyle(color: textMuted, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumContentBlock({required IconData icon, required String label, required Color color, required String content, bool isLink = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: textDark, fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Text(
            content,
            style: TextStyle(
              color: color,
              fontSize: isLink ? 13 : 14,
              fontWeight: FontWeight.bold,
              decoration: isLink ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// HALAMAN 5: ADD CLASS ACTIVITY (FORM PREMIUM)
// ============================================================================
class AddClassActivityPage extends StatefulWidget {
  const AddClassActivityPage({super.key});

  @override
  State<AddClassActivityPage> createState() => _AddClassActivityPageState();
}

class _AddClassActivityPageState extends State<AddClassActivityPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _linkCtrl = TextEditingController();

  String _startTime = "Select Start Time";
  String _endTime = "Select End Time";

  Future<void> _pickDateTime(bool isStart) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF3B82F6)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          String formatted = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year} - ${pickedTime.format(context)}";
          if (isStart) {
            _startTime = formatted;
          } else {
            _endTime = formatted;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _linkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPremium,
      appBar: AppBar(
        backgroundColor: bgPremium,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Add Class Activity",
          style: TextStyle(color: textDark, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: const Color(0xFF94A3B8).withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 15))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPremiumTextField("Activity Name", "e.g. Pertemuan 6 - Kuis", _nameCtrl),
              const SizedBox(height: 20),

              _buildPremiumTextField("Activity Description", "Type your description here...", _descCtrl, isMultiline: true),
              const SizedBox(height: 20),

              _buildPremiumTextField("Activity Link (Optional)", "https://...", _linkCtrl),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _buildDateTimePicker("Start Time", _startTime, () => _pickDateTime(true))),
                  const SizedBox(width: 15),
                  Expanded(child: _buildDateTimePicker("End Time", _endTime, () => _pickDateTime(false))),
                ],
              ),
              const SizedBox(height: 25),

              const Text("Attachment", style: TextStyle(color: textDark, fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid, width: 1.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_rounded, color: primaryBlue, size: 40),
                    const SizedBox(height: 10),
                    const Text("Upload documents or images here", style: TextStyle(color: textMuted, fontSize: 12)),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildUploadBtn("Choose File", primaryBlue, Colors.white),
                        const SizedBox(width: 10),
                        _buildUploadBtn("Upload", Colors.grey.shade300, textDark),
                      ],
                    )
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
              ),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEF2F2),
                        foregroundColor: const Color(0xFFDC2626),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [primaryBlue, Color(0xFF60A5FA)]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: primaryBlue.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Activity Added Successfully!")));
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumTextField(String label, String hint, TextEditingController ctrl, {bool isMultiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: textDark, fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: ctrl,
            maxLines: isMultiline ? 4 : 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(String label, String value, VoidCallback onTap) {
    bool hasSelected = value != "Select Start Time" && value != "Select End Time";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: textDark, fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 16, color: hasSelected ? primaryBlue : Colors.grey.shade400),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(color: hasSelected ? textDark : Colors.grey.shade500, fontSize: 12, fontWeight: hasSelected ? FontWeight.w600 : FontWeight.w400),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadBtn(String label, Color bgColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}