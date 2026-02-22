import 'package:flutter/material.dart';
import 'package:school_management/cbt_report_page.dart';
import 'package:school_management/monitoring_exam_page.dart';
import 'student_list_page.dart';
import 'home_page.dart';
import 'teacher_list_page.dart';
import 'teacher_certificate_page.dart';
import 'teacher_performance_page.dart';
import 'announcement_page.dart';
import 'class_activity_page.dart';
import 'school_activity_reports_page.dart';
import 'question_library_page.dart';
import 'exam_management_page.dart';
import 'exam_period_page.dart';
import 'dart:math' as math;

class SidebarMenu extends StatefulWidget {
  const SidebarMenu({super.key});

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _selectedIndex = -1;
  
  bool _isStudentExpanded = false;
  bool _isTeacherExpanded = false;
  bool _isCBTExpanded = false;
  bool _isStaffExpanded = false;
  bool _isAttendanceExpanded = false;
  bool _isBankMiniExpanded = false;
  bool _isELearningExpanded = false;
  bool _isSchoolActivityExpanded = false;

  final List<String> _studentSubMenus = [
    "Student Information",
  ];

  final List<String> _teacherSubMenus = [
    "Teacher Information",
    "Teacher Certificate",
    "Teacher Performance",
  ];

  final List<String> _cbtSubMenus = [
    "Question Library",
    "Exam Management",
    "Exam Period",
    "Monitoring Exam",
    "CBT Reports",
  ];

  final List<String> _staffSubMenus = [
    "Staff Information",
  ];

  final List<String> _attendanceSubMenus = [
    "Record Attendance",
    "Class Activity",
    "Attendance Reports",
  ];

  final List<String> _bankMiniSubMenus = [
    "My Account",
    "Transaction",
    "Bank Mini Reports",
    "Print Out",
  ];

  final List<String> _eLearningSubMenus = [
    "E-Learning Class",
    "E-Learning Reports",
  ];

  final List<String> _schoolActivitySubMenus = [
    "Announcement",
    "Class Activity",
    "School Activity Reports",
  ];

