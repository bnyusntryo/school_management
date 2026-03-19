import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management/config/pref.dart';

class SubMonitoringKPIList extends StatefulWidget {
  final Map<String, dynamic> teacherData;
  final String periodName;
  final Map<String, dynamic>? periodData;

  const SubMonitoringKPIList({
    super.key,
    required this.teacherData,
    required this.periodName,
    this.periodData,
  });

  @override
  State<SubMonitoringKPIList> createState() => _SubMonitoringKPIListState();
}

class _SubMonitoringKPIListState extends State<SubMonitoringKPIList> {
  List<Map<String, dynamic>> _apiKpis = [];
  String _monitStatus = "Unapproved";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMonitoringData();
  }

  Future<void> _fetchMonitoringData() async {
    try {
      String? token = await Session().getUserToken();
      String periodId = widget.periodData?['id'] ?? '';
      String teacherId = widget.teacherData['id'] ?? '';
      String planHId = widget.teacherData['perfplanh_id'] ?? '';

      var detailReq = http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/monit/detail',
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

      var listKpiReq = http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/monit/detail/list-kpi',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"perfperiod_id": periodId, "perfplanh_id": planHId}),
      );

      var responses = await Future.wait([detailReq, listKpiReq]);
      var detailRes = responses[0];
      var listKpiRes = responses[1];

      if (mounted) {
        setState(() {
          if (detailRes.statusCode == 200) {
            var decodedDetail = jsonDecode(detailRes.body);
            if (decodedDetail['data'] != null) {
              _monitStatus =
                  decodedDetail['data']['status']?.toString() ?? "Unapproved";
            }
          }

          if (listKpiRes.statusCode == 200) {
            var decodedList = jsonDecode(listKpiRes.body);
            List dataList = decodedList['data'] ?? [];

            _apiKpis = dataList.map((item) {
              return {
                "perfpland_id": item['perfpland_id']?.toString() ?? "",
                "code": item['kpi_code']?.toString() ?? "",
                "name": item['kpilibrary_name']?.toString() ?? "Unknown KPI",
                "target": item['target']?.toString() ?? "0",
                "weight": item['weight']?.toString() ?? "0",
                "perfmonit_id": item['perfmonit_id']?.toString() ?? "",
                "monthlyData": List.filled(12, "0"),
              };
            }).toList();
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      print("🚨 Error fetch Monitoring KPI: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildDetailHeader() {
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
        border: Border.all(color: Colors.orange.shade100, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.monitor_heart_rounded,
                color: Colors.orange.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "Monitoring Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),

          _buildInfoRow("Period ID", widget.periodData?['id'] ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow("Period Name", widget.periodName),
          const SizedBox(height: 10),
          _buildInfoRow("Teacher ID", widget.teacherData['id'] ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow("Teacher Name", widget.teacherData['name'] ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow("Status", _monitStatus, isStatus: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    bool isApproved = value == "Approved";
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
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
          child: isStatus
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isApproved
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isApproved
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                      ),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isApproved
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ),
                )
              : Text(
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
    final kpis = _apiKpis;
    final isApproved = _monitStatus == "Approved";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "Monitoring Progress",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              children: [
                _buildDetailHeader(),

                if (!isApproved)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _monitStatus = "Approved";
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Monitoring Form Approved!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          label: const Text(
                            "Approve Monitoring Form",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo.shade400,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (isApproved || kpis.isEmpty) const SizedBox(height: 10),

                Expanded(
                  child: kpis.isEmpty
                      ? Center(
                          child: Text(
                            "No KPI available.",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                          itemCount: kpis.length,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.orange.shade100),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),

                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubMonthlyInputPage(
                                      kpi: kpis[index],
                                      planHId:
                                          widget.teacherData['perfplanh_id'] ??
                                          '',
                                    ),
                                  ),
                                ),

                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.insert_chart_rounded,
                                    color: Colors.orange.shade600,
                                  ),
                                ),
                                title: Text(
                                  kpis[index]['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.flag_circle_rounded,
                                        size: 16,
                                        color: Colors.orange.shade500,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Target: ${kpis[index]['target']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Icon(
                                        Icons.line_weight_rounded,
                                        size: 16,
                                        color: Colors.purple.shade500,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Weight: ${kpis[index]['weight'] ?? '0'}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.edit_note_rounded,
                                  color: Colors.orange.shade400,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class SubMonthlyInputPage extends StatefulWidget {
  final Map<String, dynamic> kpi;
  final String planHId;

  const SubMonthlyInputPage({
    super.key,
    required this.kpi,
    required this.planHId,
  });

  @override
  State<SubMonthlyInputPage> createState() => _SubMonthlyInputPageState();
}

class _SubMonthlyInputPageState extends State<SubMonthlyInputPage> {
  bool _isLoading = true;
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 12; i++) {
      _controllers.add(
        TextEditingController(
          text: widget.kpi['monthlyData'][i] == "0"
              ? ""
              : widget.kpi['monthlyData'][i],
        ),
      );
    }
    _fetchMonthlyData();
  }

  Future<void> _fetchMonthlyData() async {
    try {
      String? token = await Session().getUserToken();
      String planDId = widget.kpi['perfpland_id'] ?? '';

      var req = await http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/monit/detail/detail-kpi',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "perfplanh_id": widget.planHId,
          "perfpland_id": planDId,
        }),
      );

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        if (res['data'] != null) {
          var data = res['data'];

          if (mounted) {
            setState(() {
              for (int i = 0; i < 12; i++) {
                String val = data['perfmonit_${i + 1}']?.toString() ?? "0";
                widget.kpi['monthlyData'][i] = val;
                _controllers[i].text = (val == "0" || val == "0.0") ? "" : val;
              }
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      print("🚨 Error fetch monthly data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    for (var ctrl in _controllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          widget.kpi['name'],
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  color: Colors.orange.shade600,
                  child: Text(
                    "Target Score: ${widget.kpi['target']}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      List<String> months = [
                        "Jan",
                        "Feb",
                        "Mar",
                        "Apr",
                        "May",
                        "Jun",
                        "Jul",
                        "Aug",
                        "Sep",
                        "Oct",
                        "Nov",
                        "Dec",
                      ];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              months[index],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: TextField(
                                controller: _controllers[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.orange.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (v) =>
                                    widget.kpi['monthlyData'][index] = v.isEmpty
                                    ? "0"
                                    : v,
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

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Fitur Save API menunggu intelijen berikutnya!",
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            icon: const Icon(Icons.save_rounded, color: Colors.white),
            label: const Text(
              "Save Progress",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 2,
            ),
          ),
        ),
      ),
    );
  }
}
