import 'package:flutter/material.dart';

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