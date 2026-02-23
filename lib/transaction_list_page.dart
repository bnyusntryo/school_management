import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_transaction_page.dart';
import 'transaction_detail_page.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy Data berdasarkan gambar web
  final List<Map<String, dynamic>> _transactions = [
    {"id": "BMTR2025102000000021", "name": "Ahmad Trias Nur hakim", "type": "Debet", "date": "20 Oct 2025 13:03:30", "amount": 50000, "remark": "migrasi", "by": "Dummy Headmaster"},
    {"id": "BMTR2025102000000022", "name": "AISYAH BADARIAH", "type": "Debet", "date": "20 Oct 2025 13:03:46", "amount": 50000, "remark": "migrasi", "by": "Dummy Headmaster"},
    {"id": "BMTR2025102000000023", "name": "Kayla Olivia Hermawan", "type": "Debet", "date": "20 Oct 2025 13:04:12", "amount": 10000, "remark": "migrasi", "by": "Dummy Headmaster"},
    {"id": "BMTR2025102000000024", "name": "NUREVITA SARI", "type": "Debet", "date": "20 Oct 2025 13:04:28", "amount": 25000, "remark": "migrasi", "by": "Dummy Headmaster"},
    {"id": "BMTR2025102000000025", "name": "MUHAMAT FARIT ARYANTO", "type": "Debet", "date": "20 Oct 2025 13:04:51", "amount": 15000, "remark": "migrasi", "by": "Dummy Headmaster"},
  ];

  List<Map<String, dynamic>> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _filteredTransactions = _transactions;
  }

  void _filterData(String query) {
    setState(() {
      _filteredTransactions = _transactions.where((tx) =>
      tx['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
          tx['id'].toString().toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  String formatCurrency(num amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    const Color bankMiniBaseDark = Color(0xFF2E3192);
    const Color bankMiniBaseLight = Color(0xFF662D91);
    const Color bankMiniAccent = Color(0xFFF06292);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: CustomScrollView(
        slivers: [
          // --- HEADER ---
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [bankMiniBaseDark, bankMiniBaseLight],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(color: bankMiniAccent.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))
                  ]
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "All Transactions",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
                  tooltip: "Add Transaction",
                  onPressed: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddTransactionPage())
                    );

                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        _transactions.insert(0, result);
                        _filteredTransactions = List.from(_transactions);
                      });

                      if(mounted){
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Transaction Added Successfully!"), backgroundColor: Colors.green)
                        );
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),

          // --- SEARCH BAR ---
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
                        boxShadow: [BoxShadow(color: bankMiniBaseDark.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterData,
                        decoration: InputDecoration(
                          icon: Icon(Icons.search_rounded, color: bankMiniBaseDark, size: 22),
                          hintText: "Search name or ID...",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
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
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _filterData('');
                      },
                      icon: Icon(Icons.filter_alt_off_rounded, color: Colors.grey.shade600, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- INFO TEXT ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                "${_filteredTransactions.length} transactions found",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // --- LIST TRANSAKSI (GAYA ADMIN) ---
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final tx = _filteredTransactions[index];
                  return _buildAdminTransactionCard(tx, bankMiniBaseDark, bankMiniBaseLight);
                },
                childCount: _filteredTransactions.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildAdminTransactionCard(Map<String, dynamic> tx, Color darkTheme, Color lightTheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris 1: ID Transaksi & Tanggal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "ID: ${tx['id']}",
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  tx['date'],
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1),
            ),

            // Baris 2: Nama Siswa & Amount
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: darkTheme.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_outline, color: darkTheme, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Tambahan pengaman maxLines untuk Nama
                      Text(
                        tx['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3142)),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(4)),
                            child: Text(tx['type'], style: TextStyle(fontSize: 9, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 6),
                          // ✅ PERBAIKAN UTAMA: Bungkus Remark dengan Expanded dan Ellipsis
                          Expanded(
                            child: Text(
                              "Remark: ${tx['remark']}",
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatCurrency(tx['amount']),
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.green),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Baris 3: Admin Name & Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.admin_panel_settings_rounded, size: 14, color: Colors.grey.shade400),
                      const SizedBox(width: 5),
                      // ✅ Tambahan pengaman untuk nama Admin yang panjang
                      Expanded(
                        child: Text(
                          "By: ${tx['by']}",
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionDetailPage(transactionData: tx),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.visibility_rounded, color: Colors.white, size: 12), // Ubah ikon ke visibility (mata)
                        SizedBox(width: 5),
                        Text("Detail", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}