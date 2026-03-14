import 'package:flutter/material.dart';

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