import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- DATA PUSAT (SINGLE SOURCE OF TRUTH) ---
class PerformanceData {
  static final List<Map<String, dynamic>> planningList = [];
}

class TeacherPerformancePage extends StatefulWidget {
  const TeacherPerformancePage({super.key});

  @override
  State<TeacherPerformancePage> createState() => _TeacherPerformancePageState();
}

class _TeacherPerformancePageState extends State<TeacherPerformancePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddPeriodDialog() {
    final nameCtrl = TextEditingController();
    final periodCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("New Performance Period"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Period Name")),
              TextField(
                controller: periodCtrl,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Date Range", suffixIcon: Icon(Icons.date_range)),
                onTap: () async {
                  DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setDialogState(() {
                      periodCtrl.text = "${DateFormat('dd-MMM-yyyy').format(picked.start)} - ${DateFormat('dd-MMM-yyyy').format(picked.end)}";
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && periodCtrl.text.isNotEmpty) {
                  setState(() {
                    PerformanceData.planningList.add({
                      "id": "PERF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
                      "name": nameCtrl.text,
                      "period": periodCtrl.text,
                      "teachers": <Map<String, dynamic>>[],
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Create"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Teacher Performance", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: _showAddPeriodDialog, icon: const Icon(Icons.add_circle_outline, color: Colors.blueAccent)),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blueAccent,
          indicatorColor: Colors.blueAccent,
          tabs: const [Tab(text: "Planning"), Tab(text: "Monitoring"), Tab(text: "Evaluation")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListView("planning"),
          _buildListView("monitoring"),
          _buildListView("evaluation"),
        ],
      ),
    );
  }

  Widget _buildListView(String mode) {
    final list = PerformanceData.planningList;
    if (list.isEmpty) return const Center(child: Text("No data available. Add in Planning."));

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final data = list[index];
        Color color = mode == "planning" ? Colors.blue : (mode == "monitoring" ? Colors.orange : Colors.green);
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(Icons.assignment, color: color, size: 20)),
            title: Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(data['period'], style: const TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 12),
            onTap: () async {
              Widget target;
              if (mode == "planning") {
                target = SubTeacherListPage(periodData: data, mode: "planning");
              } else if (mode == "monitoring") target = SubTeacherListPage(periodData: data, mode: "monitoring");
              else target = SubTeacherListPage(periodData: data, mode: "evaluation");
              
              await Navigator.push(context, MaterialPageRoute(builder: (context) => target));
              setState(() {});
            },
          ),
        );
      },
    );
  }
}

// --- SUB PAGE 1: LIST GURU ---
class SubTeacherListPage extends StatefulWidget {
  final Map<String, dynamic> periodData;
  final String mode;
  const SubTeacherListPage({super.key, required this.periodData, required this.mode});

  @override
  State<SubTeacherListPage> createState() => _SubTeacherListPageState();
}

class _SubTeacherListPageState extends State<SubTeacherListPage> {
  void _addTeacher() {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Assign Teacher"),
        content: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Teacher Name")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  widget.periodData['teachers'].add({
                    "id": "TCH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
                    "name": nameCtrl.text,
                    "status": "Unapproved",
                    "kpis": <Map<String, dynamic>>[],
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teachers = widget.periodData['teachers'] as List;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text("${widget.mode.toUpperCase()} - Teachers"),
        actions: [
          if (widget.mode == "planning") IconButton(onPressed: _addTeacher, icon: const Icon(Icons.person_add, color: Colors.blue)),
        ],
      ),
      body: teachers.isEmpty
          ? const Center(child: Text("No teachers assigned."))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final teacher = teachers[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(teacher['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Status: ${teacher['status']}"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () async {
                      Widget target;
                      if (widget.mode == "planning") {
                        target = SubKPIListPage(teacherData: teacher, periodData: widget.periodData);
                      } else if (widget.mode == "monitoring") target = SubMonitoringKPIList(teacherData: teacher, periodName: widget.periodData['name']);
                      else target = SubEvaluationFormPage(teacherData: teacher);

                      await Navigator.push(context, MaterialPageRoute(builder: (context) => target));
                      setState(() {});
                    },
                  ),
                );
              },
            ),
    );
  }
}

