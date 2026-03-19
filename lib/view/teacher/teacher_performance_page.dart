import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/pref.dart';

import 'performance_planning_page.dart';
import 'performance_monitoring_page.dart';
import 'performance_evaluation_page.dart';

class TeacherPerformancePage extends StatefulWidget {
  const TeacherPerformancePage({super.key});

  @override
  State<TeacherPerformancePage> createState() => _TeacherPerformancePageState();
}

class _TeacherPerformancePageState extends State<TeacherPerformancePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _apiPlanningList = [];
  List<Map<String, dynamic>> _apiMonitoringList = [];
  List<Map<String, dynamic>> _apiEvaluationList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchAllPeriods();
  }

  Future<void> _fetchAllPeriods() async {
    try {
      String? token = await Session().getUserToken();

      var planReq = http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/plan/list-period',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({}),
      );

      var monitReq = http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/monit/list-period',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({}),
      );

      var evalReq = http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/eval/list-period',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({}),
      );

      var responses = await Future.wait([planReq, monitReq, evalReq]);
      var planRes = responses[0];
      var monitRes = responses[1];
      var evalRes = responses[2];

      if (mounted) {
        setState(() {
          if (planRes.statusCode == 200) {
            final result = jsonDecode(planRes.body);
            final List data = result['data'] ?? [];
            _apiPlanningList = data.map((item) {
              return {
                "id": item['perfperiod_id']?.toString() ?? '',
                "name": item['perfperiod_name']?.toString() ?? 'Unnamed Period',
                "period":
                    "${item['plan_startdate'] ?? ''} - ${item['plan_enddate'] ?? ''}",
                "teachers": <Map<String, dynamic>>[],
              };
            }).toList();
          }

          if (monitRes.statusCode == 200) {
            final result = jsonDecode(monitRes.body);
            final List data = result['data'] ?? [];
            _apiMonitoringList = data.map((item) {
              return {
                "id": item['perfperiod_id']?.toString() ?? '',
                "name": item['perfperiod_name']?.toString() ?? 'Unnamed Period',
                "period":
                    "${item['monitoring_startdate'] ?? ''} - ${item['monitoring_enddate'] ?? ''}",
                "teachers": <Map<String, dynamic>>[],
              };
            }).toList();
          }

          if (evalRes.statusCode == 200) {
            final result = jsonDecode(evalRes.body);
            final List data = result['data'] ?? [];
            _apiEvaluationList = data.map((item) {
              return {
                "id": item['perfperiod_id']?.toString() ?? '',
                "name": item['perfperiod_name']?.toString() ?? 'Unnamed Period',
                "period":
                    "${item['eval_startdate'] ?? ''} - ${item['eval_enddate'] ?? ''}",
                "teachers": <Map<String, dynamic>>[],
              };
            }).toList();
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.date_range_rounded, color: Colors.pink.shade500),
              const SizedBox(width: 10),
              const Text(
                "New Period",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: periodCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date Range",
                  suffixIcon: Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.pink.shade300,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTap: () async {
                  DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Colors.pink.shade500,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    setDialogState(() {
                      periodCtrl.text =
                          "${DateFormat('dd-MMM-yyyy').format(picked.start)} - ${DateFormat('dd-MMM-yyyy').format(picked.end)}";
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && periodCtrl.text.isNotEmpty) {
                  setState(() {
                    _apiPlanningList.add({
                      "id":
                          "PERF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
                      "name": nameCtrl.text,
                      "period": periodCtrl.text,
                      "teachers": <Map<String, dynamic>>[],
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Create",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
        title: const Text(
          "Teacher Performance",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: _showAddPeriodDialog,
              icon: Icon(Icons.add_rounded, color: Colors.pink.shade600),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.pink.shade600,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.pink.shade600,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Planning"),
            Tab(text: "Monitoring"),
            Tab(text: "Evaluation"),
          ],
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.pink));
    }

    List<Map<String, dynamic>> list = [];
    if (mode == "planning") {
      list = _apiPlanningList;
    } else if (mode == "monitoring") {
      list = _apiMonitoringList;
    } else {
      list = _apiEvaluationList;
    }

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_off_rounded,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 15),
            Text(
              "No periods available for $mode.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final data = list[index];
        Color cardColor = mode == "planning"
            ? Colors.blue.shade600
            : (mode == "monitoring"
                  ? Colors.orange.shade600
                  : Colors.green.shade600);
        IconData cardIcon = mode == "planning"
            ? Icons.edit_document
            : (mode == "monitoring"
                  ? Icons.analytics_rounded
                  : Icons.verified_rounded);

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: cardColor.withOpacity(0.2)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SubTeacherListPage(periodData: data, mode: mode),
                  ),
                );
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(cardIcon, color: cardColor, size: 28),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.date_range_rounded,
                                  size: 12,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  data['period'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey.shade300,
                      size: 28,
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
}

class SubTeacherListPage extends StatefulWidget {
  final Map<String, dynamic> periodData;
  final String mode;
  const SubTeacherListPage({
    super.key,
    required this.periodData,
    required this.mode,
  });

  @override
  State<SubTeacherListPage> createState() => _SubTeacherListPageState();
}

class _SubTeacherListPageState extends State<SubTeacherListPage> {
  List<Map<String, dynamic>> _apiTeachers = [];
  bool _isLoading = true;
  String _periodName = "";

  @override
  void initState() {
    super.initState();
    _periodName = widget.periodData['name'] ?? "Loading...";
    _fetchPeriodDetails();
  }

  Future<void> _fetchPeriodDetails() async {
    try {
      String? token = await Session().getUserToken();
      String periodId = widget.periodData['id'];

      String exactPayload = jsonEncode({"perfperiod_id": periodId});

      String endpointType = 'plan';
      if (widget.mode == 'monitoring') endpointType = 'monit';
      if (widget.mode == 'evaluation') endpointType = 'eval';

      var headerReq = http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/$endpointType/header-period',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: exactPayload,
      );

      var listReq = http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/$endpointType/list-teacher',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: exactPayload,
      );

      var responses = await Future.wait([headerReq, listReq]);
      var headerRes = responses[0];
      var listRes = responses[1];

      if (headerRes.statusCode == 200) {
        var decodedHeader = jsonDecode(headerRes.body);
        if (decodedHeader['data'] != null) {
          _periodName = decodedHeader['data']['perfperiod_name'] ?? _periodName;
        }
      }

      if (listRes.statusCode == 200) {
        var decodedList = jsonDecode(listRes.body);
        List data = decodedList['data'] ?? [];

        _apiTeachers = data.map((item) {
          return {
            "id": item['teacher_userid']?.toString() ?? '',
            "name": item['full_name']?.toString() ?? 'Unknown',
            "perfplanh_id": item['perfplanh_id']?.toString() ?? '',
            "perfevalh_id": item['perfevalh_id']?.toString() ?? '',
            "status": "Unapproved",
            "kpis": <Map<String, dynamic>>[],
          };
        }).toList();

        List<Future<void>> statusTasks = [];
        for (int i = 0; i < _apiTeachers.length; i++) {
          statusTasks.add(
            _fetchSingleTeacherStatus(token, endpointType, periodId, i),
          );
        }

        await Future.wait(statusTasks);
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchSingleTeacherStatus(
    String? token,
    String endpointType,
    String periodId,
    int index,
  ) async {
    try {
      String teacherId = _apiTeachers[index]['id'];
      var req = await http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/$endpointType/detail',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "perfperiod_id": periodId,
          "teacher_userid": teacherId,
        }),
      );

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        if (res['data'] != null && res['data']['status'] != null) {
          _apiTeachers[index]['status'] = res['data']['status'];
        }
      }
    } catch (e) {
      print("🚨 Error fetch status for $index: $e");
    }
  }

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
            const Text(
              "Assign Teacher",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: TextField(
          controller: nameCtrl,
          decoration: InputDecoration(
            labelText: "Teacher Name",
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  _apiTeachers.add({
                    "id":
                        "TCH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
                    "name": nameCtrl.text,
                    "perfplanh_id": "",
                    "perfevalh_id": "",
                    "status": "Unapproved",
                    "kpis": <Map<String, dynamic>>[],
                  });
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 15, 20, 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.blue.shade50, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.blue.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "Period Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),

          _buildInfoRow("Period ID", widget.periodData['id'] ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow("Period Name", _periodName),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        const Text(
          " :  ",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final teachers = _apiTeachers;

    Color themeColor = widget.mode == "planning"
        ? Colors.blue.shade600
        : (widget.mode == "monitoring"
              ? Colors.orange.shade600
              : Colors.green.shade600);
    String modeTitle = widget.mode == "planning"
        ? "Plan Creation"
        : (widget.mode == "monitoring" ? "Input Progress" : "Final Evaluation");

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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "$modeTitle \n$_periodName",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              if (widget.mode == "planning")
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _addTeacher,
                    icon: const Icon(
                      Icons.person_add_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(width: 10),
            ],
          ),

          if (!_isLoading) SliverToBoxAdapter(child: _buildPeriodHeader()),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
            sliver: _isLoading
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(
                        child: CircularProgressIndicator(color: themeColor),
                      ),
                    ),
                  )
                : teachers.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.group_off_rounded,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "No teachers assigned.",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final teacher = teachers[index];
                      bool isApproved = teacher['status'] == "Approved";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: themeColor.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: themeColor.withOpacity(0.1),
                              child: Icon(Icons.person, color: themeColor),
                            ),
                          ),
                          title: Text(
                            teacher['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isApproved
                                        ? Colors.green.shade50
                                        : Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    teacher['status'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isApproved
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: Colors.grey.shade400,
                          ),
                          onTap: () async {
                            Widget target;
                            if (widget.mode == "planning") {
                              target = SubKPIListPage(
                                teacherData: teacher,
                                periodData: widget.periodData,
                              );
                            } else if (widget.mode == "monitoring") {
                              target = SubMonitoringKPIList(
                                teacherData: teacher,
                                periodName: widget.periodData['name'],
                                periodData: widget.periodData,
                              );
                            } else {
                              target = SubEvaluationFormPage(
                                teacherData: teacher,
                                periodData: widget.periodData,
                              );
                            }

                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => target),
                            );

                            setState(() {
                              _isLoading = true;
                            });
                            _fetchPeriodDetails();
                          },
                        ),
                      );
                    }, childCount: teachers.length),
                  ),
          ),
        ],
      ),
    );
  }
}
