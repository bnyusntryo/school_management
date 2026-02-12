import 'package:flutter/material.dart';
import 'login_page.dart';

class ClientIdPage extends StatefulWidget {
  const ClientIdPage({super.key});

  @override
  State<ClientIdPage> createState() => _ClientIdPageState();
}

class _ClientIdPageState extends State<ClientIdPage> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  final List<Map<String, String>> _schoolsData = [
    {'id': 'smkislamiyah', 'name': 'SMK Islamiyah Ciputat'},
    {'id': 'smkn1', 'name': 'SMK Negeri 1 Jakarta'},
    {'id': 'sma3', 'name': 'SMA Negeri 3 Bandung'},
    {'id': 'tjipta', 'name': 'Tjipta Foundation School'},
  ];

  List<Map<String, String>> _filteredSchools = [];

  void _onSearchChanged(String query) {
    setState(() {
      _errorMessage = null;
      if (query.isEmpty) {
        _filteredSchools = [];
      } else {
        _filteredSchools = _schoolsData
            .where((school) =>
        school['id']!.toLowerCase().contains(query.toLowerCase()) ||
            school['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _validateAndSubmit() {
    if (_controller.text.isEmpty) {
      setState(() {
        _errorMessage = "Client Code tidak boleh kosong!";
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E4FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.school, size: 40, color: Color(0xFF2E3E5C)),
                          SizedBox(width: 10),
                          Text(
                            "PEDE",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E3E5C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          children: [
                            TextSpan(text: "Welcome To "),
                            TextSpan(
                              text: "PEDE",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: Color(0xFF2962FF),
                              ),
                            ),
                            TextSpan(text: " by Tjipta"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Please enter your account code to continue",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 30),


                      const Text(
                        "Account Code",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      Column(
                        children: [
                          TextField(
                            controller: _controller,
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              hintText: "Input Client ID...",
                              errorText: _errorMessage,
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.blue, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14,
                              ),
                            ),
                          ),

                          if (_filteredSchools.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              constraints: const BoxConstraints(maxHeight: 150),
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: _filteredSchools.length,
                                itemBuilder: (context, index) {
                                  final school = _filteredSchools[index];
                                  return ListTile(
                                    title: Text(
                                      school['name']!,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _controller.text = school['name']!;
                                        _filteredSchools = [];
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: _validateAndSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2962FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "© 2025 Tjipta ID. All rights reserved.",
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}