// --- SUB PAGE 2: PLANNING (KPI LIST) ---
class SubKPIListPage extends StatefulWidget {
  final Map<String, dynamic> teacherData;
  final Map<String, dynamic> periodData;
  const SubKPIListPage({super.key, required this.teacherData, required this.periodData});

  @override
  State<SubKPIListPage> createState() => _SubKPIListPageState();
}

class _SubKPIListPageState extends State<SubKPIListPage> {
  void _showKPIDialog({Map<String, dynamic>? existingKpi, int? index}) {
    final nameCtrl = TextEditingController(text: existingKpi?['name']);
    final targetCtrl = TextEditingController(text: existingKpi?['target']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingKpi == null ? "Add KPI" : "Edit KPI"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "KPI Name")),
            TextField(controller: targetCtrl, decoration: const InputDecoration(labelText: "Target")),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (existingKpi == null) {
                  widget.teacherData['kpis'].add({
                    "code": "KPI-${widget.teacherData['kpis'].length + 1}",
                    "name": nameCtrl.text,
                    "target": targetCtrl.text,
                    "monthlyData": List.filled(12, "0"),
                  });
                } else {
                  widget.teacherData['kpis'][index!] = {...existingKpi, "name": nameCtrl.text, "target": targetCtrl.text};
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kpis = widget.teacherData['kpis'] as List;
    final isApproved = widget.teacherData['status'] == "Approved";
    return Scaffold(
      appBar: AppBar(title: const Text("KPI Planning"), actions: [
        if (!isApproved) IconButton(onPressed: () => _showKPIDialog(), icon: const Icon(Icons.add_task)),
      ]),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: kpis.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(kpis[index]['name']),
                  subtitle: Text("Target: ${kpis[index]['target']}"),
                  trailing: isApproved ? null : IconButton(icon: const Icon(Icons.edit), onPressed: () => _showKPIDialog(existingKpi: kpis[index], index: index)),
                ),
              ),
            ),
          ),
          if (!isApproved && kpis.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: () => setState(() => widget.teacherData['status'] = "Approved"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Approve Plan", style: TextStyle(color: Colors.white)),
              )),
            )
        ],
      ),
    );
  }
}

// --- SUB PAGE 3: MONITORING (MONTHLY INPUT) ---
class SubMonitoringKPIList extends StatelessWidget {
  final Map<String, dynamic> teacherData;
  final String periodName;
  const SubMonitoringKPIList({super.key, required this.teacherData, required this.periodName});

  @override
  Widget build(BuildContext context) {
    final kpis = teacherData['kpis'] as List;
    return Scaffold(
      appBar: AppBar(title: const Text("Monitoring Progres")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: kpis.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(kpis[index]['name']),
            subtitle: const Text("Tap to input monthly progress"),
            trailing: const Icon(Icons.edit_note, color: Colors.orange),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SubMonthlyInputPage(kpi: kpis[index]))),
          ),
        ),
      ),
    );
  }
}

class SubMonthlyInputPage extends StatelessWidget {
  final Map<String, dynamic> kpi;
  const SubMonthlyInputPage({super.key, required this.kpi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Progress")),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.5, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: 12,
        itemBuilder: (context, index) => Column(
          children: [
            Text("Month ${index+1}", style: const TextStyle(fontSize: 10)),
            Expanded(child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(filled: true, fillColor: Colors.blue.withOpacity(0.05), border: InputBorder.none),
              onChanged: (v) => kpi['monthlyData'][index] = v,
            )),
          ],
        ),
      ),
    );
  }
}

// --- SUB PAGE 4: EVALUATION (FINAL SCORE) ---
class SubEvaluationFormPage extends StatefulWidget {
  final Map<String, dynamic> teacherData;
  const SubEvaluationFormPage({super.key, required this.teacherData});

  @override
  State<SubEvaluationFormPage> createState() => _SubEvaluationFormPageState();
}

class _SubEvaluationFormPageState extends State<SubEvaluationFormPage> {
  double _finalScore = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Evaluation Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.teacherData['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Final Performance Score:"),
            Text(_finalScore.toStringAsFixed(2), style: const TextStyle(fontSize: 48, color: Colors.blue, fontWeight: FontWeight.bold)),
            ElevatedButton(onPressed: () => setState(() => _finalScore = 3.85), child: const Text("Calculate Score")),
          ],
        ),
      ),
    );
  }
}
