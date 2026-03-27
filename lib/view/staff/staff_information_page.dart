import 'package:flutter/material.dart';
import 'package:school_management/view/staff/staff_detail_page.dart';
import '../../model/staff_info_model.dart';
import '../../viewmodel/staff_viewmodel.dart';
import 'add_staff_page.dart';

class StaffInformationPage extends StatefulWidget {
  const StaffInformationPage({super.key});

  @override
  State<StaffInformationPage> createState() => _StaffInformationPageState();
}

class _StaffInformationPageState extends State<StaffInformationPage> {
  final _viewModel = StaffViewModel();
  final _searchController = TextEditingController();

  bool _isLoading = true;
  List<StaffInfoModel> _staffList = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchStaff();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchStaff({String keyword = ''}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final resp = await _viewModel.getStaffList(keyword: keyword);
      if (!mounted) return;

      if (resp.data != null) {
        final List<dynamic> dataList = resp.data as List<dynamic>;
        setState(() {
          _staffList = dataList.map((e) => StaffInfoModel.fromJson(e)).toList();
        });
      } else {
        setState(() => _errorMessage = resp.message?.toString() ?? 'Gagal memuat data');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Error Parse: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Staff Directory',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStaffPage()),
          );
        },
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 4,
        highlightElevation: 8,
        icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
        label: const Text(
          'Add Staff',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) => _fetchStaff(keyword: value),
              style: const TextStyle(fontSize: 15, color: Color(0xFF1E293B)),
              decoration: InputDecoration(
                hintText: 'Search by name or ID...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF3B82F6), size: 22),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.cancel_rounded, color: Color(0xFFCBD5E1), size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _fetchStaff();
                    FocusScope.of(context).unfocus();
                  },
                )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6)))
                : _errorMessage != null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
                : _staffList.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open_rounded, color: Colors.grey[400], size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No staff found',
                    style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
              physics: const BouncingScrollPhysics(),
              itemCount: _staffList.length,
              itemBuilder: (context, index) {
                return _StaffCard(
                  key: ValueKey(_staffList[index].userid),
                  staff: _staffList[index],
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  final StaffInfoModel staff;
  final int index;

  const _StaffCard({super.key, required this.staff, required this.index});

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '??';
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0].substring(0, words[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100).clamp(0, 1000)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E293B).withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            splashColor: const Color(0xFF3B82F6).withOpacity(0.1),
            highlightColor: Colors.transparent,
            onTap: () {
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF3B82F6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _getInitials(staff.fullName),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              staff.fullName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF2FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    staff.posName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF4F46E5),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'ID: ${staff.userid}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF94A3B8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5, height: 1),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StaffDetailPage(userId: staff.userid),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8FAFC),
                        foregroundColor: const Color(0xFF3B82F6),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      child: const Text(
                        'View Profile',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}