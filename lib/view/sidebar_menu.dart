import 'package:flutter/material.dart';
import 'package:school_management/attendance_report_page.dart';
import 'package:school_management/bank_account_page.dart';
import 'package:school_management/bank_mini_reports_page.dart';
import 'package:school_management/cbt_report_page.dart';
import 'package:school_management/monitoring_exam_page.dart';
import 'package:school_management/task_assignment_page.dart';
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
import 'staff_information_page.dart';
import 'transaction_list_page.dart';
import 'bank_mini_print_out_page.dart';
import 'e_learning_class_page.dart';
import 'record_attendance_page.dart';

class SidebarMenu extends StatefulWidget {
  const SidebarMenu({super.key});

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  // Menandai menu mana yang sedang aktif (0 = Home)
  final int _selectedIndex = 0;

  final Color _textColor = const Color(0xFF334155); // Warna abu-abu gelap kebiruan elegan
  final Color _iconColor = const Color(0xFF64748B);
  final Color _selectedColor = const Color(0xFF3B82F6); // Biru cerah

  // =========================================================
  // DATA SUBMENU
  // =========================================================
  final List<String> _principalSubMenus = ["Task Assignment"];
  final List<String> _studentSubMenus = ["Student Information"];
  final List<String> _teacherSubMenus = ["Teacher Information", "Teacher Certificate", "Teacher Performance"];
  final List<String> _cbtSubMenus = ["Question Library", "Exam Management", "Exam Period", "Monitoring Exam", "CBT Reports"];
  final List<String> _staffSubMenus = ["Staff Information"];

  // ✅ PERBAIKAN: Memasukkan "Class Activity" ke dalam Attendance
  final List<String> _attendanceSubMenus = ["Record Attendance", "Class Activity", "Attendance Reports"];

  final List<String> _bankMiniSubMenus = ["My Account", "Transaction", "Reports", "Print Out"];
  final List<String> _eLearningSubMenus = ["E-Learning Class", "E-Learning Reports"];

