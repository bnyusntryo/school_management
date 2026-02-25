import 'package:flutter/material.dart';

class MonitoringExamPage extends StatefulWidget {
  const MonitoringExamPage({super.key});

  @override
  State<MonitoringExamPage> createState() => _MonitoringExamPageState();
}

class _MonitoringExamPageState extends State<MonitoringExamPage> {
  final List<Map<String, dynamic>> _monitoringSessions = [
    {
      "id": "EXSES202511240001",
      "sessionName": "PAI X AK 1",
      "subject": "Pendidikan Agama Islam",
      "className": "X AK 1",
      "date": "03-Dec-2025",
      "time": "07:00 - 15:00",
      "status": "Active",
      "totalParticipants": 35,
      "working": 32,
      "finished": 3,
    },
    {
      "id": "EXSES202511290002",
      "sessionName": "PKN X AK 1",
      "subject": "Pendidikan Pancasila",
      "className": "X AK 1",
      "date": "03-Dec-2025",
      "time": "07:40 - 15:00",
      "status": "Scheduled",
      "totalParticipants": 35,
      "working": 0,
      "finished": 0,
    },
    {
      "id": "EXSES202512030003",
      "sessionName": "BAHASA INDONESIA X AK 1",
      "subject": "Bahasa Indonesia",
      "className": "X AK 1",
      "date": "02-Dec-2025",
      "time": "07:00 - 14:00",
      "status": "Finished",
      "totalParticipants": 34,
      "working": 0,
      "finished": 34,
    },
  ];

  List<Map<String, dynamic>> _filteredSessions = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredSessions = _monitoringSessions;
  }

  void _filterSessions(String query) {
    setState(() {
      _filteredSessions = _monitoringSessions
          .where((s) =>
      s['sessionName']!.toLowerCase().contains(query.toLowerCase()) ||
          s['subject']!.toLowerCase().contains(query.toLowerCase()) ||
          s['id']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple.shade500, Colors.deepPurple.shade700],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 60, bottom: 18),
                title: const Text(
                  "Monitoring Exam",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                ),
                background: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
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
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.purple.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5)),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterSessions,
                        decoration: InputDecoration(
                          icon: Icon(Icons.search_rounded, color: Colors.purple.shade400),
                          hintText: "Search session or subject...",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _filterSessions('');
                      },
                      icon: Icon(Icons.filter_alt_off_rounded, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
            sliver: _filteredSessions.isEmpty
                ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.monitor_heart_rounded, size: 60, color: Colors.grey.shade300),
                    const SizedBox(height: 15),
                    Text(
                      "No Exam Sessions Found",
                      style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _buildMonitoringCard(_filteredSessions[index]);
                },
                childCount: _filteredSessions.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonitoringCard(Map<String, dynamic> data) {
    Color statusColor;
    Color statusBgColor;
    IconData statusIcon;

    switch (data['status']) {
      case 'Active':
        statusColor = Colors.green.shade700;
        statusBgColor = Colors.green.shade50;
        statusIcon = Icons.sensors_rounded;
        break;
      case 'Finished':
        statusColor = Colors.blue.shade700;
        statusBgColor = Colors.blue.shade50;
        statusIcon = Icons.task_alt_rounded;
        break;
      default:
        statusColor = Colors.orange.shade700;
        statusBgColor = Colors.orange.shade50;
        statusIcon = Icons.schedule_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.purple.shade50.withOpacity(0.5),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data['id'],
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurple.shade700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        data['status'].toUpperCase(),
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['sessionName'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                ),
                const SizedBox(height: 12),

                _buildInfoRow(Icons.menu_book_rounded, data['subject']),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.class_rounded, data['className']),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.access_time_filled_rounded, "${data['date']} • ${data['time']}"),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn("Total", data['totalParticipants'].toString(), Icons.groups_rounded, Colors.grey.shade700),
                      Container(height: 30, width: 1, color: Colors.grey.shade300),
                      _buildStatColumn("Working", data['working'].toString(), Icons.computer_rounded, Colors.orange.shade600),
                      Container(height: 30, width: 1, color: Colors.grey.shade300),
                      _buildStatColumn("Finished", data['finished'].toString(), Icons.check_circle_rounded, Colors.green.shade600),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: data['status'] == 'Scheduled' ? null : () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListParticipantPage(sessionData: data),
                      )
                  );
                },
                icon: const Icon(Icons.monitor_rounded, size: 18),
                label: const Text("Live Monitor", style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade600,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
      ],
    );
  }
}

class ListParticipantPage extends StatefulWidget {
  final Map<String, dynamic> sessionData;

  const ListParticipantPage({super.key, required this.sessionData});

