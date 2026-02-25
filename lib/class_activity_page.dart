import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassActivityData {
  static List<Map<String, String>> classes = [
    {"name": "XII AK 1", "grade": "Grade XII", "year": "2025"},
    {"name": "XII AK 2", "grade": "Grade XII", "year": "2025"},
    {"name": "XII BDP 1", "grade": "Grade XII", "year": "2025"},
    {"name": "XII BDP 2", "grade": "Grade XII", "year": "2025"},
    {"name": "XII DKV 1", "grade": "Grade XII", "year": "2025"},
    {"name": "XII KUL 1", "grade": "Grade XII", "year": "2025"},
    {"name": "XII TKJ 1", "grade": "Grade XII", "year": "2025"},
    {"name": "X AK 1", "grade": "Grade X", "year": "2025"},
  ];

  static Map<String, List<Map<String, String>>> classSubjectsData = {
    "XII AK 1": [
      {"name": "Administrasi Pajak", "code": "ADPA_XII-AK-1", "teacher": "Elya Julowati, S.Pd"},
      {"name": "Akuntansi Keuangan", "code": "AKEU", "teacher": "Elya Julowati, S.Pd"},
      {"name": "Akuntansi Perusahaan Jasa Dagang dan Manufaktur", "code": "APJDM", "teacher": "Elya Julowati, S.Pd"},
      {"name": "Bahasa Indonesia", "code": "BINDO", "teacher": "Yuniarti Nurhikmah, S.Pd"},
      {"name": "Bahasa Inggris", "code": "BING", "teacher": "Drs.H.Amel Darmawel"},
      {"name": "Komputer Akuntansi", "code": "MYOB", "teacher": "Mohammad Aris Azis, S.E., M.M"},
      {"name": "Praktek Akuntansi Lembaga", "code": "PAL", "teacher": "Nurmaely, S.E.I"},
      {"name": "Pendidikan Pancasila", "code": "PPKN", "teacher": "Salmawati H., S.H"},
      {"name": "Pendidikan Agama Islam", "code": "PAI", "teacher": "Rahmah Rahim, S.Sos.I"},
      {"name": "Matematika", "code": "MTK", "teacher": "Zikri Putri Kasari, S.Pd"},
      {"name": "Konsentrasi Keahlian", "code": "KK", "teacher": "Elya Juliawati, S.Pd"},
    ],
    "XII AK 2": [
      {"name": "Administrasi Pajak", "code": "AP", "teacher": "Elya Julowati, S.Pd"},
      {"name": "Akuntansi Keuangan", "code": "AKBU", "teacher": "Dian Pratikawati, S.E., M.M"},
      {"name": "Komputer Akuntansi", "code": "MYOB", "teacher": "Nurmaely, S.E.I"},
      {"name": "Praktek Akuntansi Lembaga", "code": "PAL", "teacher": "Nurmaely, S.E.I"},
      {"name": "Pendidikan Agama Islam", "code": "PAI", "teacher": "Rakhmah Rahim, S.Sos.I"},
      {"name": "Konsentrasi Keahlian", "code": "KK", "teacher": "Elya Juliawati, S.Pd"},
      {"name": "Produk Kreatif dan Kewirausahaan", "code": "PKK", "teacher": "Yuni Zalfita, S.Pd"},
      {"name": "Pendidikan Pancasila", "code": "PPKN", "teacher": "Salmawati H., S.H"},
    ],
    "XII BDP 1": [
      {"name": "BISNIS ONLINE", "code": "BON", "teacher": "Fachrur Rozi, S.M"},
      {"name": "Bahasa Indonesia", "code": "BINDO", "teacher": "Hj. Nurfadilah, S.Pd"},
      {"name": "Bahasa Inggris", "code": "BING", "teacher": "Teguh Supriyadi, S.Pd"},
      {"name": "Matematika", "code": "MTK", "teacher": "Drs. H. Mukija, HS.S.Pd.,M.M"},
      {"name": "Konsentrasi Keahlian", "code": "KK", "teacher": "Helvi Silvia, S.Pd"},
      {"name": "Pendidikan Agama Islam", "code": "PAI", "teacher": "Rahma Rahim, S.Sos.I"},
      {"name": "Produk Kreatif dan Kewirausahaan", "code": "PKK", "teacher": "Zikri Putri Kasari, S.Pd"},
    ],
    "XII BDP 2": [
      {"name": "BISNIS ONLINE", "code": "BON", "teacher": "Fachrur Rozi, S.M"},
      {"name": "Bahasa Indonesia", "code": "BINDO", "teacher": "Hj. Nurfadilah, S.Pd"},
      {"name": "Produk Kreatif & Kewirausahaan", "code": "PKK", "teacher": "Zikri Putri Kasari, S.Pd"},
      {"name": "Pendidikan Pancasila", "code": "PPKN", "teacher": "Salmawati H., S.H"},
    ],
  };

  static Map<String, List<Map<String, dynamic>>> allActivities = {};
}

