import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.date_range_rounded, color: Colors.pink.shade500),
              const SizedBox(width: 10),
              const Text("New Period", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                      labelText: "Period Name",
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
                  )
              ),
              const SizedBox(height: 15),
              TextField(
                controller: periodCtrl,
                readOnly: true,
                decoration: InputDecoration(
                    labelText: "Date Range",
                    suffixIcon: Icon(Icons.calendar_month_rounded, color: Colors.pink.shade300),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
                ),
                onTap: () async {
                  DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Colors.pink.shade500)),
                        child: child!,
                      )
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
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text("Create", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Teacher Performance", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
            decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(10)),
            child: IconButton(onPressed: _showAddPeriodDialog, icon: Icon(Icons.add_rounded, color: Colors.pink.shade600)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.pink.shade600,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.pink.shade600,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
    if (list.isEmpty) {
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_off_rounded, size: 80, color: Colors.grey.shade300),
              const SizedBox(height: 15),
              Text("No periods available.\nPlease add in Planning tab.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
            ],
          )
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final data = list[index];
        Color cardColor = mode == "planning" ? Colors.blue.shade600 : (mode == "monitoring" ? Colors.orange.shade600 : Colors.green.shade600);
        IconData cardIcon = mode == "planning" ? Icons.edit_document : (mode == "monitoring" ? Icons.analytics_rounded : Icons.verified_rounded);

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: cardColor.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
            border: Border.all(color: cardColor.withOpacity(0.2)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () async {
                Widget target;
                if (mode == "planning") {
                  target = SubTeacherListPage(periodData: data, mode: "planning");
                } else if (mode == "monitoring") {
                  target = SubTeacherListPage(periodData: data, mode: "monitoring");
                } else {
                  target = SubTeacherListPage(periodData: data, mode: "evaluation");
                }

                await Navigator.push(context, MaterialPageRoute(builder: (context) => target));
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: cardColor.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(cardIcon, color: cardColor, size: 28),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142))),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.date_range_rounded, size: 12, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(data['period'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 28),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.person_add_rounded, color: Colors.blue.shade600),
            const SizedBox(width: 10),
            const Text("Assign Teacher", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: TextField(
            controller: nameCtrl,
            decoration: InputDecoration(
                labelText: "Teacher Name",
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
            )
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text("Add", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teachers = widget.periodData['teachers'] as List;
    Color themeColor = widget.mode == "planning" ? Colors.blue.shade600 : (widget.mode == "monitoring" ? Colors.orange.shade600 : Colors.green.shade600);
    String modeTitle = widget.mode == "planning" ? "Plan Creation" : (widget.mode == "monitoring" ? "Input Progress" : "Final Evaluation");

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
                  colors: [themeColor.withOpacity(0.7), themeColor],
                ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 60, bottom: 20),
                title: Text("$modeTitle \nTeachers", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
            ),
            actions: [
              if (widget.mode == "planning")
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: IconButton(onPressed: _addTeacher, icon: const Icon(Icons.person_add_rounded, color: Colors.white)),
                ),
              const SizedBox(width: 10),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: teachers.isEmpty
                ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(child: Column(children: [Icon(Icons.group_off_rounded, size: 80, color: Colors.grey.shade300), const SizedBox(height: 15), Text("No teachers assigned.", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold))])),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final teacher = teachers[index];
                  bool isApproved = teacher['status'] == "Approved";

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: themeColor.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      leading: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: themeColor.withOpacity(0.3), width: 2)),
                        child: CircleAvatar(backgroundColor: themeColor.withOpacity(0.1), child: Icon(Icons.person, color: themeColor)),
                      ),
                      title: Text(teacher['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: isApproved ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                              child: Text(teacher['status'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isApproved ? Colors.green.shade700 : Colors.red.shade700)),
                            ),
                          ],
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey.shade400),
                      onTap: () async {
                        Widget target;
                        if (widget.mode == "planning") {
                          target = SubKPIListPage(teacherData: teacher, periodData: widget.periodData);
                        } else if (widget.mode == "monitoring") {
                          target = SubMonitoringKPIList(teacherData: teacher, periodName: widget.periodData['name']);
                        } else {
                          target = SubEvaluationFormPage(teacherData: teacher);
                        }

                        await Navigator.push(context, MaterialPageRoute(builder: (context) => target));
                        setState(() {});
                      },
                    ),
                  );
                },
                childCount: teachers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
    final descCtrl = TextEditingController(text: existingKpi?['description'] ?? "-");
    final weightCtrl = TextEditingController(text: existingKpi?['weight'] ?? "");
    final targetCtrl = TextEditingController(text: existingKpi?['target'] ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.flag_rounded, color: Colors.blue.shade600),
            const SizedBox(width: 10),
            Text(existingKpi == null ? "Add KPI" : "Edit KPI", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "KPI Name", filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
              const SizedBox(height: 10),
              TextField(controller: descCtrl, decoration: InputDecoration(labelText: "Description", filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
              const SizedBox(height: 10),
              TextField(controller: weightCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Weight (Bobot)", filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
              const SizedBox(height: 10),
              TextField(controller: targetCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Target Value", filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (existingKpi == null) {
                  widget.teacherData['kpis'].add({
                    "code": "KPI_${widget.teacherData['kpis'].length + 1}",
                    "name": nameCtrl.text,
                    "description": descCtrl.text,
                    "weight": weightCtrl.text,
                    "target": targetCtrl.text,
                    "assessment": "",
                    "monthlyData": List.filled(12, "0"),
                  });
                } else {
                  widget.teacherData['kpis'][index!] = {
                    ...existingKpi,
                    "name": nameCtrl.text,
                    "description": descCtrl.text,
                    "weight": weightCtrl.text,
                    "target": targetCtrl.text,
                  };
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("KPI Planning", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
            Text(widget.teacherData['name'], style: TextStyle(color: Colors.blue.shade700, fontSize: 12)),
          ],
        ),
        actions: [
          if (!isApproved)
            Container(
              margin: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
              child: IconButton(onPressed: () => _showKPIDialog(), icon: Icon(Icons.add_task_rounded, color: Colors.blue.shade600)),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: kpis.isEmpty
                ? Center(child: Text("No KPI planned yet.", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)))
                : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: kpis.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blue.shade50)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(kpis[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                        children: [
                          Icon(Icons.flag_circle_rounded, size: 16, color: Colors.orange.shade500),
                          const SizedBox(width: 5),
                          Text("Target: ${kpis[index]['target']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                          const SizedBox(width: 15),
                          Icon(Icons.line_weight_rounded, size: 16, color: Colors.purple.shade500),
                          const SizedBox(width: 5),
                          Text("Weight: ${kpis[index]['weight'] ?? '0'}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                        ]
                    ),
                  ),
                  trailing: isApproved ? Icon(Icons.check_circle, color: Colors.green.shade400) : IconButton(icon: Icon(Icons.edit_square, color: Colors.blue.shade400), onPressed: () => _showKPIDialog(existingKpi: kpis[index], index: index)),
                ),
              ),
            ),
          ),
          if (!isApproved && kpis.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() => widget.teacherData['status'] = "Approved");
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Plan Approved!"), backgroundColor: Colors.green));
                  },
                  icon: const Icon(Icons.verified_rounded, color: Colors.white),
                  label: const Text("Approve Plan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class SubMonitoringKPIList extends StatelessWidget {
  final Map<String, dynamic> teacherData;
  final String periodName;
  const SubMonitoringKPIList({super.key, required this.teacherData, required this.periodName});

  @override
  Widget build(BuildContext context) {
    final kpis = teacherData['kpis'] as List;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Input Progress", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
            Text(teacherData['name'], style: TextStyle(color: Colors.orange.shade700, fontSize: 12)),
          ],
        ),
      ),
      body: kpis.isEmpty
          ? Center(child: Text("No KPI available. Create plan first.", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)))
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: kpis.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.orange.shade100)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.insert_chart_rounded, color: Colors.orange.shade600)),
            title: Text(kpis[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Tap to input monthly progress", style: TextStyle(fontSize: 12)),
            trailing: Icon(Icons.edit_note_rounded, color: Colors.orange.shade400, size: 28),
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black87), title: Text(kpi['name'], style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16))),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.orange.shade600,
            child: Text("Target Score: ${kpi['target']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.0, crossAxisSpacing: 15, mainAxisSpacing: 15),
              itemCount: 12,
              itemBuilder: (context, index) {
                List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(months[index], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          controller: TextEditingController(text: kpi['monthlyData'][index] == "0" ? "" : kpi['monthlyData'][index]),
                          decoration: InputDecoration(filled: true, fillColor: Colors.orange.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), contentPadding: EdgeInsets.zero),
                          onChanged: (v) => kpi['monthlyData'][index] = v.isEmpty ? "0" : v,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SubEvaluationFormPage extends StatefulWidget {
  final Map<String, dynamic> teacherData;
  const SubEvaluationFormPage({super.key, required this.teacherData});

  @override
  State<SubEvaluationFormPage> createState() => _SubEvaluationFormPageState();
}

class _SubEvaluationFormPageState extends State<SubEvaluationFormPage> {
  final _kpiScoreCtrl = TextEditingController();
  final _attendanceScoreCtrl = TextEditingController();
  final _developmentScoreCtrl = TextEditingController();
  final _attitudeScoreCtrl = TextEditingController();

  double _finalScore = 0.0;
  bool _isCalculated = false;

  @override
  void initState() {
    super.initState();
    _refreshKpiScore();
  }

  void _refreshKpiScore() {
    final kpis = widget.teacherData['kpis'] as List;
    if (kpis.isEmpty) {
      _kpiScoreCtrl.text = "0.00";
      return;
    }

    double total = 0;
    for (var k in kpis) {
      total += double.tryParse(k['assessment']?.toString() ?? '0') ?? 0.0;
    }
    double average = total / kpis.length;
    _kpiScoreCtrl.text = average.toStringAsFixed(2);
  }

  void _calculateFinalScore() {
    double kpi = double.tryParse(_kpiScoreCtrl.text) ?? 0.0;
    double attendance = double.tryParse(_attendanceScoreCtrl.text) ?? 0.0;
    double development = double.tryParse(_developmentScoreCtrl.text) ?? 0.0;
    double attitude = double.tryParse(_attitudeScoreCtrl.text) ?? 0.0;

    setState(() {
      _finalScore = (kpi * 0.4) + (attendance * 0.2) + (development * 0.2) + (attitude * 0.2);
      _isCalculated = true;
    });
  }

  void _showKpiListModal() {
    final kpis = widget.teacherData['kpis'] as List;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Teacher KPI List", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  IconButton(icon: const Icon(Icons.close_rounded, color: Colors.grey), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),

              Expanded(
                child: kpis.isEmpty
                    ? Center(child: Text("No KPI data found.", style: TextStyle(color: Colors.grey.shade500)))
                    : ListView.builder(
                  itemCount: kpis.length,
                  itemBuilder: (context, index) {
                    final kpi = kpis[index];
                    final validScores = ["1", "2", "3", "4", "5"];
                    String? currentAssessment = kpi['assessment']?.toString();

                    if (currentAssessment == null || currentAssessment.isEmpty || !validScores.contains(currentAssessment)) {
                      currentAssessment = null;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.indigo.shade50, width: 2),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(6)),
                                  child: Text(kpi['code'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.indigo.shade700)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(kpi['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3142))),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("TARGET", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500)), const SizedBox(height: 4), Text(kpi['target'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))])),
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("WEIGHT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500)), const SizedBox(height: 4), Text(kpi['weight'] ?? "0", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))])),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                                  child: IconButton(icon: Icon(Icons.remove_red_eye_rounded, color: Colors.blue.shade600, size: 20), onPressed: () => _showKpiDetailModal(kpi)),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                                  child: IconButton(icon: Icon(Icons.timer_rounded, color: Colors.blue.shade600, size: 20), onPressed: () => _showKpiMonitoringModal(kpi)),
                                ),
                                const SizedBox(width: 15),
                                SizedBox(
                                  width: 100,
                                  child: DropdownButtonFormField<String>(
                                    initialValue: currentAssessment,
                                    decoration: InputDecoration(
                                      labelText: "Score",
                                      labelStyle: const TextStyle(fontSize: 12),
                                      filled: true,
                                      fillColor: Colors.blue.shade50,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    ),
                                    items: validScores.map((val) => DropdownMenuItem(value: val, child: Text(val, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
                                    onChanged: (val) {
                                      setModalState(() {
                                        kpi['assessment'] = val;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _refreshKpiScore();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("KPI Scores updated!"), backgroundColor: Colors.green));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade600, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: const Text("Save & Update KPI Score", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showKpiDetailModal(Map<String, dynamic> kpi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("KPI Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1A237E))),
                IconButton(icon: const Icon(Icons.close_rounded, color: Colors.grey), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildReadOnlyRow("KPI Code", kpi['code']),
                    _buildReadOnlyRow("KPI Name", kpi['name']),
                    _buildReadOnlyRow("KPI Description", kpi['description'] ?? "-"),
                    _buildReadOnlyRow("Weight *", kpi['weight'] ?? "0", isHighlight: true),
                    _buildReadOnlyRow("Target *", kpi['target'] ?? "0", isHighlight: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showKpiMonitoringModal(Map<String, dynamic> kpi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("KPI Detail & Monitoring", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1A237E))),
                IconButton(icon: const Icon(Icons.close_rounded, color: Colors.grey), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Divider()),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("KPI Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3142))),
                    const SizedBox(height: 15),
                    _buildReadOnlyRow("KPI Code", kpi['code']),
                    _buildReadOnlyRow("KPI Name", kpi['name']),
                    _buildReadOnlyRow("KPI Description", kpi['description'] ?? "-"),
                    _buildReadOnlyRow("Weight *", kpi['weight'] ?? "0", isHighlight: true),
                    _buildReadOnlyRow("Target *", kpi['target'] ?? "0", isHighlight: true),

                    const SizedBox(height: 25),
                    const Text("Monthly Monitoring", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3142))),
                    const SizedBox(height: 15),

                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Text("${index + 1}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.blue.shade200),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    kpi['monthlyData'][index],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: isHighlight ? Colors.white : Colors.indigo.shade50.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isHighlight ? Colors.grey.shade300 : Colors.indigo.shade100),
              ),
              child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
            ),
          ),
        ],
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
                  colors: [Colors.green.shade400, Colors.teal.shade600],
                ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                    "Evaluation Form\n${widget.teacherData['name']}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.assignment_turned_in_rounded, color: Colors.green.shade600),
                            const SizedBox(width: 8),
                            const Text("Performance Scores", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1)),

                        _buildEvalInput(
                          label: "Score KPI",
                          controller: _kpiScoreCtrl,
                          isReadOnly: true,
                          showEyeIcon: true,
                          onEyeTap: _showKpiListModal,
                        ),

                        _buildEvalInput(label: "Score Attendance", controller: _attendanceScoreCtrl),
                        _buildEvalDropdown("Score Teacher Development", _developmentScoreCtrl),
                        _buildEvalDropdown("Score Teacher Attitude", _attitudeScoreCtrl, isRequired: true),

                        const SizedBox(height: 15),
                        if (_isCalculated)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.green.shade200, width: 2),
                            ),
                            child: Column(
                              children: [
                                Text("FINAL SCORE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                                const SizedBox(height: 8),
                                TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0, end: _finalScore),
                                  duration: const Duration(milliseconds: 1500),
                                  builder: (context, value, child) {
                                    return Text(
                                        value.toStringAsFixed(6),
                                        style: TextStyle(fontSize: 32, color: Colors.green.shade700, fontWeight: FontWeight.w900)
                                    );
                                  },
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
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.grey.shade100, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
                )
            ),
            const SizedBox(width: 15),
            Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _calculateFinalScore,
                  icon: const Icon(Icons.calculate_rounded, color: Colors.white),
                  label: const Text("Calculate", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 4, shadowColor: Colors.green.withOpacity(0.4)),
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvalInput({required String label, required TextEditingController controller, bool isReadOnly = false, bool showEyeIcon = false, VoidCallback? onEyeTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: isReadOnly,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              filled: true,
              fillColor: isReadOnly ? Colors.grey.shade100 : Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.green.shade400, width: 1.5)),
              suffixIcon: showEyeIcon
                  ? InkWell(
                onTap: onEyeTap,
                child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.indigo.shade600, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.remove_red_eye_rounded, color: Colors.white, size: 16)
                ),
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvalDropdown(String label, TextEditingController controller, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
                text: label,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontFamily: 'Roboto'),
                children: [
                  if (isRequired) const TextSpan(text: " *", style: TextStyle(color: Colors.red)),
                ]
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.green.shade400, width: 1.5)),
            ),
            hint: const Text("Select"),
            items: const [
              DropdownMenuItem(value: "0.2", child: Text("Poor (0.2)")),
              DropdownMenuItem(value: "0.4", child: Text("Fair (0.4)")),
              DropdownMenuItem(value: "0.6", child: Text("Good (0.6)")),
              DropdownMenuItem(value: "0.8", child: Text("Excellent (0.8)")),
            ],
            onChanged: (val) {
              if (val != null) {
                controller.text = val;
              }
            },
          ),
        ],
      ),
    );
  }
}