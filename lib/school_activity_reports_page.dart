import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'class_activity_page.dart';

class SchoolActivityReportsPage extends StatelessWidget {
  const SchoolActivityReportsPage({super.key});

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
                  colors: [Colors.teal.shade500, Colors.green.shade700],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Activity Reports",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Available Reports", style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.teal.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(15)),
                              child: Icon(Icons.assignment_rounded, color: Colors.green.shade600, size: 28),
                            ),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: Text("Class Activity Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Show activity that has been recorded in class by teacher. Filter by date and class to generate a detailed summary.",
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ClassActivityFilterPage())),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade600,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: Colors.teal.withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Text("Preview Report", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ),
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
}

class ClassActivityFilterPage extends StatefulWidget {
  const ClassActivityFilterPage({super.key});

  @override
  State<ClassActivityFilterPage> createState() => _ClassActivityFilterPageState();
}

class _ClassActivityFilterPageState extends State<ClassActivityFilterPage> {
  final _dateRangeCtrl = TextEditingController();
  final List<String> _selectedClasses = [];
  late List<String> _availableClasses;

  @override
  void initState() {
    super.initState();
    _availableClasses = ClassActivityData.classes.map((c) => c['name']!).toList();
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
                  colors: [Colors.teal.shade500, Colors.green.shade700],
                ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text("Filter Report", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Date Range"),
                  TextField(
                    controller: _dateRangeCtrl,
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Colors.teal.shade600)),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          _dateRangeCtrl.text = "${DateFormat('dd MMM yyyy').format(picked.start)} - ${DateFormat('dd MMM yyyy').format(picked.end)}";
                        });
                      }
                    },
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: "Select Period",
                      prefixIcon: Icon(Icons.calendar_month_outlined, color: Colors.teal.shade400, size: 22),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.teal.shade400, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildSectionTitle("Select Class"),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      children: _availableClasses.map((className) {
                        bool isSelected = _selectedClasses.contains(className);
                        return CheckboxListTile(
                          title: Text(className, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? Colors.teal.shade800 : Colors.black87)),
                          value: isSelected,
                          activeColor: Colors.teal.shade600,
                          checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                          onChanged: (val) {
                            setState(() {
                              if (val!) {
                                _selectedClasses.add(className);
                              } else {
                                _selectedClasses.remove(className);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              if (_dateRangeCtrl.text.isEmpty || _selectedClasses.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Please select date and classes", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), behavior: SnackBarBehavior.floating));
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) => ClassActivityReportResultPage(
                selectedClasses: _selectedClasses,
                dateRange: _dateRangeCtrl.text,
              )));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              shadowColor: Colors.teal.withOpacity(0.4),
            ),
            child: const Text("Generate Report", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal.shade800)),
  );
}

class ClassActivityReportResultPage extends StatelessWidget {
  final List<String> selectedClasses;
  final String dateRange;

  const ClassActivityReportResultPage({super.key, required this.selectedClasses, required this.dateRange});

  void _exportPdf(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            SizedBox(width: 15),
            Text("Generating PDF document..."),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text("PDF Report exported successfully!"), behavior: SnackBarBehavior.floating));
    });
  }

  void _shareReport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Share Report via", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _shareOption(Icons.message_rounded, "WhatsApp", Colors.green),
                _shareOption(Icons.email_rounded, "Email", Colors.redAccent),
                _shareOption(Icons.copy_rounded, "Copy Link", Colors.blue),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _shareOption(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(radius: 25, backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredActivities = [];

    ClassActivityData.allActivities.forEach((key, list) {
      for (var className in selectedClasses) {
        if (key.startsWith(className)) {
          filteredActivities.addAll(list);
        }
      }
    });

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
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.teal.shade500, Colors.green.shade700]),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text("Report Result", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
            ),
            actions: [
              IconButton(onPressed: () => _shareReport(context), icon: const Icon(Icons.share_rounded, color: Colors.white)),
              IconButton(onPressed: () => _exportPdf(context), icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white)),
              const SizedBox(width: 5),
            ],
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.date_range_rounded, size: 16, color: Colors.teal.shade600),
                      const SizedBox(width: 8),
                      Text(dateRange, style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedClasses.map((c) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.shade100)),
                      child: Text(c, style: TextStyle(fontSize: 11, color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: filteredActivities.isEmpty
                ? SliverToBoxAdapter(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Icon(Icons.folder_off_rounded, size: 80, color: Colors.grey.shade300),
                    const SizedBox(height: 15),
                    Text("No activities found", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = filteredActivities[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: InkWell(
                      onTap: () => _showAttendanceDetail(context, item),
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(item['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal.shade800), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                Icon(Icons.chevron_right_rounded, size: 20, color: Colors.teal.shade300),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['description'], style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    _buildTimeInfo(Icons.calendar_today_rounded, item['date'], Colors.blue),
                                    const SizedBox(width: 20),
                                    _buildTimeInfo(Icons.access_time_filled_rounded, item['time'], Colors.orange),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: filteredActivities.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(IconData icon, String text, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color.shade600),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 10, color: color.shade800, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showAttendanceDetail(BuildContext context, Map<String, dynamic> activity) {
    final List attendance = activity['attendance'] as List;

    int presentCount = attendance.where((s) => s['present'] == true).length;
    int absentCount = attendance.length - presentCount;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text(activity['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatBadge("Present", presentCount.toString(), Colors.green),
                const SizedBox(width: 15),
                _buildStatBadge("Absent", absentCount.toString(), Colors.red),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider()),

            Expanded(
              child: ListView.builder(
                itemCount: attendance.length,
                itemBuilder: (context, index) {
                  final student = attendance[index];
                  bool isPresent = student['present'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: isPresent ? Colors.green.shade50.withOpacity(0.5) : Colors.red.shade50.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: isPresent ? Colors.green.shade100 : Colors.red.shade100)
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isPresent ? Colors.green.shade100 : Colors.red.shade100,
                        child: Text("${index + 1}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isPresent ? Colors.green.shade700 : Colors.red.shade700)),
                      ),
                      title: Text(student['fullName'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      subtitle: Text("ID: ${student['userId']}", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: isPresent ? Colors.green.shade500 : Colors.red.shade500, borderRadius: BorderRadius.circular(10)),
                        child: Text(isPresent ? "Present" : "Absent", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(String label, String count, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: color.shade200)),
      child: Row(
        children: [
          Icon(label == "Present" ? Icons.check_circle_rounded : Icons.cancel_rounded, size: 14, color: color.shade600),
          const SizedBox(width: 6),
          Text("$count $label", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color.shade700)),
        ],
      ),
    );
  }
}