class ClassActivityPage extends StatefulWidget {
  const ClassActivityPage({super.key});

  @override
  State<ClassActivityPage> createState() => _ClassActivityPageState();
}

class _ClassActivityPageState extends State<ClassActivityPage> {
  final List<Color> _iconColors = [
    Colors.blue.shade400,
    Colors.orange.shade400,
    Colors.pink.shade400,
    Colors.green.shade400,
    Colors.purple.shade400,
    Colors.red.shade400,
  ];

  void _showAddClassDialog() {
    final nameCtrl = TextEditingController();
    final gradeCtrl = TextEditingController();
    final yearCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.class_rounded, color: Colors.indigo.shade500),
            const SizedBox(width: 10),
            const Text("Add New Class", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogInput("Class Name", nameCtrl, Icons.meeting_room_rounded),
            const SizedBox(height: 12),
            _buildDialogInput("Grade", gradeCtrl, Icons.grade_rounded),
            const SizedBox(height: 12),
            _buildDialogInput("Year", yearCtrl, Icons.calendar_today_rounded),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade500, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  ClassActivityData.classes.add({
                    "name": nameCtrl.text,
                    "grade": gradeCtrl.text,
                    "year": yearCtrl.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildDialogInput(String hint, TextEditingController ctrl, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.indigo.shade300, size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

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
                  colors: [Colors.indigo.shade400, Colors.teal.shade500],
                ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text("Class Activity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: IconButton(icon: const Icon(Icons.add_rounded, color: Colors.white, size: 28), onPressed: _showAddClassDialog),
              ),
              const SizedBox(width: 10),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = ClassActivityData.classes[index];
                  final Color currentIconColor = _iconColors[index % _iconColors.length];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 8))],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: currentIconColor.withOpacity(0.1),
                                      shape: BoxShape.circle
                                  ),
                                  child: Icon(Icons.school_rounded, color: currentIconColor, size: 28),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                    item['name']!,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142)),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.indigo.shade50,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Text(
                                      item['grade']!,
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.indigo.shade700)
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.flag_rounded, size: 12, color: Colors.grey.shade400),
                                    const SizedBox(width: 4),
                                    Text("Year: ${item['year']!}", style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectListPage(className: item['name']!)));
                            setState(() {});
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade500,
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Select Class", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: ClassActivityData.classes.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectListPage extends StatefulWidget {
  final String className;
  const SubjectListPage({super.key, required this.className});

  @override
  State<SubjectListPage> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
  final List<Color> _subjectColors = [
    Colors.teal.shade500,
    Colors.deepOrange.shade400,
    Colors.lightBlue.shade500,
    Colors.pink.shade400,
    Colors.amber.shade600,
  ];

  void _showAddSubjectDialog() {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final teacherCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.library_books_rounded, color: Colors.indigo.shade500),
            const SizedBox(width: 10),
            const Text("Add Subject", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogInput("Subject Name", nameCtrl, Icons.menu_book_rounded),
            const SizedBox(height: 12),
            _buildDialogInput("Subject Code", codeCtrl, Icons.code_rounded),
            const SizedBox(height: 12),
            _buildDialogInput("Teacher Name", teacherCtrl, Icons.person_rounded),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade500, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  if (!ClassActivityData.classSubjectsData.containsKey(widget.className)) {
                    ClassActivityData.classSubjectsData[widget.className] = [];
                  }
                  ClassActivityData.classSubjectsData[widget.className]!.add({
                    "name": nameCtrl.text,
                    "code": codeCtrl.text,
                    "teacher": teacherCtrl.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildDialogInput(String hint, TextEditingController ctrl, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: Colors.indigo.shade300, size: 20), filled: true, fillColor: Colors.grey.shade50, contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjectList = ClassActivityData.classSubjectsData[widget.className] ?? [];
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
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.indigo.shade400, Colors.teal.shade500]),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 60, bottom: 20),
                title: Text("Subjects - ${widget.className}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
            ),
            actions: [
              Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: IconButton(icon: const Icon(Icons.add_rounded, color: Colors.white, size: 28), onPressed: _showAddSubjectDialog)),
              const SizedBox(width: 10),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: subjectList.isEmpty
                ? SliverToBoxAdapter(child: Center(child: Padding(padding: const EdgeInsets.only(top: 50), child: Column(children: [Icon(Icons.library_books_rounded, size: 80, color: Colors.grey.shade300), const SizedBox(height: 15), Text("No subjects for this class yet.", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold))]))))
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = subjectList[index];
                  final currentColor = _subjectColors[index % _subjectColors.length];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 8))]),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityListPage(subjectName: item['name']!, subjectCode: "${widget.className}_${item['code']}")));
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(color: currentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                                child: Icon(Icons.menu_book_rounded, color: currentColor, size: 28)
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2D3142))),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)), child: Text(item['code']!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade700))),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.person_pin_circle_rounded, size: 14, color: Colors.indigo.shade400),
                                      const SizedBox(width: 4),
                                      Expanded(child: Text(item['teacher']!.isEmpty ? "Teacher Not Assigned" : item['teacher']!, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: subjectList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityListPage extends StatefulWidget {
  final String subjectName;
  final String subjectCode;
  const ActivityListPage({super.key, required this.subjectName, required this.subjectCode});

  @override
  State<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  @override
  Widget build(BuildContext context) {
    final activities = ClassActivityData.allActivities[widget.subjectCode] ?? [];

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
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.indigo.shade400, Colors.teal.shade500]), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
              child: const FlexibleSpaceBar(titlePadding: EdgeInsets.only(left: 60, bottom: 20), title: Text("Activities", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white))),
            ),
            leading: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context))),
            actions: [
              Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: IconButton(icon: const Icon(Icons.add_rounded, color: Colors.white, size: 28), onPressed: () async {
                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityFormPage(subjectName: widget.subjectName, subjectCode: widget.subjectCode)));
                if (result != null) {
                  setState(() {
                    if (!ClassActivityData.allActivities.containsKey(widget.subjectCode)) {
                      ClassActivityData.allActivities[widget.subjectCode] = [];
                    }
                    ClassActivityData.allActivities[widget.subjectCode]!.add(result);
                  });
                }
              })),
              const SizedBox(width: 10),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Icon(Icons.info_outline_rounded, color: Colors.indigo.shade400, size: 20), const SizedBox(width: 8), const Text("Subject Info", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)))]),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
                  _detailInfo("Code", widget.subjectCode),
                  const SizedBox(height: 6),
                  _detailInfo("Name", widget.subjectName),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: activities.isEmpty
                ? SliverToBoxAdapter(child: Center(child: Padding(padding: const EdgeInsets.only(top: 30), child: Column(children: [Icon(Icons.assignment_turned_in_rounded, size: 60, color: Colors.grey.shade300), const SizedBox(height: 10), Text("No activities yet. Tap '+' to add.", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold))]))))
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = activities[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                    child: InkWell(
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityFormPage(subjectName: widget.subjectName, subjectCode: widget.subjectCode, existingActivity: item)));
                        if (result != null) {
                          setState(() { ClassActivityData.allActivities[widget.subjectCode]![index] = result; });
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ID: ${item['id']}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.indigo.shade700)),
                                Icon(Icons.edit_note_rounded, color: Colors.indigo.shade300, size: 20)
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142))),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(6)), child: Row(children: [Icon(Icons.calendar_today_rounded, size: 12, color: Colors.teal.shade600), const SizedBox(width: 4), Text(item['date'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.teal.shade800))])),
                                const SizedBox(width: 10),
                                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(6)), child: Row(children: [Icon(Icons.access_time_filled_rounded, size: 12, color: Colors.orange.shade600), const SizedBox(width: 4), Text(item['time'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange.shade800))])),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: activities.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _detailInfo(String label, String value) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 80, child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600))), const Text(": ", style: TextStyle(color: Colors.grey)), Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)))]);
}

