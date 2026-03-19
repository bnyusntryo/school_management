import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management/config/pref.dart';

class SubEvaluationFormPage extends StatefulWidget {
  final Map<String, dynamic> teacherData;
  final Map<String, dynamic>? periodData;

  const SubEvaluationFormPage({
    super.key,
    required this.teacherData,
    this.periodData,
  });

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvaluationData();
  }

  Future<void> _fetchEvaluationData() async {
    try {
      String? token = await Session().getUserToken();
      String evalHId = widget.teacherData['perfevalh_id'] ?? '';

      if (evalHId.isEmpty) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      var req = await http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/eval/detail',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"perfevalh_id": evalHId}),
      );

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        if (res['data'] != null) {
          var data = res['data'];

          if (mounted) {
            setState(() {
              _kpiScoreCtrl.text = data['score_kpi']?.toString() ?? "0";
              _attendanceScoreCtrl.text =
                  data['score_attendance']?.toString() ?? "0";
              _developmentScoreCtrl.text =
                  data['score_teacherdev']?.toString() ?? "0";
              _attitudeScoreCtrl.text = data['score_etitut']?.toString() ?? "0";

              _finalScore =
                  double.tryParse(data['total_score']?.toString() ?? "0") ??
                  0.0;
              _isCalculated = true;
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      print("🚨 Error fetch evaluation data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _calculateFinalScore() {
    double kpi = double.tryParse(_kpiScoreCtrl.text) ?? 0.0;
    double attendance = double.tryParse(_attendanceScoreCtrl.text) ?? 0.0;
    double development = double.tryParse(_developmentScoreCtrl.text) ?? 0.0;
    double attitude = double.tryParse(_attitudeScoreCtrl.text) ?? 0.0;

    setState(() {
      _finalScore =
          (kpi * 0.4) +
          (attendance * 0.2) +
          (development * 0.2) +
          (attitude * 0.2);
      _isCalculated = true;
    });
  }

  void _showKpiListModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SubEvaluationKpiListModal(
        teacherData: widget.teacherData,
        periodData: widget.periodData,
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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Evaluation Form\n${widget.teacherData['name']}",
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
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
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
                            border: Border.all(
                              color: Colors.green.shade100,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.assignment_ind_rounded,
                                    color: Colors.green.shade600,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Evaluation Info",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(height: 1),
                              ),
                              _buildInfoRow(
                                "Teacher ID",
                                widget.teacherData['id'] ?? '-',
                              ),
                              const SizedBox(height: 10),
                              _buildInfoRow(
                                "Teacher Name",
                                widget.teacherData['name'] ?? '-',
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.assessment_rounded,
                                    color: Colors.green.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Performance Scores",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D3142),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Divider(height: 1),
                              ),

                              _buildEvalInput(
                                label: "Score KPI",
                                controller: _kpiScoreCtrl,
                                isReadOnly: true,
                                trailingWidget: InkWell(
                                  onTap: _showKpiListModal,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade700,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.remove_red_eye_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),

                              _buildEvalInput(
                                label: "Score Attendance",
                                controller: _attendanceScoreCtrl,
                                isReadOnly: true,
                              ),
                              _buildEvalInput(
                                label: "Score Teacher Development",
                                controller: _developmentScoreCtrl,
                                isReadOnly: true,
                                trailingWidget: _buildDropdown1to4(
                                  _developmentScoreCtrl,
                                ),
                              ),
                              _buildEvalInput(
                                label: "Score Teacher Attitude",
                                controller: _attitudeScoreCtrl,
                                isReadOnly: true,
                                isRequired: true,
                                trailingWidget: _buildDropdown1to4(
                                  _attitudeScoreCtrl,
                                ),
                              ),

                              const SizedBox(height: 15),
                              if (_isCalculated)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.green.shade200,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "FINAL SCORE",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade800,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TweenAnimationBuilder<double>(
                                        tween: Tween<double>(
                                          begin: 0,
                                          end: _finalScore,
                                        ),
                                        duration: const Duration(
                                          milliseconds: 1500,
                                        ),
                                        builder: (context, value, child) {
                                          return Text(
                                            value.toStringAsFixed(6),
                                            style: TextStyle(
                                              fontSize: 32,
                                              color: Colors.green.shade700,
                                              fontWeight: FontWeight.w900,
                                            ),
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
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  _calculateFinalScore();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Simulasi Kalkulasi Berhasil (API Save Dinonaktifkan)",
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.calculate_rounded, color: Colors.white),
                label: const Text(
                  "Calculate",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  shadowColor: Colors.green.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildEvalInput({
    required String label,
    required TextEditingController controller,
    bool isReadOnly = false,
    bool isRequired = false,
    Widget? trailingWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
                fontFamily: 'Roboto',
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: isReadOnly,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isReadOnly ? Colors.grey.shade700 : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isReadOnly
                        ? const Color(0xFFE8ECEF)
                        : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.green.shade400,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              if (trailingWidget != null) ...[
                const SizedBox(width: 10),
                trailingWidget,
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown1to4(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text("Select", style: TextStyle(fontSize: 13)),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade500,
          ),
          items: ["1", "2", "3", "4"].map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                val,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                double decimalValue = int.parse(newValue) / 10;
                controller.text = decimalValue.toString();
              });
            }
          },
        ),
      ),
    );
  }
}

class SubEvaluationKpiListModal extends StatefulWidget {
  final Map<String, dynamic> teacherData;
  final Map<String, dynamic>? periodData;

  const SubEvaluationKpiListModal({
    super.key,
    required this.teacherData,
    this.periodData,
  });

  @override
  State<SubEvaluationKpiListModal> createState() =>
      _SubEvaluationKpiListModalState();
}

class _SubEvaluationKpiListModalState extends State<SubEvaluationKpiListModal> {
  bool _isLoading = true;
  String _planStatus = "Loading...";
  List<Map<String, dynamic>> _kpiList = [];

  @override
  void initState() {
    super.initState();
    _fetchDetailedKpis();
  }

  Future<void> _fetchDetailedKpis() async {
    try {
      String? token = await Session().getUserToken();
      String periodId = widget.periodData?['id'] ?? '';
      String planHId = widget.teacherData['perfplanh_id'] ?? '';
      String evalHId = widget.teacherData['perfevalh_id'] ?? '';
      String teacherId = widget.teacherData['id'] ?? '';

      var planReq = http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/eval/detail/plan',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "perfperiod_id": periodId,
          "perfplanh_id": planHId,
          "teacher_userid": teacherId,
        }),
      );

      var listKpiReq = http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/eval/detail/list-kpi',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "perfperiod_id": periodId,
          "perfplanh_id": planHId,
          "perfevalh_id": evalHId,
        }),
      );

      var responses = await Future.wait([planReq, listKpiReq]);
      var planRes = responses[0];
      var kpiRes = responses[1];

      if (mounted) {
        setState(() {
          if (planRes.statusCode == 200) {
            var decodedPlan = jsonDecode(planRes.body);
            if (decodedPlan['data'] != null) {
              _planStatus =
                  decodedPlan['data']['status']?.toString() ?? "Unknown";
            }
          }

          if (kpiRes.statusCode == 200) {
            var decodedKpi = jsonDecode(kpiRes.body);
            List data = decodedKpi['data'] ?? [];
            _kpiList = data.map((item) {
              return {
                "perfpland_id": item['perfpland_id']?.toString() ?? '',
                "kpi_code": item['kpi_code']?.toString() ?? '',
                "name": item['kpilibrary_name']?.toString() ?? 'Unnamed KPI',
                "target": item['target']?.toString() ?? '0',
                "weight": item['weight']?.toString() ?? '0',
                "score": item['score']?.toString() ?? '1',
              };
            }).toList();
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      print("🚨 Error Fetching Eval Detail KPIs: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchAndShowKpiDetail(String perfplandId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.blue)),
    );

    try {
      String? token = await Session().getUserToken();
      String planHId = widget.teacherData['perfplanh_id'] ?? '';

      var req = await http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/plan/detail/detail-kpi',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "perfplanh_id": planHId,
          "perfpland_id": perfplandId,
        }),
      );

      Navigator.pop(context);

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        if (res['data'] != null) {
          var data = res['data'];
          Map<String, dynamic> targetData;

          if (data is List && data.isNotEmpty) {
            targetData = data.firstWhere(
              (element) => element['perfpland_id'] == perfplandId,
              orElse: () => data[0],
            );
          } else {
            targetData = data;
          }

          _showDetailDialog(targetData, "KPI Detail");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal mengambil detail KPI"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      print("🚨 Error Fetching KPI Detail: $e");
    }
  }

  Future<void> _fetchAndShowMonitoringDetail(String perfplandId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.blue)),
    );

    try {
      String? token = await Session().getUserToken();
      String planHId = widget.teacherData['perfplanh_id'] ?? '';

      var req = await http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/teacherperf/monit/detail/detail-kpi',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "perfplanh_id": planHId,
          "perfpland_id": perfplandId,
        }),
      );

      Navigator.pop(context);

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        if (res['data'] != null) {
          var data = res['data'];
          Map<String, dynamic> targetData;

          if (data is List && data.isNotEmpty) {
            targetData = data.firstWhere(
              (element) => element['perfpland_id'] == perfplandId,
              orElse: () => data[0],
            );
          } else {
            targetData = data;
          }

          _showMonitoringDialog(targetData);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal mengambil data Monitoring"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      print("🚨 Error Fetching Monitoring Detail: $e");
    }
  }

  void _showDetailDialog(Map<String, dynamic> kpiData, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1A237E),
              ),
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogReadOnlyField(
                "KPI Code",
                kpiData['kpi_code']?.toString() ?? '-',
              ),
              const SizedBox(height: 12),
              _buildDialogReadOnlyField(
                "KPI Name",
                kpiData['kpilibrary_name']?.toString() ?? '-',
              ),
              const SizedBox(height: 12),
              _buildDialogReadOnlyField(
                "KPI Description",
                kpiData['kpilibrary_desc']?.toString() ?? '-',
              ),
              const SizedBox(height: 12),
              _buildDialogReadOnlyField(
                "Weight *",
                kpiData['weight']?.toString() ?? '-',
              ),
              const SizedBox(height: 12),
              _buildDialogReadOnlyField(
                "Target *",
                kpiData['target']?.toString() ?? '-',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMonitoringDialog(Map<String, dynamic> kpiData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Monitoring Detail",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1A237E),
              ),
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "KPI Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                _buildDialogReadOnlyField(
                  "KPI Code",
                  kpiData['kpi_code']?.toString() ?? '-',
                ),
                const SizedBox(height: 10),
                _buildDialogReadOnlyField(
                  "KPI Name",
                  kpiData['kpilibrary_name']?.toString() ?? '-',
                ),
                const SizedBox(height: 10),
                _buildDialogReadOnlyField(
                  "Weight *",
                  kpiData['weight']?.toString() ?? '-',
                ),
                const SizedBox(height: 10),
                _buildDialogReadOnlyField(
                  "Target *",
                  kpiData['target']?.toString() ?? '-',
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(),
                ),
                const Text(
                  "Monthly Monitoring",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    String val =
                        kpiData['perfmonit_${index + 1}']?.toString() ?? "0";
                    if (val == "0.0") val = "0";
                    return Column(
                      children: [
                        Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8ECEF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              val,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label.replaceAll(" *", ""),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
              fontFamily: 'Roboto',
            ),
            children: [
              if (label.contains("*"))
                const TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade700,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE8ECEF),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    bool isApproved = value == "Approved";
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Evaluation KPI List",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF1A237E),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),

          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.indigo),
              ),
            )
          else ...[
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                children: [
                  _buildInfoRow("Period ID", widget.periodData?['id'] ?? '-'),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    "Period Name",
                    widget.periodData?['name'] ?? '-',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    "Teacher User ID",
                    widget.teacherData['id'] ?? '-',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    "Teacher Name",
                    widget.teacherData['name'] ?? '-',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    "Evaluation Status",
                    _planStatus,
                    isStatus: true,
                  ),
                ],
              ),
            ),

            Expanded(
              child: _kpiList.isEmpty
                  ? Center(
                      child: Text(
                        "No KPI data found.",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _kpiList.length,
                      itemBuilder: (context, index) {
                        final kpi = _kpiList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.indigo.shade50,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      kpi['kpi_code'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                kpi['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "TARGET",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          kpi['target'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "WEIGHT",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          kpi['weight'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => _fetchAndShowKpiDetail(
                                          kpi['perfpland_id'],
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade600,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.remove_red_eye_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      InkWell(
                                        onTap: () =>
                                            _fetchAndShowMonitoringDetail(
                                              kpi['perfpland_id'],
                                            ),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade600,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.timer_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "SCORE",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo.shade500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            height: 35,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value:
                                                    [
                                                      "1",
                                                      "2",
                                                      "3",
                                                      "4",
                                                    ].contains(kpi['score'])
                                                    ? kpi['score']
                                                    : "1",
                                                icon: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: Colors.blue.shade700,
                                                  size: 16,
                                                ),
                                                items: ["1", "2", "3", "4"].map(
                                                  (String val) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value: val,
                                                      child: Text(
                                                        val,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).toList(),
                                                onChanged: (String? newValue) {
                                                  if (newValue != null) {
                                                    setState(() {
                                                      kpi['score'] = newValue;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
