import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../config/pref.dart'; // Sesuaikan path ini dengan lokasi file Session/Token Anda

class TaskAssignmentPage extends StatefulWidget {
  const TaskAssignmentPage({super.key});

  @override
  State<TaskAssignmentPage> createState() => _TaskAssignmentPageState();
}

class _TaskAssignmentPageState extends State<TaskAssignmentPage> {
  List<dynamic> _taskList = [];
  bool _isLoading = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  // 💡 MESIN PENARIK DATA DAFTAR TUGAS
  Future<void> _fetchTasks() async {
    setState(() => _isLoading = true);
    try {
      String? token = await Session().getUserToken();

      var req = await http.post(
        Uri.parse(
          'https://schoolapp-api-dev.zeabur.app/api/principal/taskassignment',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "limit": 15,
          "offset": 0,
          "sortField": "tsk.created_at",
          "sortOrder": 1,
          "filters": {
            "taskassign_id": "",
            "taskassign_for": "",
            "taskassign_title": "",
            "taskassign_status": "",
          },
          "global": _searchQuery, // 💡 Query pencarian akan masuk ke sini
        }),
      );

      if (req.statusCode == 200) {
        var res = jsonDecode(req.body);
        if (res['data'] != null && mounted) {
          setState(() {
            _taskList = res['data'];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      print("🚨 Error Fetching Task Assignments: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 💡 FUNGSI PENGUBAH FORMAT TANGGAL
  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty || rawDate == "-") return "-";
    try {
      DateTime parsed = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy HH:mm').format(parsed);
    } catch (e) {
      return rawDate;
    }
  }

  // 💡 FUNGSI PENERJEMAH STATUS & WARNA
  Map<String, dynamic> _getStatusStyle(String statusCode) {
    switch (statusCode) {
      case "OP":
        return {
          "text": "On Progress",
          "color": Colors.blue.shade600,
          "bg": Colors.blue.shade50,
        };
      case "NP":
        return {
          "text": "No Progress",
          "color": Colors.orange.shade700,
          "bg": Colors.orange.shade50,
        };
      case "DN": // Asumsi untuk Done (Bisa disesuaikan nanti)
        return {
          "text": "Done",
          "color": Colors.green.shade600,
          "bg": Colors.green.shade50,
        };
      default:
        return {
          "text": statusCode,
          "color": Colors.grey.shade700,
          "bg": Colors.grey.shade100,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade800, // Warna khas Principal
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Task Assignment List",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // 💡 KOTAK PENCARIAN (SEARCH BAR)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.indigo.shade800,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.shade900.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              onSubmitted: (value) {
                _searchQuery = value;
                _fetchTasks();
              },
              decoration: InputDecoration(
                hintText: "Search tasks...",
                hintStyle: TextStyle(color: Colors.indigo.shade200),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.indigo.shade200,
                ),
                filled: true,
                fillColor: Colors.indigo.shade700,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
            ),
          ),

          // 💡 LIST DAFTAR TUGAS
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.indigo),
                  )
                : _taskList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_turned_in_rounded,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "No tasks assigned yet.",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: Colors.indigo,
                    onRefresh: _fetchTasks,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _taskList.length,
                      itemBuilder: (context, index) {
                        var task = _taskList[index];
                        var statusStyle = _getStatusStyle(
                          task['taskassign_status']?.toString() ?? "",
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(color: Colors.indigo.shade50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header: Status & Assignee
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusStyle['bg'],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        statusStyle['text'],
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: statusStyle['color'],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person_rounded,
                                          size: 14,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          task['taskassign_for'] ?? "-",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                // Judul Task
                                Text(
                                  task['taskassign_title'] ?? "Untitled Task",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Informasi Tanggal
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_rounded,
                                            size: 16,
                                            color: Colors.orange.shade400,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Est. Finish:",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            _formatDate(
                                              task['estimate_finish_date'],
                                            ),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        child: Divider(height: 1),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline_rounded,
                                            size: 16,
                                            color: Colors.green.shade400,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Real Finish:",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            _formatDate(
                                              task['real_finish_date'],
                                            ),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Tombol Edit (Action)
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      // TODO: Arahkan ke halaman Edit/Detail Task
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Fitur Edit menunggu intelijen berikutnya!",
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit_rounded,
                                      size: 16,
                                      color: Colors.indigo.shade600,
                                    ),
                                    label: Text(
                                      "Edit Task",
                                      style: TextStyle(
                                        color: Colors.indigo.shade600,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.indigo.shade200,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),

      // 💡 TOMBOL + ADD TUGAS BARU
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Arahkan ke halaman Form Add Task
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Fitur Add Task menunggu intelijen berikutnya!"),
            ),
          );
        },
        backgroundColor: Colors.indigo.shade600,
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: const Text(
          "New Task",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