class ActivityFormPage extends StatefulWidget {
  final String subjectName;
  final String subjectCode;
  final Map<String, dynamic>? existingActivity;
  const ActivityFormPage({super.key, required this.subjectName, required this.subjectCode, this.existingActivity});

  @override
  State<ActivityFormPage> createState() => _ActivityFormPageState();
}

class _ActivityFormPageState extends State<ActivityFormPage> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _startTimeCtrl = TextEditingController();
  final _endTimeCtrl = TextEditingController();

  List<Map<String, dynamic>> _attendance = [
    {"userId": "23646176", "fullName": "Ahmad Trias Nur hakim", "present": true},
    {"userId": "23646177", "fullName": "AISYAH BADARIAH", "present": true},
    {"userId": "23646178", "fullName": "ALBAINA APRIDHA JANNAH", "present": true},
    {"userId": "23646179", "fullName": "Caren Ricky Ferdina", "present": true},
    {"userId": "23646181", "fullName": "CHIKA EMALINA ZIRLY", "present": true},
    {"userId": "23646183", "fullName": "citra lestari", "present": true},
    {"userId": "23646182", "fullName": "Desiana Latifah", "present": true},
    {"userId": "23646184", "fullName": "Fadiyah Amelia Putri", "present": true},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingActivity != null) {
      _nameCtrl.text = widget.existingActivity!['name'];
      _descCtrl.text = widget.existingActivity!['description'];
      _dateCtrl.text = widget.existingActivity!['date'];
      final times = widget.existingActivity!['time'].split(" - ");
      if (times.length == 2) {
        _startTimeCtrl.text = times[0];
        _endTimeCtrl.text = times[1];
      }
      _attendance = List<Map<String, dynamic>>.from(widget.existingActivity!['attendance']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.indigo.shade400, Colors.teal.shade500]), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
        ),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text(widget.existingActivity == null ? "Add Activity" : "Edit Activity", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Icon(Icons.assignment_rounded, color: Colors.indigo.shade500), const SizedBox(width: 8), const Text("Activity Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1)),
                  _buildFormInput("Activity Name", _nameCtrl, Icons.title_rounded),
                  const SizedBox(height: 15),
                  _buildFormInput("Description", _descCtrl, Icons.description_rounded, maxLines: 3),
                  const SizedBox(height: 15),
                  _buildFormInput("Date", _dateCtrl, Icons.calendar_month_rounded, isDate: true),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: _buildFormInput("Start Time", _startTimeCtrl, Icons.access_time_rounded, isTime: true)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildFormInput("End Time", _endTimeCtrl, Icons.access_time_filled_rounded, isTime: true)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Icon(Icons.how_to_reg_rounded, color: Colors.indigo.shade500), const SizedBox(width: 8), const Text("Student Attendance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                          child: Row(children: [
                            const SizedBox(width: 25, child: Text("#", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Expanded(child: Text("Student Name", style: TextStyle(color: Colors.indigo.shade800, fontWeight: FontWeight.bold, fontSize: 12))),
                            Text("Present", style: TextStyle(color: Colors.indigo.shade800, fontWeight: FontWeight.bold, fontSize: 12)),
                          ]),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _attendance.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child: Row(children: [
                              SizedBox(width: 25, child: Text("${index + 1}", style: const TextStyle(fontSize: 12, color: Colors.grey))),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_attendance[index]['fullName'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), Text(_attendance[index]['userId'], style: TextStyle(fontSize: 10, color: Colors.grey.shade500))])),
                              Checkbox(
                                  value: _attendance[index]['present'],
                                  activeColor: Colors.indigo.shade500,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  onChanged: (v) => setState(() => _attendance[index]['present'] = v!)
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: Row(
          children: [
            Expanded(flex: 1, child: TextButton(onPressed: () => Navigator.pop(context), style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.grey.shade100, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))),
            const SizedBox(width: 15),
            Expanded(flex: 2, child: ElevatedButton(
              onPressed: () {
                if (_nameCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Activity Name cannot be empty"), backgroundColor: Colors.red));
                  return;
                }
                Navigator.pop(context, {
                  "id": widget.existingActivity?['id'] ?? "ACT${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
                  "name": _nameCtrl.text,
                  "description": _descCtrl.text,
                  "date": _dateCtrl.text,
                  "time": "${_startTimeCtrl.text} - ${_endTimeCtrl.text}",
                  "attendance": _attendance,
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade500, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 0),
              child: const Text("Save Activity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFormInput(String label, TextEditingController ctrl, IconData icon, {int maxLines = 1, bool isDate = false, bool isTime = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          readOnly: isDate || isTime,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          onTap: () async {
            if (isDate) {
              DateTime? d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
              if (d != null) ctrl.text = DateFormat('dd MMM yyyy').format(d);
            } else if (isTime) {
              TimeOfDay? t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
              if (t != null) ctrl.text = t.format(context);
            }
          },
          decoration: InputDecoration(
            prefixIcon: maxLines == 1 ? Icon(icon, color: Colors.indigo.shade300, size: 20) : null,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.all(15),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.indigo.shade400, width: 1.5)),
          ),
        ),
      ],
    );
  }
}