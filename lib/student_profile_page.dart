import 'package:flutter/material.dart';

// ============================================================================
// DATA DUMMY (LOGIK TIDAK DIUBAH)
// ============================================================================
class StudentData {
  static List<Map<String, String>> students = [
    {"id": "25049120", "name": "Abdullah Widodo", "class": "X AK 1", "image": ""},
    {"id": "25049121", "name": "Andika Prastyo", "class": "X AK 1", "image": ""},
    {"id": "25049122", "name": "ARDIAN RESTU TRIAJI", "class": "XII BDP 1", "image": ""},
    {"id": "25049123", "name": "ARSYVA RAHMAH", "class": "XII TKJ 1", "image": ""},
    {"id": "25049124", "name": "Bayu Saputra", "class": "X AK 2", "image": ""},
    {"id": "25049125", "name": "Cindy Amelia", "class": "XII AK 1", "image": ""},
  ];

  static List<Map<String, String>> attendanceData = [
    {"studentId": "25049120", "date": "20-Jan-2025", "status": "Present", "time": "07:00"},
    {"studentId": "25049120", "date": "21-Jan-2025", "status": "Present", "time": "07:10"},
    {"studentId": "25049120", "date": "22-Jan-2025", "status": "Absent", "time": "-"},
    {"studentId": "25049120", "date": "23-Jan-2025", "status": "Late", "time": "08:30"},
    {"studentId": "25049121", "date": "20-Jan-2025", "status": "Present", "time": "07:05"},
  ];
}

// ============================================================================
// HALAMAN 1: STUDENT LIST PAGE
// ============================================================================
class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _students = [
    {"name": "Yoga Pratama", "nis": "30291737282", "kelas": "XII", "jurusan": "Teknik Komputer Jaringan"},
    {"name": "Budi Santoso", "nis": "30291737283", "kelas": "XII", "jurusan": "Rekayasa Perangkat Lunak"},
    {"name": "Diana Sari", "nis": "30291737284", "kelas": "XII", "jurusan": "Desain Komunikasi Visual"},
    {"name": "Eko Prabowo", "nis": "30291737285", "kelas": "XII", "jurusan": "Sistem Informasi"},
    {"name": "Fani Lestari", "nis": "30291737286", "kelas": "XI", "jurusan": "Akuntansi"},
  ];

  List<Map<String, String>> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _filteredStudents = _students;
  }

  void _filterStudents(String query) {
    setState(() {
      _filteredStudents = _students
          .where((s) => s['name']!.toLowerCase().contains(query.toLowerCase()) ||
          s['jurusan']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // drawer: const SidebarMenu(), // UNCOMMENT INI BILA PERLU
      backgroundColor: const Color(0xFFF5F7FA), // Background abu-abu muda bersih
      body: CustomScrollView(
        slivers: [
          // --- HEADER MELENGKUNG TEMA ORANYE ---
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
                  colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Student Directory",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  icon: const Icon(Icons.person_add_rounded, color: Colors.white, size: 24),
                  tooltip: "Add Student",
                  onPressed: () async {
                    // // MUNCULKAN SAAT ANDA SUDAH PUNYA HALAMAN ADD STUDENT
                    // final result = await Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const AddStudentPage()),
                    // );
                    // if (result != null && result is Map<String, String>) {
                    //   setState(() {
                    //     _students.insert(0, result);
                    //     _filteredStudents = _students;
                    //   });
                    // }
                  },
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),

          // --- AREA PENCARIAN & INFO COUNTER ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.orange.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5)),
                            ],
                            border: Border.all(color: Colors.orange.shade50),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterStudents,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              icon: Icon(Icons.search_rounded, color: Colors.orange.shade400, size: 22),
                              hintText: "Search student or major...",
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.normal),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Clear Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _filterStudents('');
                          },
                          icon: Icon(Icons.filter_alt_off_rounded, color: Colors.grey.shade600, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Indikator Jumlah Siswa
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
                        child: Icon(Icons.people_alt_rounded, size: 14, color: Colors.orange.shade600),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${_filteredStudents.length} students found",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // --- DAFTAR SISWA (CARD STYLE MODERN) ---
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            sliver: _filteredStudents.isEmpty
                ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.person_off_rounded, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 15),
                      Text("No students found", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudentProfilePage(studentData: _filteredStudents[index])),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: _buildStudentCard(_filteredStudents[index]),
                  );
                },
                childCount: _filteredStudents.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Desain Kartu Siswa Baru
  Widget _buildStudentCard(Map<String, String> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.orange.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8)),
        ],
        border: Border.all(color: Colors.orange.shade50, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Garis Indikator Kiri Oranye
              Container(
                width: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.deepOrange.shade500],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      // Avatar Siswa
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.orange.shade200, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.orange.shade50,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${student['nis']}'),
                          onBackgroundImageError: (_, __) {},
                          child: student['name'] == null ? Icon(Icons.person_rounded, color: Colors.orange.shade400) : null,
                        ),
                      ),
                      const SizedBox(width: 15),

                      // Detail Siswa
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              student['name']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "NIS: ${student['nis']}",
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),

                            // Badge Kelas & Jurusan
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                _buildInfoBadge(Icons.bookmark_border_rounded, student['kelas']!, Colors.blue),
                                _buildInfoBadge(Icons.school_outlined, student['jurusan']!, Colors.deepOrange),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 28),
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

  Widget _buildInfoBadge(IconData icon, String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: color.shade100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color.shade600),
          const SizedBox(width: 4),
          Flexible(
            child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color.shade700), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// STUDENT PROFILE PAGE
