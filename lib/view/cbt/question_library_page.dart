import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class QuestionLibraryPage extends StatefulWidget {
  const QuestionLibraryPage({super.key});

  @override
  State<QuestionLibraryPage> createState() => _QuestionLibraryPageState();
}

class _QuestionLibraryPageState extends State<QuestionLibraryPage> {
  static final List<Map<String, dynamic>> _questionsHeaders = [
    {
      "id": "QSLIBHD20250922000001",
      "name": "Ujian Akhir Semester",
      "subject": "Matematika",
      "status": "Active",
      "randomize": "Yes",
      "questions": [
        {
          "id": "QSLIBQS001",
          "type": "Pilihan Ganda",
          "detail": "Berapakah hasil dari 5 + 5?",
          "weight": 10,
          "answers": [
            {"alias": "A", "text": "10", "isCorrect": true},
            {"alias": "B", "text": "15", "isCorrect": false},
            {"alias": "C", "text": "20", "isCorrect": false},
          ]
        },
      ]
    },
  ];

  List<Map<String, dynamic>> _filteredHeaders = [];
  final _searchController = TextEditingController();

  final List<String> _availableSubjects = [
    "Bahasa Indonesia",
    "Bahasa Inggris",
    "Biologi",
    "Fisika",
    "Kimia",
    "Matematika",
    "Pemrograman Dasar",
    "Sejarah"
  ];

  @override
  void initState() {
    super.initState();
    _filteredHeaders = _questionsHeaders;
  }

  void _filterHeaders(String query) {
    setState(() {
      _filteredHeaders = _questionsHeaders
          .where((q) =>
      q['name']!.toLowerCase().contains(query.toLowerCase()) ||
          q['subject']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    String status = 'Active';
    String randomize = 'Yes';
    String? subject;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.purple.shade50],
            ),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35)
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple.shade400, Colors.deepPurple.shade600],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.library_add_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                      "New Bank Soal",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      )
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _buildLabel("Question Header Name *", Icons.edit_note),
              TextField(
                  controller: nameCtrl,
                  decoration: _inputDeco("e.g. UAS Ganjil 2025", Icons.text_fields)
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: _buildAddDropdown(
                          "Status",
                          status,
                          ['Active', 'Inactive'],
                              (v) => status = v!,
                          Icons.toggle_on
                      )
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _buildAddDropdown(
                          "Randomize",
                          randomize,
                          ['Yes', 'No'],
                              (v) => randomize = v!,
                          Icons.shuffle
                      )
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildLabel("Subject *", Icons.subject),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: _inputDeco("Select Subject", Icons.school),
                items: _availableSubjects.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: const TextStyle(fontSize: 14))
                )).toList(),
                onChanged: (v) => subject = v,
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade400, Colors.deepPurple.shade600],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.isNotEmpty && subject != null) {
                      setState(() {
                        _questionsHeaders.insert(0, {
                          "id": "QSLIBHD${DateTime.now().millisecondsSinceEpoch}",
                          "name": nameCtrl.text,
                          "subject": subject!,
                          "status": status,
                          "randomize": randomize,
                          "questions": <Map<String, dynamic>>[],
                        });
                        _filteredHeaders = _questionsHeaders;
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                      "Create Bank Soal",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                  ),
                ),
              )
            ],
          ),
        ),
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
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.shade400,
                    Colors.deepPurple.shade600,
                    Colors.indigo.shade700,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
                title: const Text(
                  "Question Library",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
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
                    Positioned(
                      left: -50,
                      bottom: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 15, top: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  onPressed: _showAddDialog,
                  icon: const Icon(Icons.add_circle_rounded, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterHeaders,
                  decoration: InputDecoration(
                    icon: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.purple.shade400, Colors.deepPurple.shade600],
                      ).createShader(bounds),
                      child: const Icon(Icons.search_rounded, color: Colors.white, size: 26),
                    ),
                    hintText: "Search your library...",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildQuestionCard(_filteredHeaders[index], index),
                childCount: _filteredHeaders.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> item, int index) {
    bool isActive = item['status'] == 'Active';

    List<List<Color>> colorPalettes = [
      [Colors.purple.shade400, Colors.deepPurple.shade600],
      [Colors.blue.shade400, Colors.indigo.shade600],
      [Colors.pink.shade400, Colors.purple.shade600],
      [Colors.orange.shade400, Colors.deepOrange.shade600],
      [Colors.teal.shade400, Colors.cyan.shade600],
    ];

    List<Color> cardColors = colorPalettes[index % colorPalettes.length];

    String rawId = item['id'].toString();
    String displayId = rawId.length > 8 ? rawId.substring(rawId.length - 8) : rawId;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, cardColors[0].withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: cardColors[0].withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: cardColors,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: cardColors[0].withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.library_books_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF2D3142),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "ID: $displayId",
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [cardColors[0].withOpacity(0.2), cardColors[1].withOpacity(0.2)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.school_rounded, size: 14, color: cardColors[1]),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                item['subject'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: cardColors[1],
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isActive
                          ? [Colors.green.shade300, Colors.green.shade600]
                          : [Colors.red.shade300, Colors.red.shade600],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: (isActive ? Colors.green : Colors.red).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    item['status'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditQuestionLibraryPage(headerData: item)
                ),
              );
              setState(() {});
            },
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cardColors[0].withOpacity(0.1), cardColors[1].withOpacity(0.1)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.format_list_numbered_rounded,
                      size: 18,
                      color: cardColors[1],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${item['questions'].length} Questions",
                    style: TextStyle(
                      fontSize: 13,
                      color: cardColors[1],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Manage Content",
                    style: TextStyle(
                      color: cardColors[1],
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: cardColors[1],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabel(String label, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF1A237E),
          ),
        ),
      ],
    ),
  );

  InputDecoration _inputDeco(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400),
    filled: true,
    fillColor: Colors.grey.shade50,
    prefixIcon: Icon(icon, color: Colors.deepPurple.shade300, size: 20),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2),
    ),
  );

  Widget _buildAddDropdown(
      String label,
      String value,
      List<String> items,
      Function(String?) onChanged,
      IconData icon,
      ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label, icon),
          DropdownButtonFormField<String>(
            initialValue: value,
            decoration: _inputDeco("", icon),
            items: items
                .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 14)),
            ))
                .toList(),
            onChanged: onChanged,
          )
        ],
      );
}

