import 'package:flutter/material.dart';

class TeacherCertificatePage extends StatelessWidget {
  const TeacherCertificatePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy disesuaikan agar lebih masuk akal sebagai "Sertifikat"
    final List<Map<String, String>> certificates = [
      {"id": "TC-2024-001", "teacher": "Sarah Wijaya, M.Pd", "training": "Advanced Pedagogy", "amount": "\$250.00", "date": "15 Jan 2025"},
      {"id": "TC-2024-002", "teacher": "Bambang Hermawan, S.T", "training": "Digital Classroom", "amount": "\$120.00", "date": "10 Feb 2025"},
      {"id": "TC-2024-003", "teacher": "Dewi Lestari, S.S", "training": "English Proficiency", "amount": "\$300.00", "date": "05 Mar 2025"},
      {"id": "TC-2024-004", "teacher": "Rahmat Hidayat, M.Kom", "training": "Network Security", "amount": "\$150.00", "date": "20 Apr 2025"},
      {"id": "TC-2024-005", "teacher": "Sarah Wijaya, M.Pd", "training": "Child Psychology", "amount": "\$200.00", "date": "12 May 2025"},
    ];

    // Array warna untuk memberi aksen colorful pada kartu
    final List<Color> cardColors = [
      Colors.pink.shade400,
      Colors.purple.shade400,
      Colors.blue.shade400,
      Colors.orange.shade400,
      Colors.teal.shade400,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Latar abu-abu lembut
      body: CustomScrollView(
        slivers: [
          // --- HEADER MELENGKUNG (TEMA PINK GURU) ---
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
                  colors: [Colors.pink.shade400, Colors.pink.shade700],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 60, bottom: 20),
                title: Text(
                  "Teacher Certificates",
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
                  icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 24),
                  tooltip: "Add Certificate",
                  onPressed: () {
                    // Logika add certificate di sini
                  },
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),

          // --- INFO HEADER (SUMMARY) ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Certificates",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "${certificates.length} Records",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.pink.shade700),
                    ),
                  )
                ],
              ),
            ),
          ),

          // --- LIST SERTIFIKAT (CARD STYLE) ---
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            sliver: certificates.isEmpty
                ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.workspace_premium_rounded, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 15),
                      Text("No certificates found", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = certificates[index];
                  final cardColor = cardColors[index % cardColors.length];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: cardColor.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8)),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Pita Warna Samping
                            Container(width: 8, color: cardColor),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // HEADER KARTU: ID dan Tanggal
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['id']!,
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today_rounded, size: 12, color: cardColor),
                                            const SizedBox(width: 4),
                                            Text(item['date']!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: cardColor)),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // NAMA TRAINING & GURU
                                    Text(
                                      item['training']!,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.person_rounded, size: 14, color: Colors.grey.shade400),
                                        const SizedBox(width: 6),
                                        Text(item['teacher']!, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    const Divider(height: 1),
                                    const SizedBox(height: 15),

                                    // BOTTOM KARTU: Harga & Action
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("AMOUNT OUT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                                            const SizedBox(height: 4),
                                            Text(
                                              item['amount']!,
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.green.shade600),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(color: cardColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                          child: Icon(Icons.receipt_long_rounded, color: cardColor, size: 20),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: certificates.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}