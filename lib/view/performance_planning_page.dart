import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/pref.dart';

class SubKPIListPage extends StatefulWidget {
  final Map<String, dynamic> teacherData;
  final Map<String, dynamic> periodData;
  const SubKPIListPage({super.key, required this.teacherData, required this.periodData});

  @override
  State<SubKPIListPage> createState() => _SubKPIListPageState();
}

class _SubKPIListPageState extends State<SubKPIListPage> {
  List<Map<String, dynamic>> _apiKpis = [];
  String _planStatus = "Unapproved";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKPIData();
  }

  Future<void> _fetchKPIData() async {
    try {
      String? token = await Session().getUserToken();
      String periodId = widget.periodData['id'] ?? '';
      String teacherId = widget.teacherData['id'] ?? '';
      String planHId = widget.teacherData['perfplanh_id'] ?? '';

      var detailReq = await http.post(
        Uri.parse('https://schoolapp-api-dev.zeabur.app/api/teacherperf/plan/detail'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({
          "perfperiod_id": periodId,
          "teacher_userid": teacherId
        }),
      );

      if (detailReq.statusCode == 200) {
        var decodedDetail = jsonDecode(detailReq.body);
        if (decodedDetail['data'] != null) {
          _planStatus = decodedDetail['data']['status']?.toString() ?? "Unapproved";
          widget.teacherData['status'] = _planStatus;
        }
      }

      if (planHId.isNotEmpty) {
        var listKpiReq = await http.post(
          Uri.parse('https://schoolapp-api-dev.zeabur.app/api/teacherperf/plan/detail/list-kpi'),
          headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
          body: jsonEncode({
            "perfperiod_id": periodId,
            "perfplanh_id": planHId
          }),
        );

        if (listKpiReq.statusCode == 200) {
          var decodedList = jsonDecode(listKpiReq.body);
          List dataList = decodedList['data'] ?? [];

          _apiKpis = dataList.map((item) {
            return {
              "perfpland_id": item['perfpland_id']?.toString() ?? "",
              "code": item['kpi_code']?.toString() ?? "",
              "name": item['kpilibrary_name']?.toString() ?? "Unknown KPI",
              "target": item['target']?.toString() ?? "0",
              "weight": item['weight']?.toString() ?? "0",
              "description": "-",
              "assessment": "",
              "monthlyData": List.filled(12, "0"),
            };
          }).toList();

          widget.teacherData['kpis'] = _apiKpis;
        }
      }

      if (mounted) setState(() => _isLoading = false);

    } catch (e) {
      print("🚨 Error fetch KPI data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showKPIDialog({Map<String, dynamic>? existingKpi, int? index}) {
    final isEdit = existingKpi != null;

    final codeCtrl = TextEditingController(text: existingKpi?['code'] ?? "KPI_NEW");
    final nameCtrl = TextEditingController(text: existingKpi?['name'] ?? "");
    final descCtrl = TextEditingController(text: existingKpi?['description'] ?? "-");
    final weightCtrl = TextEditingController(text: existingKpi?['weight'] ?? "");
    final targetCtrl = TextEditingController(text: existingKpi?['target'] ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(isEdit ? Icons.edit_note_rounded : Icons.add_task_rounded, color: Colors.indigo.shade600),
            const SizedBox(width: 10),
            Text(isEdit ? "Edit Performance Plan KPI" : "Add Performance Plan KPI", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField("KPI Code", codeCtrl, isReadOnly: isEdit),
              const SizedBox(height: 12),
              _buildDialogField("KPI Name", nameCtrl, isReadOnly: isEdit),
              const SizedBox(height: 12),
              _buildDialogField("KPI Description", descCtrl, isReadOnly: isEdit),
              const SizedBox(height: 12),
              _buildDialogField("Weight *", weightCtrl, isNumber: true),
              const SizedBox(height: 12),
              _buildDialogField("Target *", targetCtrl, isNumber: true),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(backgroundColor: Colors.blueGrey.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text("Cancel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))
          ),
          if (isEdit)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _apiKpis.removeAt(index!);
                  widget.teacherData['kpis'] = _apiKpis;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("KPI Deleted"), backgroundColor: Colors.red));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (!isEdit) {
                  _apiKpis.add({
                    "code": codeCtrl.text.isEmpty ? "KPI_NEW" : codeCtrl.text,
                    "name": nameCtrl.text,
                    "description": descCtrl.text,
                    "weight": weightCtrl.text,
                    "target": targetCtrl.text,
                    "assessment": "",
                    "monthlyData": List.filled(12, "0"),
                  });
                } else {
                  _apiKpis[index!] = {
                    ...existingKpi,
                    "weight": weightCtrl.text,
                    "target": targetCtrl.text,
                  };
                }
                widget.teacherData['kpis'] = _apiKpis;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildDialogField(String label, TextEditingController controller, {bool isReadOnly = false, bool isNumber = false}) {
    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isReadOnly ? Colors.blueGrey.shade700 : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        filled: true,
        fillColor: isReadOnly ? Colors.blueGrey.shade50 : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isReadOnly ? Colors.grey.shade300 : Colors.indigo.shade400, width: 1.5)),
      ),
    );
  }

  Widget _buildDetailHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 15, 20, 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
        border: Border.all(color: Colors.blue.shade50, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 8),
              const Text("Plan Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),

          _buildInfoRow("Period ID", widget.periodData['id'] ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow("Period Name", widget.periodData['name'] ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow("Teacher ID", widget.teacherData['id'] ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow("Teacher Name", widget.teacherData['name'] ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow("Plan Status", _planStatus, isStatus: true),
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
          child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
        ),
        const Text(" :  ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        Expanded(
          child: isStatus
              ? Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: isApproved ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: isApproved ? Colors.green.shade200 : Colors.red.shade200)
              ),
              child: Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isApproved ? Colors.green.shade700 : Colors.red.shade700)),
            ),
          )
              : Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final kpis = _apiKpis;
    final isApproved = _planStatus == "Approved";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text("KPI Planning", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          if (!isApproved)
            Container(
              margin: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
              child: IconButton(onPressed: () => _showKPIDialog(), icon: Icon(Icons.add_task_rounded, color: Colors.blue.shade600)),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Column(
        children: [
          _buildDetailHeader(),

          if (!isApproved)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _planStatus = "Approved";
                        widget.teacherData['status'] = _planStatus;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Plan Approved!"), backgroundColor: Colors.green));
                    },
                    icon: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                    label: const Text("Approve Planning Form", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade400,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 1,
                    ),
                  ),
                ],
              ),
            ),

          if (isApproved || kpis.isEmpty) const SizedBox(height: 10),

          Expanded(
            child: kpis.isEmpty
                ? Center(child: Text("No KPI planned yet.", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)))
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
              itemCount: kpis.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blue.shade50)),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

                    // 💡 PELATUK DI PINDAH KE SINI: Seluruh kotak bisa diklik!
                    onTap: isApproved ? null : () => _showKPIDialog(existingKpi: kpis[index], index: index),

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
                    trailing: isApproved
                        ? Icon(Icons.check_circle, color: Colors.green.shade400)
                        : Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300),
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