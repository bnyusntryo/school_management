import 'package:flutter/material.dart';

class TransactionDetailPage extends StatefulWidget {
  final Map<String, dynamic> transactionData;

  const TransactionDetailPage({super.key, required this.transactionData});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late TextEditingController _customerCtrl;
  late TextEditingController _typeCtrl;
  late TextEditingController _amountCtrl;
  late TextEditingController _spelledAmountCtrl;
  late TextEditingController _remarkCtrl;
  late TextEditingController _transactedByCtrl;
  late TextEditingController _dateCtrl;

  @override
  void initState() {
    super.initState();
    final tx = widget.transactionData;

    _customerCtrl = TextEditingController(text: tx['name']);
    _typeCtrl = TextEditingController(text: tx['type']);
    _amountCtrl = TextEditingController(text: tx['amount'].toString());
    _remarkCtrl = TextEditingController(text: tx['remark']);
    _transactedByCtrl = TextEditingController(text: tx['by']);
    _dateCtrl = TextEditingController(text: tx['date']);

    // Otomatis ubah angka jadi terbilang
    _spelledAmountCtrl = TextEditingController(text: "${_terbilang(tx['amount'])} Rupiah");
  }

  // Fungsi Terbilang
  String _terbilang(int number) {
    List<String> angka = ["", "Satu", "Dua", "Tiga", "Empat", "Lima", "Enam", "Tujuh", "Delapan", "Sembilan", "Sepuluh", "Sebelas"];
    if (number < 12) return angka[number];
    if (number < 20) return "${angka[number - 10]} Belas";
    if (number < 100) return "${angka[number ~/ 10]} Puluh ${_terbilang(number % 10)}".trim();
    if (number < 200) return "Seratus ${_terbilang(number - 100)}".trim();
    if (number < 1000) return "${angka[number ~/ 100]} Ratus ${_terbilang(number % 100)}".trim();
    if (number < 2000) return "Seribu ${_terbilang(number - 1000)}".trim();
    if (number < 1000000) return "${_terbilang(number ~/ 1000)} Ribu ${_terbilang(number % 1000)}".trim();
    if (number < 1000000000) return "${_terbilang(number ~/ 1000000)} Juta ${_terbilang(number % 1000000)}".trim();
    return "Nominal terlalu besar";
  }

  @override
  void dispose() {
    _customerCtrl.dispose();
    _typeCtrl.dispose();
    _amountCtrl.dispose();
    _spelledAmountCtrl.dispose();
    _remarkCtrl.dispose();
    _transactedByCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bankMiniBaseDark = Color(0xFF2E3192);
    const Color bankMiniBaseLight = Color(0xFF662D91);

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
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [bankMiniBaseDark, bankMiniBaseLight],
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Detail Transaction",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
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
          ),

          // --- FORM DETAIL (READ ONLY) ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: bankMiniBaseDark.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.info_outline_rounded, color: bankMiniBaseDark),
                        SizedBox(width: 10),
                        Text("Transaction Info", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider()),

                    _buildLabel("Bank Customer *"),
                    _buildTextField(_customerCtrl, Icons.person_outline),

                    _buildLabel("Transaction Type *"),
                    _buildTextField(_typeCtrl, Icons.compare_arrows_rounded),

                    _buildLabel("Amount"),
                    _buildTextField(_amountCtrl, Icons.attach_money_rounded),

                    _buildLabel("Spelled Amount *"),
                    _buildTextField(_spelledAmountCtrl, Icons.spellcheck_rounded, maxLines: 2),

                    _buildLabel("Remark *"),
                    _buildTextField(_remarkCtrl, Icons.notes_rounded, maxLines: 3),

                    _buildLabel("Transacted By"),
                    _buildTextField(_transactedByCtrl, Icons.admin_panel_settings_outlined),

                    _buildLabel("Transaction Date"),
                    _buildTextField(_dateCtrl, Icons.calendar_today_rounded),

                    const SizedBox(height: 25),

                    // --- TOMBOL CANCEL (KEMBALI) ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text("Close", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // Helper Widget
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 10),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        readOnly: true, // DIKUNCI SEMUA (READ-ONLY)
        maxLines: maxLines,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
          filled: true,
          fillColor: Colors.grey.shade200, // Warna latar abu-abu untuk read-only
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}