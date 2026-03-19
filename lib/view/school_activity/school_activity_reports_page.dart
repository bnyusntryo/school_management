import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../viewmodel/school_activity_reports_viewmodel.dart';
import '../school_activity_report_preview_page.dart';

class SchoolActivityReportsPage extends StatefulWidget {
  const SchoolActivityReportsPage({super.key});

  @override
  State<SchoolActivityReportsPage> createState() =>
      _SchoolActivityReportsPageState();
}

class _SchoolActivityReportsPageState extends State<SchoolActivityReportsPage> {
  final SchoolActivityReportsViewModel _viewModel =
      SchoolActivityReportsViewModel();

  bool _isLoading = true;
  DateTime? _startDate;
  DateTime? _endDate;

  List<dynamic> _allClasses = [];
  Set<String> _selectedClassIds = {};

  final Color gradientStart = const Color(0xFF0EA5E9);
  final Color gradientEnd = const Color(0xFF6366F1);
  final Color bgSlate = const Color(0xFFF8FAFC);
  final Color textDark = const Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    setState(() => _isLoading = true);
    try {
      var resp = await _viewModel.fetchClassListForReport();
      if (!mounted) return;

      if (resp.data != null) {
        setState(() {
          _allClasses = resp.data ?? [];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        _showError(resp.message ?? "Gagal mengambil daftar kelas.");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError("Terjadi kesalahan sistem: $e");
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: gradientEnd,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedClassIds.contains(id)) {
        _selectedClassIds.remove(id);
      } else {
        _selectedClassIds.add(id);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedClassIds = _allClasses
          .map((c) => c['userid'].toString())
          .toSet();
    });
  }

  void _clearAll() {
    setState(() {
      _selectedClassIds.clear();
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: gradientEnd,
              onPrimary: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        if (isStart)
          _startDate = picked;
        else
          _endDate = picked;
      });
    }
  }

  Future<void> _submitReport() async {
    if (_startDate == null || _endDate == null || _selectedClassIds.isEmpty) {
      _showError("Harap isi tanggal dan pilih minimal 1 kelas!");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String startStr = DateFormat('yyyy-MM-dd').format(_startDate!);
      String endStr = DateFormat('yyyy-MM-dd').format(_endDate!);
      List<String> codesToSubmit = _selectedClassIds.toList();

      var resp = await _viewModel.generateReportData(
        startDate: startStr,
        endDate: endStr,
        classCodes: codesToSubmit,
      );

      if (!mounted) return;
      Navigator.pop(context);

      if (resp.data != null) {
        List<dynamic> rawReportData = resp.data ?? [];
        if (rawReportData.isEmpty) {
          _showError("Tidak ada data aktivitas untuk kriteria tersebut.");
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SchoolActivityReportPreviewPage(reportData: rawReportData),
          ),
        );
      } else {
        _showError(resp.message ?? "Gagal Generate Report.");
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showError("Terjadi kesalahan sistem: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSlate,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 140.0,
            pinned: true,
            backgroundColor: gradientEnd,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 8, bottom: 8),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
              title: const Text(
                "Class Activity Report",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: -0.5,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [gradientStart, gradientEnd],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -20,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      left: 40,
                      bottom: -40,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Period Filter",
                    style: TextStyle(
                      color: textDark,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDateCard(
                          "Start Date",
                          _startDate,
                          () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildDateCard(
                          "End Date",
                          _endDate,
                          () => _selectDate(context, false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Target Classes",
                            style: TextStyle(
                              color: textDark,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_selectedClassIds.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: gradientStart,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${_selectedClassIds.length}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),

                      Row(
                        children: [
                          if (_selectedClassIds.isNotEmpty)
                            TextButton(
                              onPressed: _clearAll,
                              style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                foregroundColor: Colors.redAccent,
                              ),
                              child: const Text(
                                "Clear",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          TextButton(
                            onPressed: _selectAll,
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              foregroundColor: gradientEnd,
                            ),
                            child: const Text(
                              "Select All",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  _isLoading
                      ? SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: gradientEnd,
                            ),
                          ),
                        )
                      : _allClasses.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                color: Colors.grey.shade300,
                                size: 40,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "No classes available",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _allClasses.map((c) {
                            String id = c['userid']?.toString() ?? "";
                            String name =
                                c['full_name']?.toString() ?? "Unknown";
                            bool isSelected = _selectedClassIds.contains(id);

                            return GestureDetector(
                              onTap: () => _toggleSelection(id),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? gradientEnd
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: gradientEnd.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.02,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                  border: Border.all(
                                    color: isSelected
                                        ? gradientEnd
                                        : Colors.grey.shade200,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle_rounded
                                          : Icons.circle_outlined,
                                      size: 16,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade400,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w800
                                            : FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [gradientStart, gradientEnd]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradientEnd.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _submitReport,
              icon: const Icon(
                Icons.analytics_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                "Generate Report",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard(String label, DateTime? value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value != null
                      ? DateFormat('dd MMM yy').format(value)
                      : "Select",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: value != null ? textDark : Colors.grey.shade400,
                  ),
                ),
                Icon(
                  Icons.calendar_month_rounded,
                  size: 16,
                  color: gradientEnd,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