  // ✅ PERBAIKAN: "Class Activity" dihapus dari School Activity
  final List<String> _schoolActivitySubMenus = ["Announcement", "School Activity Reports"];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: Colors.white,
      elevation: 10,
      child: SafeArea(
        child: Column(
          children: [
            // --- HEADER SIDEBAR ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.menu_rounded, color: Colors.black87, size: 28),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "SMK",
                        style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Islamiyah",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.search_rounded, color: Colors.grey.shade700, size: 22),
                  const SizedBox(width: 15),
                  Icon(Icons.notifications_none_rounded, color: Colors.grey.shade700, size: 22),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // --- MENU UTAMA SCROLLABLE ---
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _buildSingleMenuItem(
                        index: 0,
                        title: "Home",
                        icon: Icons.home_outlined,
                        onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())),
                      ),

                      _buildExpandableMenuItem(title: "Principal", icon: Icons.admin_panel_settings_outlined, subMenus: _principalSubMenus),
                      _buildExpandableMenuItem(title: "Teacher", icon: Icons.grid_view_rounded, subMenus: _teacherSubMenus),
                      _buildExpandableMenuItem(title: "Student", icon: Icons.inventory_2_outlined, subMenus: _studentSubMenus),
                      _buildExpandableMenuItem(title: "School Activity", icon: Icons.local_activity_outlined, subMenus: _schoolActivitySubMenus),
                      _buildExpandableMenuItem(title: "CBT", icon: Icons.show_chart_rounded, subMenus: _cbtSubMenus),

                      // Menu Staff dengan Badge Merah "2" Sesuai Desain
                      _buildExpandableMenuItem(title: "Staff", icon: Icons.calendar_today_outlined, subMenus: _staffSubMenus, badgeCount: 2),

                      _buildExpandableMenuItem(title: "Attendance", icon: Icons.access_time_rounded, subMenus: _attendanceSubMenus),
                      _buildExpandableMenuItem(title: "Bank Mini", icon: Icons.payments_outlined, subMenus: _bankMiniSubMenus),
                      _buildExpandableMenuItem(title: "E-Learning", icon: Icons.menu_book_rounded, subMenus: _eLearningSubMenus),
                    ],
                  ),
                ),
              ),
            ),

            // --- BOTTOM MENU (Settings & Logout) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              child: Column(
                children: [
                  _buildSingleMenuItem(
                    index: 98,
                    title: "Settings",
                    icon: Icons.settings_outlined,
                    onTap: () {},
                  ),
                  _buildSingleMenuItem(
                    index: 99,
                    title: "Logout",
                    icon: Icons.logout_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HELPER WIDGETS
  // =========================================================

  // Widget untuk menu yang tidak memiliki anak
  Widget _buildSingleMenuItem({required int index, required String title, required IconData icon, required VoidCallback onTap}) {
    bool isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: isSelected ? _selectedColor.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(icon, color: isSelected ? _selectedColor : _iconColor, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? _selectedColor : _textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Widget untuk menu Accordion yang memiliki Sub-menu
  Widget _buildExpandableMenuItem({required String title, required IconData icon, required List<String> subMenus, int badgeCount = 0}) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, // Hilangkan garis border bawaan ExpansionTile
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 15),
        leading: Icon(icon, color: _iconColor, size: 22),
        iconColor: _iconColor,
        collapsedIconColor: _iconColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: _textColor, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            // Tampilkan Badge Merah jika badgeCount > 0
            if (badgeCount > 0)
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: Color(0xFFF44336), shape: BoxShape.circle),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              )
          ],
        ),
        children: subMenus.map((subMenuTitle) {
          return Padding(
            padding: const EdgeInsets.only(left: 45, right: 15, bottom: 5), // Indentasi ke dalam
            child: ListTile(
              onTap: () => _handleSubMenuNavigation(subMenuTitle),
              dense: true,
              visualDensity: const VisualDensity(vertical: -2), // Merapatkan jarak antar submenu
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: Text(
                subMenuTitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              hoverColor: Colors.grey.shade100,
            ),
          );
        }).toList(),
      ),
    );
  }

  // Logika Navigasi ke Halaman Lain
  void _handleSubMenuNavigation(String subMenu) {
    // Principal
    if (subMenu == "Task Assignment") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskAssignmentPage()));
    } else if (subMenu == "Student Information") Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentListPage()));
    // Teacher
    else if (subMenu == "Teacher Information") Navigator.push(context, MaterialPageRoute(builder: (context) => const TeacherListPage()));
    else if (subMenu == "Teacher Certificate") Navigator.push(context, MaterialPageRoute(builder: (context) => const TeacherCertificatePage()));
    else if (subMenu == "Teacher Performance") Navigator.push(context, MaterialPageRoute(builder: (context) => const TeacherPerformancePage()));
    // CBT
    else if (subMenu == "Question Library") Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionLibraryPage()));
    else if (subMenu == "Exam Management") Navigator.push(context, MaterialPageRoute(builder: (context) => const ExamManagementPage()));
    else if (subMenu == "Exam Period") Navigator.push(context, MaterialPageRoute(builder: (context) => const ExamPeriodPage()));
    else if (subMenu == "Monitoring Exam") Navigator.push(context, MaterialPageRoute(builder: (context) => const MonitoringExamPage()));
    else if (subMenu == "CBT Reports") Navigator.push(context, MaterialPageRoute(builder: (context) => const CBTReportsPage()));
    // Staff
    else if (subMenu == "Staff Information") Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffInformationPage()));

    // ✅ PERBAIKAN: Attendance (Sekarang Class Activity diproses di sini agar lebih terstruktur)
    else if (subMenu == "Record Attendance") Navigator.push(context, MaterialPageRoute(builder: (context) => const RecordAttendancePage()));
    else if (subMenu == "Class Activity") Navigator.push(context, MaterialPageRoute(builder: (context) => const ClassActivityPage()));
    else if (subMenu == "Attendance Reports") Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceReportPage()));

    // School Activity
    else if (subMenu == "Announcement") Navigator.push(context, MaterialPageRoute(builder: (context) => const AnnouncementPage()));
    else if (subMenu == "School Activity Reports") Navigator.push(context, MaterialPageRoute(builder: (context) => const SchoolActivityReportsPage()));

    // Bank Mini
    else if (subMenu == "My Account") Navigator.push(context, MaterialPageRoute(builder: (context) => const BankAccountPage()));
    else if (subMenu == "Transaction") Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionListPage()));
    else if (subMenu == "Reports") Navigator.push(context, MaterialPageRoute(builder: (context) => const BankMiniReportsPage()));
    else if (subMenu == "Print Out") Navigator.push(context, MaterialPageRoute(builder: (context) => const BankMiniPrintOutPage()));

    // E-Learning
    else if (subMenu == "E-Learning Class") Navigator.push(context, MaterialPageRoute(builder: (context) => const ELearningClassPage()));
    else if (subMenu == "E-Learning Reports") { /* TODO: Halaman E-Learning Report */ }
  }
}