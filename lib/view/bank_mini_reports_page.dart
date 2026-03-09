import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankMiniReportsPage extends StatefulWidget {
  const BankMiniReportsPage({super.key});

  @override
  State<BankMiniReportsPage> createState() => _BankMiniReportsPageState();
}

class _BankMiniReportsPageState extends State<BankMiniReportsPage> {
  int _currentView = 0;

  final _transFormKey = GlobalKey<FormState>();
  final _startDateCtrl = TextEditingController();
  final _endDateCtrl = TextEditingController();
  List<String> _selectedUsers = [];

  final _eodFormKey = GlobalKey<FormState>();
  final _eodDateCtrl = TextEditingController();

  final _balanceClassFormKey = GlobalKey<FormState>();
  List<String> _selectedClasses = [];

  final List<Map<String, String>> _availableUsers = [
    {"id": "001", "name": "A'LIN ZAHWAH DINIYAH"},
    {"id": "002", "name": "A. RAHMAN MULYA FAZIZ"},
    {"id": "003", "name": "A. THIROZ ZAID FADHIL SIDDIQ"},
    {"id": "004", "name": "AHMAD TRIAS NUR HAKIM"},
    {"id": "005", "name": "AISYAH BADARIAH"},
    {"id": "006", "name": "KAYLA OLIVIA HERMAWAN"},
    {"id": "007", "name": "NUREVITA SARI"},
  ];

  final List<String> _availableClasses = [
    "X AK 1", "X BD 1", "X DKV 1", "X KUL 1", "XI RPL 1", "XII TKJ 2"
  ];

  final Color reportBaseDark = const Color(0xFF005C97);
  final Color reportBaseLight = const Color(0xFF363795);
  final Color bankMiniAccent = const Color(0xFFF06292);

  @override
  void initState() {
    super.initState();
    _eodDateCtrl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    _eodDateCtrl.dispose();
    super.dispose();
  }

