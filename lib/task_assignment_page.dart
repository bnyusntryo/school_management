import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskAssignmentPage extends StatefulWidget {
  const TaskAssignmentPage({super.key});

  @override
  State<TaskAssignmentPage> createState() => _TaskAssignmentPageState();
}

class _TaskAssignmentPageState extends State<TaskAssignmentPage> {
  int _currentView = 0;

  final Color princGradientStart = const Color(0xFF3949AB);
  final Color princGradientEnd = const Color(0xFF1A237E);
  final Color textDark = const Color(0xFF1E293B);

  final TextEditingController _searchController = TextEditingController();

  String? _formUserType;
  final TextEditingController _formTaskForCtrl = TextEditingController();
  final TextEditingController _formTitleCtrl = TextEditingController();
  final TextEditingController _formDescCtrl = TextEditingController();
  DateTime? _formEstFinishDate;

  final TextEditingController _editIdCtrl = TextEditingController();
  final TextEditingController _editTaskForTypeCtrl = TextEditingController();
  final TextEditingController _editTaskForNameCtrl = TextEditingController();
  final TextEditingController _editTitleCtrl = TextEditingController();
  final TextEditingController _editDescCtrl = TextEditingController();
  DateTime? _editEstFinishDate;
  DateTime? _editRealFinishDate;
  String? _editStatus;

  final List<Map<String, String>> _allTasks = [
    {
      "id": "TASK2026010900000001",
      "assignedTo": "Dummy Staff 1",
      "title": "Test",
      "estFinish": "11 Jan 2026",
      "realFinish": "09 Jan 2026",
      "status": "On Progress",
      "desc": "Test assignment edit",
      "type": "STAFF",
    },
    {
      "id": "TASK2026020600000001",
      "assignedTo": "Bpk. Alexander",
      "title": "Input Nilai Raport",
      "estFinish": "05 Feb 2026",
      "realFinish": "-",
      "status": "No Progress",
      "desc": "Harap segera input nilai raport semester ganjil.",
      "type": "TEACHER",
    },
    {
      "id": "TASK2026021000000001",
      "assignedTo": "Banyu Bintang",
      "title": "Remedial Matematika",
      "estFinish": "09 Feb 2026",
      "realFinish": "-",
      "status": "No Progress",
      "desc": "Mengerjakan soal remedial matematika bab aljabar.",
      "type": "STUDENT",
    },
  ];

