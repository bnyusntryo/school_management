import 'package:flutter/material.dart';
import 'add_staff_page.dart';
import 'staff_profile_page.dart';

class StaffInformationPage extends StatefulWidget {
  const StaffInformationPage({super.key});

  @override
  State<StaffInformationPage> createState() => _StaffInformationPageState();
}

class _StaffInformationPageState extends State<StaffInformationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _staffs = [
    {"id": "staf1", "name": "Budi Santoso", "position": "Tata Usaha"},
    {"id": "staf2", "name": "Siti Aminah, S.E", "position": "Bendahara / Keuangan"},
    {"id": "staf3", "name": "Herman Pelani", "position": "Security / Keamanan"},
    {"id": "staf4", "name": "Dian Sastrowardoyo", "position": "Pustakawan"},
    {"id": "staf5", "name": "Agus Mulyono", "position": "Teknisi Lab Komputer"},
    {"id": "staf6", "name": "Rina Nose", "position": "Bimbingan Konseling (BK)"},
  ];

  List<Map<String, String>> _filteredStaffs = [];

  final List<MaterialColor> _cardColors = [
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    _filteredStaffs = _staffs;
  }

  void _filterStaffs(String query) {
    setState(() {
      _filteredStaffs = _staffs
          .where((s) =>
      s['name']!.toLowerCase().contains(query.toLowerCase()) ||
          s['position']!.toLowerCase().contains(query.toLowerCase()) ||
          s['id']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  colors: [Colors.indigo.shade400, Colors.blueGrey.shade700],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Staff Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 24),
                  tooltip: "Add Staff",
                  onPressed: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddStaffPage())
                    );

                    if (result != null && result is Map<String, String>) {
                      setState(() {
                        _staffs.insert(0, result);
                        _filteredStaffs = List.from(_staffs);
                      });

                      if(mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${result['name']} added successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.indigo.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5)),
                            ],
                            border: Border.all(color: Colors.indigo.shade50),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterStaffs,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              icon: Icon(Icons.search_rounded, color: Colors.indigo.shade400, size: 22),
                              hintText: "Search name, id, or position...",
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.normal),
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
                            _filterStaffs('');
                          },
                          icon: Icon(Icons.filter_alt_off_rounded, color: Colors.grey.shade600, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.indigo.shade50, shape: BoxShape.circle),
                        child: Icon(Icons.badge_rounded, size: 14, color: Colors.indigo.shade600),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${_filteredStaffs.length} staffs found",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            sliver: _filteredStaffs.isEmpty
                ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.person_search_rounded, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 15),
                      Text("No staffs found", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            )
                : SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final staff = _filteredStaffs[index];
                  final themeColor = _cardColors[index % _cardColors.length];

                  return _buildStaffCard(context, staff, themeColor);
                },
                childCount: _filteredStaffs.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard(BuildContext context, Map<String, String> staff, MaterialColor color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8)),
        ],
        border: Border.all(color: color.shade50, width: 2),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.assignment_ind_rounded, color: color.shade600, size: 28),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    staff['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3142)),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  Text(
                    "ID: ${staff['id']}",
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                  ),

                  const Spacer(),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200)
                    ),
                    child: Text(
                      staff['position']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StaffProfilePage(staffData: staff),
                ),
              );

              if (result != null && result is Map<String, dynamic>) {
                if (result['action'] == 'update') {
                  final updatedData = result['data'] as Map<String, String>;
                  setState(() {
                    final index = _staffs.indexWhere((s) => s['id'] == updatedData['id']);
                    if (index != -1) {
                      _staffs[index] = updatedData;
                    }
                    _filteredStaffs = List.from(_staffs);
                  });
                } else if (result['action'] == 'delete') {
                  final deletedId = result['id'];
                  setState(() {
                    _staffs.removeWhere((s) => s['id'] == deletedId);
                    _filteredStaffs = List.from(_staffs);
                  });
                }
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: color.shade500,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit_note_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    "Select Staff",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}