// ==============================================================================
// HALAMAN KEDUA (MANAGE CONTENT)
// ==============================================================================
class EditQuestionLibraryPage extends StatefulWidget {
  final Map<String, dynamic> headerData;
  const EditQuestionLibraryPage({super.key, required this.headerData});

  @override
  State<EditQuestionLibraryPage> createState() => _EditQuestionLibraryPageState();
}

class _EditQuestionLibraryPageState extends State<EditQuestionLibraryPage> {
  late TextEditingController _nameCtrl;
  late String _status;
  late String _randomize;
  late String _subject;
  bool _isSelectionMode = false;
  final List<String> _selectedIds = [];

  final List<String> _availableSubjects = [
    "Bahasa Indonesia", "Bahasa Inggris", "Biologi", "Fisika", "Kimia", "Matematika", "Pemrograman Dasar", "Sejarah"
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.headerData['name']);
    _status = widget.headerData['status'];
    _randomize = widget.headerData['randomize'];
    _subject = widget.headerData['subject'];

    if (!_availableSubjects.contains(_subject)) {
      _availableSubjects.add(_subject);
    }
  }

  void _handleDelete() {
    if (!_isSelectionMode) {
      setState(() => _isSelectionMode = true);
      return;
    }
    if (_selectedIds.isEmpty) {
      setState(() => _isSelectionMode = false);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade400, Colors.red.shade600],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete_forever, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text("Confirm Delete"),
          ],
        ),
        content: Text("Delete ${_selectedIds.length} items?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.headerData['questions']
                    .removeWhere((q) => _selectedIds.contains(q['id']));
                _selectedIds.clear();
                _isSelectionMode = false;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Delete"),
          )
        ],
      ),
    );
  }

  void _showUploadOptions() {
    final List<Map<String, dynamic>> uploadFormats = [
      {'name': 'Excel', 'ext': ['xlsx', 'xls'], 'icon': Icons.table_view_rounded},
      {'name': 'CSV', 'ext': ['csv'], 'icon': Icons.list_alt_rounded},
      {'name': 'JSON', 'ext': ['json'], 'icon': Icons.data_object_rounded},
      {'name': 'Aiken (TXT)', 'ext': ['txt'], 'icon': Icons.text_snippet_rounded},
      {'name': 'GIFT (TXT)', 'ext': ['txt'], 'icon': Icons.card_giftcard_rounded},
      {'name': 'QTI / XML', 'ext': ['xml', 'zip'], 'icon': Icons.code_rounded},
    ];

    String selectedUploadType = uploadFormats[0]['name'];
    List<String> selectedExtensions = uploadFormats[0]['ext'];

    String displayId = widget.headerData['id']?.toString() ?? "12342";
    if (displayId.length > 8) {
      displayId = displayId.substring(displayId.length - 8);
    }

    String displayName = widget.headerData['name'] ?? "Lorem Ipsum";

    TextEditingController uploadNameCtrl = TextEditingController(text: displayName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.blue.shade50],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade400, Colors.indigo.shade600],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.cloud_upload_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          "Upload Questions",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(color: Colors.blue.shade100, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.fingerprint_rounded, "Header ID", displayId, Colors.purple),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.edit_note_rounded, color: Colors.orange, size: 22),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Header Name",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    TextField(
                                      controller: uploadNameCtrl,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A237E),
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                                        filled: true,
                                        fillColor: Colors.orange.shade50.withOpacity(0.5),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(color: Colors.orange.shade300, width: 1.5),
                                        ),
                                        hintText: "Enter header name...",
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(Icons.extension_rounded, size: 18, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            "Select LMS File Format *",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedUploadType,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blue.shade600),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                        items: uploadFormats.map((format) {
                          return DropdownMenuItem<String>(
                            value: format['name'],
                            child: Row(
                              children: [
                                Icon(
                                  format['icon'] as IconData,
                                  color: Colors.blue.shade400,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  format['name'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    ".${(format['ext'] as List<String>).first}",
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setModalState(() {
                            selectedUploadType = newValue!;
                            selectedExtensions = uploadFormats.firstWhere((e) => e['name'] == newValue)['ext'];
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 35),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade400, Colors.indigo.shade600],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (uploadNameCtrl.text.isNotEmpty) {
                                  setState(() {
                                    widget.headerData['name'] = uploadNameCtrl.text;
                                    _nameCtrl.text = uploadNameCtrl.text;
                                  });
                                }

                                Navigator.pop(context);
                                await _uploadFile(selectedExtensions);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.drive_folder_upload_rounded, color: Colors.white, size: 22),
                                  SizedBox(width: 8),
                                  Text(
                                    "Select File",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _uploadFile(List<String> extensions) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: extensions,
      );

      if (result != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Uploading...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "File ${result.files.single.name} uploaded successfully!",
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text("Upload failed: ${e.toString()}")),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List questions = widget.headerData['questions'];

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
                  colors: [
                    Colors.purple.shade400,
                    Colors.deepPurple.shade600,
                    Colors.indigo.shade700,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 60, bottom: 20),
                title: const Text(
                  "Manage Content",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
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
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.purple.shade50,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildHeaderField("Question Header ID", widget.headerData['id'],
                          isReadOnly: true, icon: Icons.fingerprint),
                      _buildHeaderField("Question Header Name", null,
                          controller: _nameCtrl, icon: Icons.edit_note),
                      Row(
                        children: [
                          Expanded(
                            child: _buildHeaderDropdown(
                              "Active Status",
                              _status,
                              ['Active', 'Inactive'],
                                  (v) => setState(() => _status = v!),
                              Icons.toggle_on,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildHeaderDropdown(
                              "Randomize",
                              _randomize,
                              ['Yes', 'No'],
                                  (v) => setState(() => _randomize = v!),
                              Icons.shuffle,
                            ),
                          ),
                        ],
                      ),
                      _buildHeaderDropdown(
                        "Subject",
                        _subject,
                        _availableSubjects,
                            (v) => setState(() => _subject = v!),
                        Icons.school,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child:
                            const Text("Cancel", style: TextStyle(fontSize: 15)),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade400,
                                  Colors.deepPurple.shade600
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  widget.headerData['name'] = _nameCtrl.text;
                                  widget.headerData['status'] = _status;
                                  widget.headerData['randomize'] = _randomize;
                                  widget.headerData['subject'] = _subject;
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.save_rounded, size: 18),
                                  SizedBox(width: 8),
                                  Text("Save Changes",
                                      style: TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.shade400,
                                  Colors.deepOrange.shade600
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.library_books,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Items Library",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          _buildActionBtn(
                            Icons.delete_sweep_rounded,
                            !_isSelectionMode
                                ? "Delete"
                                : (_selectedIds.isEmpty
                                ? "Cancel"
                                : "Delete (${_selectedIds.length})"),
                            [Colors.red.shade400, Colors.red.shade600],
                            _handleDelete,
                          ),
                          const SizedBox(width: 10),
                          _buildActionBtn(
                            Icons.upload_file_rounded,
                            "Upload",
                            [Colors.blue.shade400, Colors.blue.shade600],
                            _showUploadOptions,
                          ),
                          const SizedBox(width: 10),
                          _buildActionBtn(
                            Icons.add_circle_rounded,
                            "Add New",
                            [Colors.purple.shade400, Colors.deepPurple.shade600],
                                () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddQuestionPage(headerData: widget.headerData),
                                ),
                              );
                              if (res != null) {
                                setState(() => widget.headerData['questions'].add(res));
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.indigo.shade400,
                                    Colors.indigo.shade700
                                  ],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  if (_isSelectionMode) const SizedBox(width: 35),
                                  Expanded(
                                    flex: 2,
                                    child: const Text("ID", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: const Text("TYPE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: const Text("DETAIL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: const Text("WEIGHT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                  ),
                                  const SizedBox(width: 30),
                                ],
                              ),
                            ),

                            questions.isEmpty
                                ? Padding(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  Icon(Icons.inbox_rounded, size: 60, color: Colors.grey.shade300),
                                  const SizedBox(height: 12),
                                  Text("No questions yet", style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                                ],
                              ),
                            )
                                : ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: questions.length,
                              itemBuilder: (context, index) {
                                final q = questions[index];
                                final isSelected = _selectedIds.contains(q['id']);

                                String qRawId = q['id'].toString();
                                String qDisplayId = qRawId.length > 5 ? qRawId.substring(qRawId.length - 5) : qRawId;

                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: index % 2 == 0 ? Colors.grey.shade50 : Colors.white,
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
                                  ),
                                  child: Row(
                                    children: [
                                      if (_isSelectionMode)
                                        Checkbox(
                                          value: isSelected,
                                          activeColor: Colors.deepPurple,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          onChanged: (v) {
                                            setState(() {
                                              if (v!) {
                                                _selectedIds.add(q['id']);
                                              } else {
                                                _selectedIds.remove(q['id']);
                                              }
                                            });
                                          },
                                        ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          qDisplayId,
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                                          child: Text(q['type'], style: TextStyle(fontSize: 11, color: Colors.blue.shade700, fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(q['detail'], style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [Colors.purple.shade300, Colors.deepPurple.shade400]),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(q['weight'].toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit_rounded, color: Colors.orange.shade600, size: 22),
                                        onPressed: () async {
                                          final res = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddQuestionPage(
                                                headerData: widget.headerData,
                                                existingQuestion: q,
                                              ),
                                            ),
                                          );
                                          if (res != null) {
                                            setState(() => questions[index] = res);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, List<Color> colors, VoidCallback onTap) =>
      Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: colors[0].withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
            ),
            child: Column(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(height: 6),
                Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );

  Widget _buildHeaderField(String label, String? value, {bool isReadOnly = false, TextEditingController? controller, required IconData icon}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller ?? TextEditingController(text: value),
              readOnly: isReadOnly,
              decoration: InputDecoration(
                filled: true,
                fillColor: isReadOnly ? Colors.grey.shade100 : Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              ),
            ),
          ],
        ),
      );

  Widget _buildHeaderDropdown(String label, String value, List<String> items, Function(String?) onChanged, IconData icon) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: items.contains(value) ? value : null,
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              ),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      );
}

// ==============================================================================
// HALAMAN KETIGA (ADD QUESTION)
// ==============================================================================
class AddQuestionPage extends StatefulWidget {
  final Map<String, dynamic> headerData;
  final Map<String, dynamic>? existingQuestion;
  const AddQuestionPage({super.key, required this.headerData, this.existingQuestion});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _detailCtrl = TextEditingController();
  final _weightCtrl = TextEditingController(text: "1");
  String _type = "Pilihan Ganda";
  int _totalAnswers = 3;
  int _correctIndex = 0;
  final List<TextEditingController> _answerCtrls =
  List.generate(5, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    if (widget.existingQuestion != null) {
      final q = widget.existingQuestion!;
      _detailCtrl.text = q['detail'];
      _weightCtrl.text = q['weight'].toString();
      _type = q['type'];
      if (q['answers'] != null) {
        _totalAnswers = (q['answers'] as List).length;
        for (int i = 0; i < _totalAnswers; i++) {
          _answerCtrls[i].text = q['answers'][i]['text'];
          if (q['answers'][i]['isCorrect']) _correctIndex = i;
        }
      }
    }
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
                  colors: [
                    Colors.teal.shade400,
                    Colors.cyan.shade600,
                    Colors.blue.shade700,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  widget.existingQuestion == null ? "Add Question" : "Edit Question",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
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
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.cyan.shade50],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Question Detail *", Icons.quiz),
                    TextField(
                      controller: _detailCtrl,
                      maxLines: 4,
                      decoration:
                      _inputDeco("Type your question here...", Icons.edit_rounded),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            "Type *",
                            _type,
                            ["Pilihan Ganda", "Esai"],
                                (v) => setState(() => _type = v!),
                            Icons.category,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildTextField(
                            "Weight *",
                            _weightCtrl,
                            isNumber: true,
                            icon: Icons.fitness_center,
                          ),
                        ),
                      ],
                    ),
                    if (_type == "Pilihan Ganda") ...[
                      const SizedBox(height: 20),
                      _buildDropdown(
                        "Total Answer *",
                        _totalAnswers.toString(),
                        ["3", "4", "5"],
                            (v) => setState(() => _totalAnswers = int.parse(v!)),
                        Icons.format_list_numbered,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.shade400,
                                  Colors.deepOrange.shade600
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.question_answer,
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Answers",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      ...List.generate(
                        _totalAnswers,
                            (index) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _correctIndex == index
                                ? Colors.green.shade50
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: _correctIndex == index
                                  ? Colors.green.shade300
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: _correctIndex == index
                                      ? LinearGradient(
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.green.shade600
                                    ],
                                  )
                                      : LinearGradient(
                                    colors: [
                                      Colors.grey.shade300,
                                      Colors.grey.shade400
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Radio<int>(
                                  value: index,
                                  groupValue: _correctIndex,
                                  onChanged: (v) => setState(() => _correctIndex = v!),
                                  activeColor: Colors.white,
                                  fillColor: MaterialStateProperty.all(Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade300,
                                      Colors.blue.shade500
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _answerCtrls[index],
                                  decoration: InputDecoration(
                                    hintText:
                                    "Option ${String.fromCharCode(65 + index)}",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey.shade400),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade400, Colors.cyan.shade600],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_detailCtrl.text.isNotEmpty) {
                            List<Map<String, dynamic>> answers = [];
                            if (_type == "Pilihan Ganda") {
                              for (int i = 0; i < _totalAnswers; i++) {
                                answers.add({
                                  "alias": String.fromCharCode(65 + i),
                                  "text": _answerCtrls[i].text,
                                  "isCorrect": i == _correctIndex,
                                });
                              }
                            }
                            Navigator.pop(context, {
                              "id": widget.existingQuestion?['id'] ??
                                  "QSLIBQS${DateTime.now().millisecondsSinceEpoch}",
                              "type": _type,
                              "detail": _detailCtrl.text,
                              "weight": int.tryParse(_weightCtrl.text) ?? 1,
                              "image": widget.existingQuestion?['image'],
                              "answers": answers,
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.existingQuestion == null
                                  ? Icons.add_circle_rounded
                                  : Icons.check_circle_rounded,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.existingQuestion == null
                                  ? "Create Question"
                                  : "Update Question",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Colors.cyan.shade700),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF1A237E),
          ),
        ),
      ],
    ),
  );

  InputDecoration _inputDeco(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400),
    filled: true,
    fillColor: Colors.grey.shade50,
    prefixIcon: Icon(icon, color: Colors.cyan.shade600, size: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.cyan.shade400, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  );

  InputDecoration _dropdownDeco() => InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.cyan.shade400, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  );

  Widget _buildDropdown(
      String label,
      String value,
      List<String> items,
      Function(String?) onChanged,
      IconData icon,
      ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label, icon),
          DropdownButtonFormField<String>(
            initialValue: value,
            items: items
                .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 14)),
            ))
                .toList(),
            onChanged: onChanged,
            decoration: _dropdownDeco(),
          ),
        ],
      );

  Widget _buildTextField(
      String label,
      TextEditingController ctrl, {
        bool isNumber = false,
        required IconData icon,
      }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label, icon),
          TextField(
            controller: ctrl,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            inputFormatters: isNumber
                ? [FilteringTextInputFormatter.digitsOnly]
                : null,
            decoration: _inputDeco("", icon),
          ),
        ],
      );
}