  final List<Map<String, dynamic>> _menuItems = [
    {
      "title": "Home",
      "colors": [const Color(0xFF4FC3F7), const Color(0xFF1976D2)],
      "patternColors": [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
    },
    {
      "title": "Teacher",
      "colors": [const Color(0xFFFF4081), const Color(0xFFC2185B)],
      "patternColors": [
        const Color(0xFF8E24AA).withOpacity(0.25),
        const Color(0xFFFFB300).withOpacity(0.25),
        const Color(0xFFF06292).withOpacity(0.25),
      ],
    },
    {
      "title": "Student",
      "colors": [const Color(0xFFFFA726), const Color(0xFFF57C00)],
      "patternColors": [
        const Color(0xFFE91E63).withOpacity(0.2),
        const Color(0xFFFFEB3B).withOpacity(0.2),
        Colors.white.withOpacity(0.15),
      ],
    },
    {
      "title": "School Activity",
      "colors": [const Color(0xFF4DB6AC), const Color(0xFF00796B)],
      "patternColors": [
        const Color(0xFF004D40).withOpacity(0.2),
        const Color(0xFF80CBC4).withOpacity(0.15),
      ],
    },
    {
      "title": "CBT",
      "colors": [const Color(0xFFC0A060), const Color(0xFFD0D0D0)],
      "patternColors": [
        const Color(0xFF8D6E63).withOpacity(0.2),
        const Color(0xFF5D4037).withOpacity(0.15),
      ],
    },
    {
      "title": "Staff",
      "colors": [const Color(0xFF708090), const Color(0xFFD0D0D0)],
      "patternColors": [
        const Color(0xFF37474F).withOpacity(0.2),
        const Color(0xFF546E7A).withOpacity(0.15),
      ],
    },
    {
      "title": "Attendance",
      "colors": [const Color(0xFF40C4FF), const Color(0xFFFF5722)],
      "patternColors": [
        const Color(0xFFFFEB3B).withOpacity(0.2),
        const Color(0xFFE91E63).withOpacity(0.2),
        const Color(0xFF03A9F4).withOpacity(0.2),
      ],
    },
    {
      "title": "Bank Mini",
      "colors": [const Color(0xFFF06292), const Color(0xFFD81B60)],
      "patternColors": [
        const Color(0xFF7B1FA2).withOpacity(0.2),
        const Color(0xFFFFC107).withOpacity(0.2),
        Colors.white.withOpacity(0.15),
      ],
    },
    {
      "title": "E-Learning",
      "colors": [const Color(0xFF9575CD), const Color(0xFF512DA8)],
      "patternColors": [
        const Color(0xFF00BCD4).withOpacity(0.2),
        const Color(0xFFFF4081).withOpacity(0.2),
        Colors.white.withOpacity(0.15),
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getExpandedHeight(String title) {
    switch (title) {
      case "Student": return 180.0;
      case "Teacher": return 280.0;
      case "CBT": return 380.0;
      case "Attendance": return 280.0;
      case "Bank Mini": return 320.0;
      case "E-Learning": return 240.0;
      case "Staff": return 180.0;
      case "School Activity": return 240.0;
      default: return 120.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E44AD), Color(0xFF6C3483)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: CustomPaint(
              size: Size.infinite,
              painter: DrawerBackgroundPainter(),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.menu, color: Colors.white, size: 28),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("SMK", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Islamiyah", style: TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.search, color: Colors.white, size: 24),
                      const SizedBox(width: 15),
                      const Icon(Icons.notifications_none, color: Colors.white, size: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: SizedBox(
                        height: 1800, 
                        child: Stack(
                          children: _buildMenuItems(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    List<Widget> list = [];
    double currentTop = 0;

    for (int i = 0; i < _menuItems.length; i++) {
      final item = _menuItems[i];
      final title = item['title'];
      
      final isExpanded = (title == "Student" && _isStudentExpanded) || 
                         (title == "Teacher" && _isTeacherExpanded) ||
                         (title == "CBT" && _isCBTExpanded) ||
                         (title == "Staff" && _isStaffExpanded) ||
                         (title == "Attendance" && _isAttendanceExpanded) ||
                         (title == "Bank Mini" && _isBankMiniExpanded) ||
                         (title == "E-Learning" && _isELearningExpanded) ||
                         (title == "School Activity" && _isSchoolActivityExpanded);

      list.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutBack,
          top: currentTop,
          left: 0,
          child: _buildAnimatedItem(i, isExpanded),
        ),
      );

      if (isExpanded) {
        currentTop += _getExpandedHeight(title) - 30.0; 
      } else {
        currentTop += 85.0;
      }
    }
    return list;
  }

  Widget _buildAnimatedItem(int index, bool isExpanded) {
    final item = _menuItems[index];
    final animation = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        index * 0.05,
        0.5 + (index * 0.05),
        curve: Curves.easeOutCubic,
      ),
    ));

    return SlideTransition(
      position: animation,
      child: _buildCard(item['title'], item['colors'], item['patternColors'], index, isExpanded),
    );
  }

  Widget _buildCard(String title, List<Color> colors, List<Color> patternColors, int index, bool isExpanded) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.8;
    double cardWidth = drawerWidth * 0.85 - (index * 8);
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (title == "Student") {
            _isStudentExpanded = !_isStudentExpanded;
            if (_isStudentExpanded) { _isTeacherExpanded = false; _isCBTExpanded = false; _isStaffExpanded = false; _isAttendanceExpanded = false; _isBankMiniExpanded = false; _isELearningExpanded = false; _isSchoolActivityExpanded = false; }
          } else if (title == "Teacher") {
            _isTeacherExpanded = !_isTeacherExpanded;
            if (_isTeacherExpanded) { _isStudentExpanded = false; _isCBTExpanded = false; _isStaffExpanded = false; _isAttendanceExpanded = false; _isBankMiniExpanded = false; _isELearningExpanded = false; _isSchoolActivityExpanded = false; }
          } else if (title == "CBT") {
            _isCBTExpanded = !_isCBTExpanded;
            if (_isCBTExpanded) { _isStudentExpanded = false; _isTeacherExpanded = false; _isStaffExpanded = false; _isAttendanceExpanded = false; _isBankMiniExpanded = false; _isELearningExpanded = false; _isSchoolActivityExpanded = false; }
          } else if (title == "Staff") {
            _isStaffExpanded = !_isStaffExpanded;
            if (_isStaffExpanded) { _isStudentExpanded = false; _isTeacherExpanded = false; _isCBTExpanded = false; _isStaffExpanded = false; _isAttendanceExpanded = false; _isBankMiniExpanded = false; _isELearningExpanded = false; _isSchoolActivityExpanded = false; }
          } else if (title == "Attendance") {
            _isAttendanceExpanded = !_isAttendanceExpanded;
            if (_isAttendanceExpanded) { _isStudentExpanded = false; _isTeacherExpanded = false; _isCBTExpanded = false; _isStaffExpanded = false; _isBankMiniExpanded = false; _isELearningExpanded = false; _isSchoolActivityExpanded = false; }
          } else if (title == "School Activity") {
            _isSchoolActivityExpanded = !_isSchoolActivityExpanded;
            if (_isSchoolActivityExpanded) { _isStudentExpanded = false; _isTeacherExpanded = false; _isCBTExpanded = false; _isStaffExpanded = false; _isAttendanceExpanded = false; _isBankMiniExpanded = false; _isELearningExpanded = false; }
          } else if (title == "Bank Mini") {
            _isBankMiniExpanded = !_isBankMiniExpanded;
            if (_isBankMiniExpanded) { _isStudentExpanded = false; _isTeacherExpanded = false; _isCBTExpanded = false; _isStaffExpanded = false; _isAttendanceExpanded = false; _isBankMiniExpanded = false; _isELearningExpanded = false; _isSchoolActivityExpanded = false; }
          } else if (title == "E-Learning") {
            _isELearningExpanded = !_isELearningExpanded;
            if (_isELearningExpanded) { _isStudentExpanded = false; _isTeacherExpanded = false; _isCBTExpanded = false; _isStaffExpanded = false; _isAttendanceExpanded = false; _isBankMiniExpanded = false; _isSchoolActivityExpanded = false; }
          } else if (title == "Home") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          }
          _selectedIndex = isSelected ? -1 : index;
        });
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: isSelected ? 1.05 : 1.0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            alignment: Alignment.centerLeft,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: cardWidth,
          height: isExpanded ? _getExpandedHeight(title) : 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                  child: CustomPaint(
                    painter: _getCardPatternPainter(index, patternColors),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        shadows: [Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 3)],
                      ),
                    ),
                    if (isExpanded) ...[
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (title == "Student")
                                ..._studentSubMenus.map((subMenu) => _buildSubMenuItem(subMenu, () {
                                  if (subMenu == "Student Information") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentListPage()));
                                  }
                                })),
                              if (title == "Teacher")
                                ..._teacherSubMenus.map((subMenu) => _buildSubMenuItem(subMenu, () {
                                  if (subMenu == "Teacher Information") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TeacherListPage()));
                                  } else if (subMenu == "Teacher Certificate") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TeacherCertificatePage()));
                                  } else if (subMenu == "Teacher Performance") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TeacherPerformancePage()));
                                  }
                                })),
                              if (title == "CBT")
                                ..._cbtSubMenus.map((subMenu) => _buildSubMenuItem(subMenu, () {
                                  if (subMenu == "Question Library") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionLibraryPage()));
                                  }
                                  if (subMenu == "Exam Management") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ExamManagementPage()));
                                  }
                                  if (subMenu == "Exam Period") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ExamPeriodPage()));
                                  }
                                  if (subMenu == "Monitoring Exam") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MonitoringExamPage()));
                                  }
                                  if (subMenu == "CBT Reports") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CBTReportsPage()));
                                  }
                                })),
                              if (title == "Staff")
                                ..._staffSubMenus.map((subMenu) => _buildSubMenuItem(subMenu, () {
                                  // TODO: Staff navigation
                                })),
                              if (title == "Attendance")
                                ..._attendanceSubMenus.map((subMenu) => _buildSubMenuItem(subMenu, () {
                                  // TODO: Attendance navigation
                                })),
                              if (title == "School Activity")
                                ..._schoolActivitySubMenus.map((subMenu) => _buildSubMenuItem(subMenu, () {
                                  if (subMenu == "Announcement") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AnnouncementPage()));
                                  } else if (subMenu == "Class Activity") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ClassActivityPage()));
                                  } else if (subMenu == "School Activity Reports") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SchoolActivityReportsPage()));
                                  }
                                })),
                              if (title == "Bank Mini")
                                ..._bankMiniSubMenus.map((subMenu) => _buildSubMenuItem(subMenu, () {
                                  // TODO: Bank Mini navigation
                                })),
                              if (title == "E-Learning")
                                ..._eLearningSubMenus.map((subMenu) => _buildSubMenuItem(subMenu, () {
                                  // TODO: E-Learning navigation
                                })),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubMenuItem(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Text(
          title,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  CustomPainter _getCardPatternPainter(int index, List<Color> colors) {
    switch (index % 8) {
      case 0: return ConcentricCirclesPainter(colors: colors);
      case 1: return ThickDiagonalLinesPainter(colors: colors);
      case 2: return ZigZagPainter(colors: colors);
      case 3: return MosaicPatternPainter(colors: colors);
      case 4: return WavePainter(colors: colors);
      case 5: return ScatteredShapesPainter(colors: colors);
      case 6: return CrossPainter(colors: colors);
      default: return ScatteredShapesPainter(colors: colors);
    }
  }
}

class DrawerBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    double radius = 40;
    for (double i = 0; i < size.width; i += radius * 3) {
      for (double j = 0; j < size.height; j += radius * 3) {
        canvas.drawCircle(Offset(i, j), radius, paint);
        canvas.drawCircle(Offset(i + radius * 1.5, j + radius * 1.5), radius * 0.7, paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ConcentricCirclesPainter extends CustomPainter {
  final List<Color> colors;
  ConcentricCirclesPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Offset center = Offset(size.width * 0.1, size.height * 0.5);
    for (int i = 0; i < 12; i++) {
      paint.color = colors[i % colors.length];
      double r = 10.0 + (i * 12.0);
      canvas.drawCircle(center, r, paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ThickDiagonalLinesPainter extends CustomPainter {
  final List<Color> colors;
  ThickDiagonalLinesPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    var rng = math.Random(42);
    for (int i = 0; i < 35; i++) {
      paint.color = colors[rng.nextInt(colors.length)];
      double startX = rng.nextDouble() * size.width;
      double startY = rng.nextDouble() * size.height;
      double length = rng.nextDouble() * 40 + 20;
      canvas.drawLine(
        Offset(startX, startY), 
        Offset(startX + length, startY + length), 
        paint
      );
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ZigZagPainter extends CustomPainter {
  final List<Color> colors;
  ZigZagPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    var rng = math.Random(44);
    for (int i = 0; i < 15; i++) {
      paint.color = colors[rng.nextInt(colors.length)];
      double x = rng.nextDouble() * size.width;
      double y = rng.nextDouble() * size.height;
      
      Path path = Path();
      path.moveTo(x, y);
      path.lineTo(x + 10, y + 10);
      path.lineTo(x + 20, y);
      path.lineTo(x + 30, y + 10);
      canvas.drawPath(path, paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WavePainter extends CustomPainter {
  final List<Color> colors;
  WavePainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    var rng = math.Random(45);
    for (int i = 0; i < 8; i++) {
      paint.color = colors[rng.nextInt(colors.length)];
      double yBase = rng.nextDouble() * size.height;
      
      Path path = Path();
      path.moveTo(0, yBase);
      for (double x = 0; x < size.width; x += 20) {
        path.quadraticBezierTo(x + 10, yBase + 15, x + 20, yBase);
      }
      canvas.drawPath(path, paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CrossPainter extends CustomPainter {
  final List<Color> colors;
  CrossPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 2;
    var rng = math.Random(46);
    for (int i = 0; i < 40; i++) {
      paint.color = colors[rng.nextInt(colors.length)];
      double x = rng.nextDouble() * size.width;
      double y = rng.nextDouble() * size.height;
      double s = 6;
      
      canvas.drawLine(Offset(x - s, y), Offset(x + s, y), paint);
      canvas.drawLine(Offset(x, y - s), Offset(x, y + s), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScatteredShapesPainter extends CustomPainter {
  final List<Color> colors;
  ScatteredShapesPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    var rng = math.Random(42);
    for (int i = 0; i < 30; i++) {
      paint.color = colors[rng.nextInt(colors.length)];
      double x = rng.nextDouble() * size.width;
      double y = rng.nextDouble() * size.height;
      double s = rng.nextDouble() * 8 + 3;
      if (rng.nextBool()) {
        canvas.drawCircle(Offset(x, y), s / 2, paint);
      } else {
        canvas.drawRect(Rect.fromCenter(center: Offset(x, y), width: s, height: s), paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MosaicPatternPainter extends CustomPainter {
  final List<Color> colors;
  MosaicPatternPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    double step = 30;
    int colorIdx = 0;
    for (double i = 0; i < size.width; i += step) {
      for (double j = 0; j < size.height; j += step) {
        if ((i + j) % (step * 2) == 0) {
          paint.color = colors[colorIdx % colors.length];
          Path path = Path();
          path.moveTo(i, j);
          path.lineTo(i + step, j);
          path.lineTo(i, j + step);
          path.close();
          canvas.drawPath(path, paint);
          colorIdx++;
        }
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