  @override
  State<ListParticipantPage> createState() => _ListParticipantPageState();
}

class _ListParticipantPageState extends State<ListParticipantPage> {
  final List<Map<String, dynamic>> _participants = [
    {
      "examParticipantId": "EXPAR202511240001",
      "userId": "25049120",
      "fullName": "Abdullah Widodo",
      "className": "X AK 1",
      "attempt": "1 / 1",
      "startTime": "2025 Dec 03 10:12",
      "endTime": "2025 Dec 03 10:12"
    },
    {
      "examParticipantId": "EXPAR202511240002",
      "userId": "25049121",
      "fullName": "Andika Prastyo",
      "className": "X AK 1",
      "attempt": "1 / 1",
      "startTime": "2025 Dec 03 10:12",
      "endTime": "2025 Dec 03 10:12"
    },
    {
      "examParticipantId": "EXPAR202511240003",
      "userId": "25049122",
      "fullName": "ARDIAN RESTU TRIAJI",
      "className": "X AK 1",
      "attempt": "1 / 1",
      "startTime": "2025 Dec 03 10:12",
      "endTime": "2025 Dec 03 10:12"
    },
    {
      "examParticipantId": "EXPAR202511240004",
      "userId": "25049123",
      "fullName": "ARSYVA RAHMAH",
      "className": "X AK 1",
      "attempt": "1 / 1",
      "startTime": "2025 Dec 03 10:12",
      "endTime": "-"
    },
  ];

  List<Map<String, dynamic>> _filteredParticipants = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredParticipants = _participants;
  }

  void _filterParticipants(String query) {
    setState(() {
      _filteredParticipants = _participants
          .where((p) =>
      p['fullName']!.toLowerCase().contains(query.toLowerCase()) ||
          p['userId']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _confirmResetAttempt(Map<String, dynamic> participant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
              child: Icon(Icons.restore_rounded, color: Colors.red.shade600),
            ),
            const SizedBox(width: 10),
            const Text("Reset Attempt", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontFamily: 'Roboto'),
            children: [
              const TextSpan(text: "Are you sure you want to reset the attempt for "),
              TextSpan(text: '"${participant['fullName']}"', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              const TextSpan(text: "? Their previous answers might be cleared."),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                participant['attempt'] = "0 / 1";
                participant['endTime'] = "-";
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Attempt for ${participant['fullName']} has been reset."),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Reset", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  colors: [Colors.purple.shade500, Colors.deepPurple.shade700],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "List Participant",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
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
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.purple.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                    border: Border.all(color: Colors.purple.shade50),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.monitor_rounded, color: Colors.purple.shade400, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            "Session Details",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(widget.sessionData['sessionName'] ?? "Unknown Session", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 6),
                      Text("Subject: ${widget.sessionData['subject']}", style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      Text("Class: ${widget.sessionData['className']}", style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterParticipants,
                            decoration: InputDecoration(
                              hintText: "Search user ID or name...",
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                              icon: Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 18),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _filterParticipants('');
                          },
                          icon: Icon(Icons.filter_alt_off_rounded, color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Participants (${_filteredParticipants.length})",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                  ),
                ),
                const SizedBox(height: 10),

                ListView.builder(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredParticipants.length,
                  itemBuilder: (context, index) {
                    final participant = _filteredParticipants[index];
                    bool isFinished = participant['endTime'] != "-";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.indigo.shade50),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                              border: Border(bottom: BorderSide(color: Colors.indigo.shade50)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  participant['examParticipantId'],
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.indigo.shade700),
                                ),
                                InkWell(
                                  onTap: () => _confirmResetAttempt(participant),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.red.shade200),
                                    ),
                                    child: Icon(Icons.restore_rounded, size: 16, color: Colors.red.shade600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        participant['fullName'],
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isFinished ? Colors.green.shade50 : Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "Attempt: ${participant['attempt']}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: isFinished ? Colors.green.shade700 : Colors.orange.shade700
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.badge_rounded, size: 12, color: Colors.grey.shade500),
                                    const SizedBox(width: 4),
                                    Text(participant['userId'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                                    const SizedBox(width: 15),
                                    Icon(Icons.class_rounded, size: 12, color: Colors.grey.shade500),
                                    const SizedBox(width: 4),
                                    Text(participant['className'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(height: 1, color: Color(0xFFF0F0F0)),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("START TIME", style: TextStyle(fontSize: 9, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(participant['startTime'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.grey.shade400),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("END TIME", style: TextStyle(fontSize: 9, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(
                                            participant['endTime'],
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: isFinished ? Colors.black87 : Colors.orange.shade700
                                            )
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}