  String formatCurrency(num amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentView) {
      case 0: return _buildMainMenu();
      case 1: return _buildTransactionFilter();
      case 2: return _buildTransactionPreview();
      case 3: return _buildEodFilter();
      case 4: return _buildEodPreview();
      case 5: return _buildBalanceClassFilter();
      case 6: return _buildBalanceClassPreview();
      default: return _buildMainMenu();
    }
  }

  Widget _buildMainMenu() {
    final List<Map<String, dynamic>> reportsData = [
      {"title": "Transaction List Report", "desc": "Transaction List Report provides transaction records, allowing educators to monitor transaction patterns.", "icon": Icons.receipt_long_rounded, "themeColor": Colors.blue.shade600},
      {"title": "End Of Day Report", "desc": "End Of Day Report provides end of day records, allowing educators to monitor daily closing balances.", "icon": Icons.event_available_rounded, "themeColor": Colors.amber.shade600},
      {"title": "Balance Per Class Report", "desc": "Balance Per Class Report provides balance records per class, allowing educators to monitor total balances.", "icon": Icons.account_balance_wallet_rounded, "themeColor": Colors.teal.shade600},
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 140, floating: false, pinned: true, backgroundColor: Colors.transparent, elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [reportBaseDark, reportBaseLight]),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              boxShadow: [BoxShadow(color: bankMiniAccent.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Stack(
              children: [
                Positioned(top: -20, right: -20, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: bankMiniAccent.withOpacity(0.25)))),
                const FlexibleSpaceBar(titlePadding: EdgeInsets.only(left: 60, bottom: 20), title: Text("Bank Mini Reports", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white))),
              ],
            ),
          ),
          leading: Container(
            margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Analytics & Records", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                const SizedBox(height: 5),
                Text("Generate and preview your financial reports here.", style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final r = reportsData[index];
                return _buildReportCard(
                    title: r['title'], desc: r['desc'], icon: r['icon'], themeColor: r['themeColor'],
                    onTap: () {
                      setState(() {
                        if (r['title'] == "Transaction List Report") {
                          _currentView = 1;
                        } else if (r['title'] == "End Of Day Report") _currentView = 3;
                        else if (r['title'] == "Balance Per Class Report") _currentView = 5;
                      });
                    }
                );
              },
              childCount: reportsData.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildReportCard({required String title, required String desc, required IconData icon, required Color themeColor, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: themeColor.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))], border: Border.all(color: themeColor.withOpacity(0.1), width: 2)),
      child: Stack(
        children: [
          Positioned(top: -15, right: -15, child: Icon(Icons.analytics_rounded, size: 80, color: bankMiniAccent.withOpacity(0.04))),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: themeColor, size: 28)),
                    const SizedBox(width: 15),
                    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142)))),
                  ],
                ),
                const SizedBox(height: 15),
                Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5), textAlign: TextAlign.justify),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(backgroundColor: themeColor, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.visibility_rounded, color: Colors.white, size: 18), SizedBox(width: 8), Text("Preview", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))]),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionFilter() {
    return CustomScrollView(
      slivers: [
        _buildSharedAppBar("Transaction List Report", onBack: () => setState(() => _currentView = 0)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _transFormKey,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: reportBaseDark.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Icon(Icons.filter_alt_rounded, color: reportBaseDark), const SizedBox(width: 10), const Text("Report Filters", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)))]),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1)),
                    Row(
                      children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Start Date *"), _buildDateField(_startDateCtrl, "Start")])),
                        const SizedBox(width: 15),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("End Date *"), _buildDateField(_endDateCtrl, "End")])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel("Select User *"),
                        if (_selectedUsers.isNotEmpty) TextButton(onPressed: () => setState(() => _selectedUsers.clear()), child: const Text("Clear All", style: TextStyle(fontSize: 11, color: Colors.red)))
                      ],
                    ),
                    InkWell(
                      onTap: _showMultiUserModal,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: double.infinity, constraints: const BoxConstraints(minHeight: 55), padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: _selectedUsers.isEmpty ? Colors.transparent : reportBaseLight.withOpacity(0.5), width: 1.5)),
                        child: _selectedUsers.isEmpty
                            ? Row(children: [Icon(Icons.group_add_rounded, color: Colors.grey.shade400, size: 20), const SizedBox(width: 10), Text("Tap to select users...", style: TextStyle(color: Colors.grey.shade400, fontSize: 14))])
                            : Wrap(
                          spacing: 8, runSpacing: 8,
                          children: _selectedUsers.map((id) {
                            final userName = _availableUsers.firstWhere((e) => e['id'] == id)['name'];
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: reportBaseLight.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: reportBaseLight.withOpacity(0.3))),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.person, size: 12, color: reportBaseDark), const SizedBox(width: 4), Flexible(child: Text(userName!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: reportBaseDark), maxLines: 1, overflow: TextOverflow.ellipsis))]),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    _buildGenerateButton(onPressed: () {
                      if (_startDateCtrl.text.isEmpty || _endDateCtrl.text.isEmpty || _selectedUsers.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields"), backgroundColor: Colors.red));
                        return;
                      }
                      setState(() => _currentView = 2);
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionPreview() {
    final List<Map<String, dynamic>> dummyData = [
      {"id": "BMTR-001", "userId": "001", "name": "A'LIN ZAHWAH DINIYAH", "type": "Debet", "amount": 50000, "remark": "Setoran", "by": "Admin Teller"},
      {"id": "BMTR-002", "userId": "002", "name": "A. RAHMAN MULYA FAZIZ", "type": "Kredit", "amount": 10000, "remark": "Penarikan", "by": "Admin Teller"},
    ];
    int total = 0;
    for (var tx in dummyData) { total += tx['type'] == 'Debet' ? tx['amount'] as int : -(tx['amount'] as int); }

    return _buildSharedPreview(
      reportName: "Transaction List Report", period: "${_startDateCtrl.text}  to  ${_endDateCtrl.text}", onBack: () => setState(() => _currentView = 1),
      childRecords: ListView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: dummyData.length,
        itemBuilder: (context, index) {
          final tx = dummyData[index]; final isDebet = tx['type'] == 'Debet';
          return Container(
            margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(tx['id'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600)), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: isDebet ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(6)), child: Text(tx['type'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDebet ? Colors.green.shade700 : Colors.red.shade700)))]),
                const Divider(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(tx['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2D3142))), const SizedBox(height: 2), Text("User ID: ${tx['userId']} | By: ${tx['by']}", style: TextStyle(fontSize: 10, color: Colors.grey.shade500))])), Text("${isDebet ? '+' : '-'}${formatCurrency(tx['amount'])}", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: isDebet ? Colors.green.shade700 : Colors.red.shade700))]),
                const SizedBox(height: 8), Text("Remark: ${tx['remark']}", style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
              ],
            ),
          );
        },
      ),
      totalAmountLabel: "Total Transaction:", totalAmount: total,
    );
  }

  Widget _buildEodFilter() {
    return CustomScrollView(
      slivers: [
        _buildSharedAppBar("End Of Day Report", onBack: () => setState(() => _currentView = 0)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _eodFormKey,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: reportBaseDark.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Icon(Icons.event_available_rounded, color: reportBaseDark), const SizedBox(width: 10), const Text("Daily Closing Filter", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)))]),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1)),
                    _buildLabel("Transaction Date *"),
                    _buildDateField(_eodDateCtrl, "Select Date"),
                    const SizedBox(height: 35),
                    _buildGenerateButton(onPressed: () {
                      if (_eodDateCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a date"), backgroundColor: Colors.red));
                        return;
                      }
                      setState(() => _currentView = 4);
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEodPreview() {
    final List<Map<String, dynamic>> dummyData = [
      {"id": "BMTR-EOD-001", "userId": "007", "name": "NUREVITA SARI", "type": "Debet", "amount": 100000, "remark": "Setoran Bebas", "by": "Admin Teller"},
    ];
    int total = 100000;

    return _buildSharedPreview(
      reportName: "End Of Day Report", period: _eodDateCtrl.text, onBack: () => setState(() => _currentView = 3),
      childRecords: ListView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: dummyData.length,
        itemBuilder: (context, index) {
          final tx = dummyData[index]; final isDebet = tx['type'] == 'Debet';
          return Container(
            margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(tx['id'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600)), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: isDebet ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(6)), child: Text(tx['type'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDebet ? Colors.green.shade700 : Colors.red.shade700)))]),
                const Divider(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(tx['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2D3142))), const SizedBox(height: 2), Text("User ID: ${tx['userId']} | By: ${tx['by']}", style: TextStyle(fontSize: 10, color: Colors.grey.shade500))])), Text("${isDebet ? '+' : '-'}${formatCurrency(tx['amount'])}", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: isDebet ? Colors.green.shade700 : Colors.red.shade700))]),
                const SizedBox(height: 8), Text("Remark: ${tx['remark']}", style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
              ],
            ),
          );
        },
      ),
      totalAmountLabel: "Final Daily Balance:", totalAmount: total,
    );
  }

  Widget _buildBalanceClassFilter() {
    return CustomScrollView(
      slivers: [
        _buildSharedAppBar("Balance Per Class Report", onBack: () => setState(() => _currentView = 0)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _balanceClassFormKey,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: reportBaseDark.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Icon(Icons.class_rounded, color: reportBaseDark), const SizedBox(width: 10), const Text("Class Filters", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)))]),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel("Select Class *"),
                        if (_selectedClasses.isNotEmpty) TextButton(onPressed: () => setState(() => _selectedClasses.clear()), child: const Text("Clear All", style: TextStyle(fontSize: 11, color: Colors.red)))
                      ],
                    ),
                    InkWell(
                      onTap: _showMultiClassModal,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: double.infinity, constraints: const BoxConstraints(minHeight: 55), padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: _selectedClasses.isEmpty ? Colors.transparent : reportBaseLight.withOpacity(0.5), width: 1.5)),
                        child: _selectedClasses.isEmpty
                            ? Row(children: [Icon(Icons.school_rounded, color: Colors.grey.shade400, size: 20), const SizedBox(width: 10), Text("Tap to select classes...", style: TextStyle(color: Colors.grey.shade400, fontSize: 14))])
                            : Wrap(
                          spacing: 8, runSpacing: 8,
                          children: _selectedClasses.map((className) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: reportBaseLight.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: reportBaseLight.withOpacity(0.3))),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.sell_rounded, size: 12, color: reportBaseDark), const SizedBox(width: 4), Flexible(child: Text(className, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: reportBaseDark), maxLines: 1, overflow: TextOverflow.ellipsis))]),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    _buildGenerateButton(onPressed: () {
                      if (_selectedClasses.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select at least 1 class"), backgroundColor: Colors.red));
                        return;
                      }
                      setState(() => _currentView = 6);
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceClassPreview() {
    final List<Map<String, dynamic>> dummyBalances = [
      {"userId": "25049120", "name": "Abdullah Widodo", "class": _selectedClasses.first, "balance": 150000},
      {"userId": "25049121", "name": "Andika Prastyo", "class": _selectedClasses.first, "balance": 45000},
      {"userId": "25049122", "name": "ARDIAN RESTU TRIAJI", "class": _selectedClasses.first, "balance": 85000},
      {"userId": "25049123", "name": "ARSYVA RAHMAH", "class": _selectedClasses.first, "balance": 0},
    ];

    int totalClassBalance = 0;
    for (var student in dummyBalances) {
      totalClassBalance += student['balance'] as int;
    }

    return _buildSharedPreview(
      reportName: "Balance Per Class Report",
      period: "All Time (Selected Classes)",
      onBack: () => setState(() => _currentView = 5),
      childRecords: ListView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: dummyBalances.length,
        itemBuilder: (context, index) {
          final student = dummyBalances[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("User ID: ${student['userId']}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(6)), child: Text(student['class'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue.shade700)))
                  ],
                ),
                const Divider(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3142)))),
                    Text(formatCurrency(student['balance']), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.green))
                  ],
                ),
              ],
            ),
          );
        },
      ),
      totalAmountLabel: "Total Class Balance:",
      totalAmount: totalClassBalance,
    );
  }

  void _showMultiUserModal() {
    List<String> tempSelected = List.from(_selectedUsers);
    List<Map<String, String>> filteredUsers = List.from(_availableUsers);
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85, padding: const EdgeInsets.all(20), decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))), const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Select Users", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF005C97))), TextButton(onPressed: () => setModalState(() { tempSelected.length == _availableUsers.length ? tempSelected.clear() : tempSelected = _availableUsers.map((e) => e['id']!).toList(); }), child: Text(tempSelected.length == _availableUsers.length ? "Deselect All" : "Select All", style: const TextStyle(fontWeight: FontWeight.bold)))]),
                TextField(decoration: InputDecoration(hintText: "Search name...", prefixIcon: const Icon(Icons.search, color: Colors.grey), filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 0)), onChanged: (query) => setModalState(() { filteredUsers = _availableUsers.where((user) => user['name']!.toLowerCase().contains(query.toLowerCase())).toList(); })),
                const SizedBox(height: 10), Text("${tempSelected.length} users selected", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)), const Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Divider()),
                Expanded(child: ListView.builder(itemCount: filteredUsers.length, itemBuilder: (context, index) { final user = filteredUsers[index]; final isChecked = tempSelected.contains(user['id']); return CheckboxListTile(contentPadding: EdgeInsets.zero, activeColor: const Color(0xFF005C97), title: Text(user['name']!, style: TextStyle(fontWeight: isChecked ? FontWeight.bold : FontWeight.normal, fontSize: 14)), value: isChecked, onChanged: (bool? value) { setModalState(() { if (value == true) {
                  tempSelected.add(user['id']!);
                } else {
                  tempSelected.remove(user['id']);
                } }); }); })),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { setState(() => _selectedUsers = tempSelected); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005C97), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Apply Selection", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))
              ],
            ),
          );
        });
      },
    );
  }

  void _showMultiClassModal() {
    List<String> tempSelected = List.from(_selectedClasses);
    List<String> filteredClasses = List.from(_availableClasses);
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85, padding: const EdgeInsets.all(20), decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))), const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Select Classes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF005C97))), TextButton(onPressed: () => setModalState(() { tempSelected.length == _availableClasses.length ? tempSelected.clear() : tempSelected = List.from(_availableClasses); }), child: Text(tempSelected.length == _availableClasses.length ? "Deselect All" : "Select All", style: const TextStyle(fontWeight: FontWeight.bold)))]),
                TextField(decoration: InputDecoration(hintText: "Search class name...", prefixIcon: const Icon(Icons.search, color: Colors.grey), filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(vertical: 0)), onChanged: (query) => setModalState(() { filteredClasses = _availableClasses.where((c) => c.toLowerCase().contains(query.toLowerCase())).toList(); })),
                const SizedBox(height: 10), Text("${tempSelected.length} classes selected", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)), const Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Divider()),
                Expanded(child: ListView.builder(itemCount: filteredClasses.length, itemBuilder: (context, index) { final c = filteredClasses[index]; final isChecked = tempSelected.contains(c); return CheckboxListTile(contentPadding: EdgeInsets.zero, activeColor: const Color(0xFF005C97), title: Text(c, style: TextStyle(fontWeight: isChecked ? FontWeight.bold : FontWeight.normal, fontSize: 14)), value: isChecked, onChanged: (bool? value) { setModalState(() { if (value == true) {
                  tempSelected.add(c);
                } else {
                  tempSelected.remove(c);
                } }); }); })),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { setState(() => _selectedClasses = tempSelected); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005C97), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Apply Selection", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildSharedAppBar(String title, {required VoidCallback onBack}) {
    return SliverAppBar(
      expandedHeight: 120, floating: false, pinned: true, backgroundColor: Colors.transparent, elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [reportBaseDark, reportBaseLight]), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)), boxShadow: [BoxShadow(color: bankMiniAccent.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))]),
        child: Stack(children: [Positioned(top: -20, right: -20, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: bankMiniAccent.withOpacity(0.2)))), FlexibleSpaceBar(titlePadding: const EdgeInsets.only(left: 60, bottom: 20), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white)))]),
      ),
      leading: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20), onPressed: onBack)),
    );
  }

  Widget _buildGenerateButton({required VoidCallback onPressed}) {
    return SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: onPressed, icon: const Icon(Icons.analytics_rounded, color: Colors.white), label: const Text("Generate Report", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: reportBaseDark, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))));
  }

  Widget _buildSharedPreview({required String reportName, required String period, required VoidCallback onBack, required Widget childRecords, required String totalAmountLabel, required int totalAmount}) {
    final String reportedDate = DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.now());
    return Column(
      children: [
        AppBar(
          backgroundColor: reportBaseDark, elevation: 0, title: const Text("Preview Reports", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)), leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20), onPressed: onBack),
          actions: [Container(margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(8)), child: IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18), onPressed: onBack))],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: reportBaseDark.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildMetaRow("Report Name", reportName), const SizedBox(height: 8), _buildMetaRow("Period", period), const SizedBox(height: 8), _buildMetaRow("Reported Date", reportedDate), const SizedBox(height: 8), _buildMetaRow("Reported By", "Dummy Headmaster")]),
                ),
                const SizedBox(height: 25), const Text("Records", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142))), const SizedBox(height: 15),
                childRecords
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 25), decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))], borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: SafeArea(
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(totalAmountLabel, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)), Text(formatCurrency(totalAmount), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2D3142)))]),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.table_chart_rounded, color: Colors.white, size: 18), label: const Text("Excel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))), const SizedBox(width: 15),
                    Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 18), label: const Text("PDF", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8, top: 5), child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)));

  Widget _buildMetaRow(String label, String value) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 110, child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500))), const Text(" :  ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)), Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2D3142))))]);

  Widget _buildDateField(TextEditingController controller, String hint) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100), builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF005C97))), child: child!));
        if (pickedDate != null) setState(() => controller.text = DateFormat('yyyy-MM-dd').format(pickedDate));
      },
      child: IgnorePointer(
        child: Container(margin: const EdgeInsets.only(bottom: 10), child: TextFormField(controller: controller, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), decoration: InputDecoration(prefixIcon: const Icon(Icons.calendar_month_rounded, color: Colors.grey, size: 18), hintText: hint, hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13), filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)))),
      ),
    );
  }
}