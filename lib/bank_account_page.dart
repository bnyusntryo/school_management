import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankAccountPage extends StatefulWidget {
  const BankAccountPage({super.key});

  @override
  State<BankAccountPage> createState() => _BankAccountPageState();
}

class _BankAccountPageState extends State<BankAccountPage> {
  final List<Map<String, dynamic>> _transactions = [
    {'date': '23 Feb 2026', 'desc': 'Setoran Tabungan Wajib', 'amount': 150000, 'type': 'in'},
    {'date': '20 Feb 2026', 'desc': 'Pembayaran Buku LKS', 'amount': -75000, 'type': 'out'},
    {'date': '15 Feb 2026', 'desc': 'Setoran Sukarela', 'amount': 50000, 'type': 'in'},
    {'date': '10 Feb 2026', 'desc': 'Penarikan untuk Koperasi', 'amount': -25000, 'type': 'out'},
    {'date': '01 Feb 2026', 'desc': 'Saldo Awal Bulan', 'amount': 2300000, 'type': 'in'},
  ];

  String formatCurrency(num amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    const Color bankMiniAccent = Color(0xFFF06292);
    const Color bankMiniBaseDark = Color(0xFF2E3192);
    const Color bankMiniBaseLight = Color(0xFF662D91);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
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
                titlePadding: EdgeInsets.only(left: 60, bottom: 25),
                title: Text(
                  "Bank Account",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: _buildVirtualBankCard(bankMiniBaseDark, bankMiniBaseLight, bankMiniAccent),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Recent Transactions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                  ),
                  Icon(Icons.sort_rounded, color: Colors.grey),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final tx = _transactions[index];
                  return _buildTransactionTile(tx);
                },
                childCount: _transactions.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildVirtualBankCard(Color darkColor, Color lightColor, Color accentColor) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [darkColor, lightColor],
        ),
        boxShadow: [
          BoxShadow(color: accentColor.withOpacity(0.4), blurRadius: 25, offset: const Offset(0, 12)),
          BoxShadow(color: darkColor.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -20,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.0)],
                    )
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Rina Nose", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 4),
                        Text("Class X RPL 2", style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.nfc_rounded, color: Colors.white70, size: 28),
                        const SizedBox(width: 10),
                        Container(
                          width: 45,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.amber.shade200,
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(colors: [Colors.amber.shade300, Colors.amber.shade100])
                          ),
                          child: const Icon(Icons.memory_rounded, color: Colors.brown),
                        ),
                      ],
                    )
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Balance", style: TextStyle(color: accentColor.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 5),
                    Text(
                      formatCurrency(2500000),
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Student ID (NISN)", style: TextStyle(color: Colors.white54, fontSize: 10)),
                        Text("0045928371", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.account_balance_rounded, color: accentColor),
                        const SizedBox(width: 5),
                        Text("Bank Mini", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(Map<String, dynamic> tx) {
    final bool isIn = tx['type'] == 'in';
    final Color statusColor = isIn ? Colors.green.shade600 : Colors.red.shade600;
    final IconData statusIcon = isIn ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(statusIcon, color: statusColor, size: 22),
        ),
        title: Text(
          tx['desc'],
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3142), fontSize: 15),
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(tx['date'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        ),
        trailing: Text(
          "${isIn ? '+' : ''}${formatCurrency(tx['amount'])}",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: statusColor,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}