  List<Map<String, String>> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _filteredTasks = _allTasks;
  }

  void _filterTasks(String query) {
    setState(() {
      _filteredTasks = _allTasks.where((task) {
        return task['title']!.toLowerCase().contains(query.toLowerCase()) ||
            task['id']!.toLowerCase().contains(query.toLowerCase()) ||
            task['assignedTo']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _clearFilter() {
    _searchController.clear();
    _filterTasks('');
    FocusScope.of(context).unfocus();
  }

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? initialDate) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: princGradientStart,
              onPrimary: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  void _resetAddForm() {
    _formUserType = null;
    _formTaskForCtrl.clear();
    _formTitleCtrl.clear();
    _formDescCtrl.clear();
    _formEstFinishDate = null;
  }

  void _openEditForm(Map<String, String> task) {
    _editIdCtrl.text = task['id']!;
    _editTaskForTypeCtrl.text = task['type'] ?? "STAFF";
    _editTaskForNameCtrl.text = task['assignedTo']!;
    _editTitleCtrl.text = task['title']!;
    _editDescCtrl.text = task['desc'] ?? "";
    _editStatus = task['status'];

    try {
      _editEstFinishDate = DateFormat("dd MMM yyyy").parse(task['estFinish']!);
    } catch (e) {
      _editEstFinishDate = null;
    }
    try {
      _editRealFinishDate = task['realFinish'] != "-"
          ? DateFormat("dd MMM yyyy").parse(task['realFinish']!)
          : null;
    } catch (e) {
      _editRealFinishDate = null;
    }

    setState(() {
      _currentView = 2;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _formTaskForCtrl.dispose();
    _formTitleCtrl.dispose();
    _formDescCtrl.dispose();
    _editIdCtrl.dispose();
    _editTaskForTypeCtrl.dispose();
    _editTaskForNameCtrl.dispose();
    _editTitleCtrl.dispose();
    _editDescCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: _buildCurrentView(),
    );
  }

  Widget _buildCurrentView() {
    if (_currentView == 1) return _buildAddTaskScreen();
    if (_currentView == 2) return _buildEditTaskScreen();
    return _buildTaskListScreen();
  }

  Widget _buildTaskListScreen() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 130,
          floating: false,
          pinned: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [princGradientStart, princGradientEnd],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: princGradientEnd.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                const FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                  title: Text(
                    "Task Assignment List",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
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
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
            child: Row(
              children: [
                InkWell(
                  onTap: _clearFilter,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_alt_off_rounded,
                            color: Colors.blue.shade600, size: 18),
                        const SizedBox(width: 5),
                        Text(
                          "Clear",
                          style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterTasks,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: Icon(Icons.search_rounded,
                            color: Colors.grey.shade400),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => setState(() => _currentView = 1),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [princGradientStart, princGradientEnd]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: princGradientEnd.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.add_rounded, color: Colors.white, size: 18),
                        SizedBox(width: 5),
                        Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          sliver: _filteredTasks.isEmpty
              ? SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.assignment_late_rounded,
                        size: 60, color: Colors.grey.shade300),
                    const SizedBox(height: 10),
                    Text(
                      "No tasks found",
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return _buildTaskCard(_filteredTasks[index]);
              },
              childCount: _filteredTasks.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildTaskCard(Map<String, String> task) {
    bool isOnProgress = task['status'] == 'On Progress';
    Color statusColor =
    isOnProgress ? Colors.blue.shade700 : Colors.red.shade700;
    Color statusBg = isOnProgress ? Colors.blue.shade50 : Colors.red.shade50;
    IconData statusIcon =
    isOnProgress ? Icons.sync_rounded : Icons.pause_circle_filled_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 5)),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment_rounded,
                        size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Text(
                      task['id']!,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade700),
                    ),
                  ],
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        task['status']!,
                        style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['title']!,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: textDark),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.person_rounded,
                              size: 14, color: princGradientStart),
                          const SizedBox(width: 5),
                          Text(
                            task['assignedTo']!,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: princGradientStart),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Estimate Finish",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  task['estFinish']!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: textDark,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: 25,
                              width: 1,
                              color: Colors.grey.shade300),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Real Finish",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  task['realFinish']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: task['realFinish'] == '-'
                                        ? Colors.red.shade400
                                        : Colors.green.shade600,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => _openEditForm(task),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50, shape: BoxShape.circle),
                    child: Icon(Icons.edit_rounded,
                        color: Colors.blue.shade600, size: 18),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskScreen() {
    String estDateStr = _formEstFinishDate != null
        ? DateFormat('dd/MM/yyyy').format(_formEstFinishDate!)
        : "Select estimate finish date";

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 130,
          floating: false,
          pinned: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [princGradientStart, princGradientEnd]),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: princGradientEnd.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 60, bottom: 20),
              title: Text(
                "Add Task Assignment",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
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
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () {
                _resetAddForm();
                setState(() => _currentView = 0);
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("User Type", isRequired: true),
                  DropdownButtonFormField<String>(
                    value: _formUserType,
                    hint: Text(
                      "Select Option",
                      style: TextStyle(
                          color: Colors.grey.shade400, fontSize: 13),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey),
                    decoration: _getInputDecoration(
                        Icons.group_rounded, Colors.purple.shade400),
                    items: ["Teacher", "Staff"].map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textDark,
                              fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _formUserType = val),
                  ),
                  const SizedBox(height: 20),

                  _buildFormLabel("Task For Name", isRequired: true),
                  TextFormField(
                    controller: _formTaskForCtrl,
                    decoration: _getInputDecoration(
                        Icons.person_pin_rounded, Colors.orange.shade500,
                        hint: "Enter assignee name..."),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textDark),
                  ),
                  const SizedBox(height: 20),

                  _buildFormLabel("Title", isRequired: true),
                  TextFormField(
                    controller: _formTitleCtrl,
                    decoration: _getInputDecoration(
                        Icons.subtitles_rounded, Colors.teal.shade400,
                        hint: "Enter task title..."),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textDark),
                  ),
                  const SizedBox(height: 20),

                  _buildFormLabel("Description", isRequired: true),
                  TextFormField(
                    controller: _formDescCtrl,
                    maxLines: 4,
                    decoration: _getInputDecoration(
                        Icons.description_rounded, Colors.pink.shade400,
                        hint: "Describe the task details..."),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textDark,
                        height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  _buildFormLabel("Estimate Finish Date", isRequired: true),
                  InkWell(
                    onTap: () async {
                      DateTime? picked =
                      await _selectDate(context, _formEstFinishDate);
                      if (picked != null) {
                        setState(() => _formEstFinishDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _formEstFinishDate != null
                                ? princGradientStart.withOpacity(0.5)
                                : Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded,
                              color: Colors.green.shade500, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            estDateStr,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: _formEstFinishDate != null
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _formEstFinishDate != null
                                  ? textDark
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildFormLabel("Task Assign Attachment", isRequired: false),
                  _buildAttachmentBox(),
                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _resetAddForm();
                          setState(() => _currentView = 0);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 14),
                          backgroundColor: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Task successfully created!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _resetAddForm();
                          setState(() => _currentView = 0);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: princGradientStart,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }

  Widget _buildEditTaskScreen() {
    String estDateStr = _editEstFinishDate != null
        ? DateFormat('dd/MM/yyyy').format(_editEstFinishDate!)
        : "Select date";
    String realDateStr = _editRealFinishDate != null
        ? DateFormat('dd/MM/yyyy').format(_editRealFinishDate!)
        : "Select date";

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 130,
          floating: false,
          pinned: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [princGradientStart, princGradientEnd]),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: princGradientEnd.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 60, bottom: 20),
              title: Text(
                "Edit Task Assignment",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
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
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => setState(() => _currentView = 0),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormLabel("Task ID", isRequired: true),
                  TextFormField(
                    controller: _editIdCtrl,
                    readOnly: true,
                    decoration: _getInputDecoration(
                        Icons.tag_rounded, Colors.grey,
                        isEnabled: false),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),

                  _buildFormLabel("Task For", isRequired: true),
                  TextFormField(
                    controller: _editTaskForTypeCtrl,
                    readOnly: true,
                    decoration: _getInputDecoration(
                        Icons.group_rounded, Colors.grey,
                        isEnabled: false),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),

                  _buildFormLabel("Task For Name", isRequired: true),
                  TextFormField(
                    controller: _editTaskForNameCtrl,
                    readOnly: true,
                    decoration: _getInputDecoration(
                        Icons.person_pin_rounded, Colors.grey,
                        isEnabled: false),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),

                  _buildFormLabel("Title", isRequired: true),
                  TextFormField(
                    controller: _editTitleCtrl,
                    decoration: _getInputDecoration(
                        Icons.subtitles_rounded, Colors.teal.shade400),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textDark),
                  ),
                  const SizedBox(height: 20),

                  _buildFormLabel("Description", isRequired: true),
                  TextFormField(
                    controller: _editDescCtrl,
                    maxLines: 4,
                    decoration: _getInputDecoration(
                        Icons.description_rounded, Colors.pink.shade400),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textDark,
                        height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  _buildFormLabel("Estimate Finish Date", isRequired: true),
                  InkWell(
                    onTap: () async {
                      DateTime? picked =
                      await _selectDate(context, _editEstFinishDate);
                      if (picked != null) {
                        setState(() => _editEstFinishDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded,
                              color: Colors.green.shade500, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            estDateStr,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textDark),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildFormLabel("Realization Finish Date", isRequired: true),
                  InkWell(
                    onTap: () async {
                      DateTime? picked = await _selectDate(
                          context, _editRealFinishDate ?? DateTime.now());
                      if (picked != null) {
                        setState(() => _editRealFinishDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.event_available_rounded,
                              color: Colors.purple.shade400, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            realDateStr,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textDark),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildFormLabel("Task Assign Attachment", isRequired: false),
                  _buildAttachmentBox(),
                  const SizedBox(height: 10),
                  _buildAttachedFileItem(
                      "0e222ae1-4ef6-4206-a78a-0f4b545ddaed.txt"),
                  _buildAttachedFileItem(
                      "6dc434ae-2628-40c6-8fdf-1f61013df3b2.xlsx"),
                  const SizedBox(height: 30),

                  _buildFormLabel("Status", isRequired: true),
                  DropdownButtonFormField<String>(
                    value: _editStatus,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey),
                    decoration: _getInputDecoration(
                        Icons.sync_rounded, Colors.blue.shade600),
                    items: ["On Progress", "No Progress", "Done"]
                        .map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textDark,
                              fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _editStatus = val),
                  ),
                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Task Deleted!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          setState(() => _currentView = 0);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => setState(() => _currentView = 0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Task Updated Successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          setState(() => _currentView = 0);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: princGradientStart,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }

  Widget _buildFormLabel(String title, {required bool isRequired}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700),
          ),
          if (isRequired)
            const Text(
              " *",
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
        ],
      ),
    );
  }

  InputDecoration _getInputDecoration(IconData icon, Color iconColor,
      {String? hint, bool isEnabled = true}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13,
          fontWeight: FontWeight.w400),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      filled: true,
      fillColor: isEnabled ? Colors.grey.shade50 : Colors.grey.shade200,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: isEnabled ? princGradientStart : Colors.grey.shade300,
            width: 1.5),
      ),
    );
  }

  Widget _buildAttachmentBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: Colors.blue.shade300,
            width: 1.5,
            style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded,
                    size: 16, color: Colors.white),
                label: const Text(
                  "Choose",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.upload_file_rounded,
                    size: 16, color: Colors.grey.shade600),
                label: Text(
                  "Upload",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey.shade700),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Icon(Icons.cloud_upload_rounded,
              size: 40, color: Colors.blue.shade200),
          const SizedBox(height: 10),
          Text(
            "Drag and drop up to 3 files to upload.",
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachedFileItem(String filename) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 10),
      child: Row(
        children: [
          Icon(Icons.file_download_outlined,
              color: Colors.blue.shade600, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              filename,
              style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}