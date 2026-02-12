import 'package:flutter/material.dart';

class TeacherCertificatePage extends StatelessWidget {
  const TeacherCertificatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> certificates = List.generate(
      5,
      (index) => {
        "id": "Savannah Nguyen",
        "training": "\$2575.00",
        "amount": "\$120.00",
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Teacher Certificate",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Add",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // --- TABLE HEADER ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black12),
                  bottom: BorderSide(color: Colors.black12),
                ),
              ),
              child: Row(
                children: const [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Teacher\nCertificate\nID",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Training\nName",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Amount\nOut",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            // --- TABLE BODY ---
            Expanded(
              child: ListView.separated(
                itemCount: certificates.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
                itemBuilder: (context, index) {
                  final item = certificates[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            item['id']!,
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            item['training']!,
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            item['amount']!,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
