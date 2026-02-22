import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'class_activity_page.dart';

class SchoolActivityReportsPage extends StatelessWidget {
  const SchoolActivityReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("School Activity Reports", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Available Reports", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.indigo.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.assignment_rounded, color: Colors.blueAccent),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text("Class Activity Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Show activity that has been recorded in class by teacher. Filter by date and class to generate a detailed summary.",
                    style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ClassActivityFilterPage())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("Preview Report", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Filter Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
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
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(primary: Color(0xFF1A237E)),
                      ),
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
              decoration: InputDecoration(
                hintText: "Select Period", 
                prefixIcon: const Icon(Icons.calendar_month_outlined, size: 20),
                filled: true,
                fillColor: Colors.grey[500]!.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Select Class"),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[500]!.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: _availableClasses.map((className) {
                  return CheckboxListTile(
                    title: Text(className, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    value: _selectedClasses.contains(className),
                    activeColor: const Color(0xFF1A237E),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
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
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_dateRangeCtrl.text.isEmpty || _selectedClasses.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select date and classes")));
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClassActivityReportResultPage(
                    selectedClasses: _selectedClasses,
                    dateRange: _dateRangeCtrl.text,
                  )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  shadowColor: const Color(0xFF1A237E).withOpacity(0.4),
                ),
                child: const Text("Generate Report", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueGrey)),
  );
}

class ClassActivityReportResultPage extends StatelessWidget {
  final List<String> selectedClasses;
  final String dateRange;

  const ClassActivityReportResultPage({super.key, required this.selectedClasses, required this.dateRange});

  // Fungsi Simulasi Export PDF
  void _exportPdf(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            SizedBox(width: 15),
            Text("Generating PDF document..."),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green, content: Text("PDF Report exported successfully!")),
      );
    });
  }

  // Fungsi Simulasi Share
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
                _shareOption(Icons.message, "WhatsApp", Colors.green),
                _shareOption(Icons.email, "Email", Colors.redAccent),
                _shareOption(Icons.copy, "Copy Link", Colors.blue),
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
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
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
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Report Result", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => _shareReport(context), 
            icon: const Icon(Icons.share_outlined, color: Colors.blue)
          ),
          IconButton(
            onPressed: () => _exportPdf(context), 
            icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.red)
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.date_range, size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(dateRange, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedClasses.map((c) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(c, style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                  )).toList(),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: filteredActivities.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open_outlined, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        const Text("No data found", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredActivities.length,
                    itemBuilder: (context, index) {
                      final item = filteredActivities[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => _showAttendanceDetail(context, item),
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4A90E2),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(item['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                                        ),
                                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blueGrey),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(item['description'], style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4)),
                                    const SizedBox(height: 15),
                                    const Divider(),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        _buildTimeInfo(Icons.calendar_today, item['date']),
                                        const SizedBox(width: 20),
                                        _buildTimeInfo(Icons.access_time, item['time']),
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
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.blueAccent),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _showAttendanceDetail(BuildContext context, Map<String, dynamic> activity) {
    final List attendance = activity['attendance'] as List;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text("Attendance: ${activity['name']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: attendance.length,
                itemBuilder: (context, index) {
                  final student = attendance[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: student['present'] ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        child: Text("${index + 1}", style: TextStyle(fontSize: 12, color: student['present'] ? Colors.green : Colors.red)),
                      ),
                      title: Text(student['fullName'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      trailing: Icon(
                        student['present'] ? Icons.check_circle : Icons.cancel,
                        color: student['present'] ? Colors.green : Colors.red,
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
}