// ============================================================================
class StudentProfilePage extends StatefulWidget {
  final Map<String, String> studentData;

  const StudentProfilePage({super.key, required this.studentData});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _nisController;
  late TextEditingController _bornDateController;
  late TextEditingController _bornPlaceController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _schoolOriginController;
  String _selectedGender = 'Select';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.studentData['name']);
    _nisController = TextEditingController(text: widget.studentData['nis']);
    _bornDateController = TextEditingController(text: '20/01/2008');
    _bornPlaceController = TextEditingController(text: 'Tangerang');
    _emailController = TextEditingController();
    _addressController = TextEditingController(text: 'Gang Haji Fulan RT 02 RW 09');
    _phoneController = TextEditingController(text: '08212134532');
    _schoolOriginController = TextEditingController(text: 'SMPN 7 Jakarta');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nisController.dispose();
    _bornDateController.dispose();
    _bornPlaceController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _schoolOriginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceHistory = StudentData.attendanceData.where((att) => att['studentId'] == widget.studentData['nis']).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // --- HEADER MELENGKUNG PROFILE ---
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.orange.shade400, Colors.deepOrange.shade700],
                      ),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.3)),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${widget.studentData['nis']}'),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          widget.studentData['name']!,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "NIS: ${widget.studentData['nis']}",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- BODY KONTEN ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // --- ACADEMIC INFO CARD ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 5))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildAcademicInfo(Icons.bookmark_added_rounded, "Kelas", widget.studentData['kelas'] ?? "-", Colors.blue),
                        Container(height: 40, width: 1, color: Colors.grey.shade200),
                        _buildAcademicInfo(Icons.school_rounded, "Jurusan", widget.studentData['jurusan'] ?? "-", Colors.deepOrange),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- PERSONAL INFORMATION FORM CARD ---
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.contact_mail_rounded, color: Colors.orange.shade500, size: 20),
                                const SizedBox(width: 10),
                                const Text("Personal Info", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Icon(Icons.edit_note_rounded, size: 14, color: Colors.blue.shade600),
                                  const SizedBox(width: 4),
                                  Text("Edit", style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1)),

                        _buildInputField("NIS", _nisController, Icons.badge_rounded),
                        _buildInputField("Full Name", _nameController, Icons.person_rounded),
                        _buildInputField("Born Date", _bornDateController, Icons.cake_rounded),
                        _buildInputField("Born Place", _bornPlaceController, Icons.location_city_rounded),
                        _buildGenderDropdown(),
                        _buildInputField("Email", _emailController, Icons.email_rounded),
                        _buildInputField("Address", _addressController, Icons.home_rounded, isMultiline: true),
                        _buildInputField("Phone", _phoneController, Icons.phone_android_rounded),
                        _buildInputField("School Origin", _schoolOriginController, Icons.account_balance_rounded),

                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE57373), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 0),
                                child: const Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade600, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 4, shadowColor: Colors.orange.withOpacity(0.4)),
                                child: const Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        )
                      ],
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

  Widget _buildAcademicInfo(IconData icon, String label, String value, MaterialColor color) {
    return Column(
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.shade50, shape: BoxShape.circle), child: Icon(icon, color: color.shade500, size: 20)),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
      ],
    );
  }

  // ✅ PERBAIKAN: Mengganti maxLines == 1 dengan !isMultiline
  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: isMultiline ? 3 : 1,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: !isMultiline ? Icon(icon, color: Colors.orange.shade300, size: 20) : null,
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.orange.shade400, width: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gender", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.orange.shade400),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.wc_rounded, color: Colors.orange.shade300, size: 20),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.orange.shade400, width: 1.5)),
            ),
            items: ['Select', 'Male', 'Female'].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)));
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedGender = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }
}