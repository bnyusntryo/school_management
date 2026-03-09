import 'dart:async';

import 'package:flutter/material.dart';
import '../config/pref.dart';
import '../model/client_model.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'login_page.dart';

class ClientIdPage extends StatefulWidget {
  const ClientIdPage({super.key});

  @override
  State<ClientIdPage> createState() => _ClientIdPageState();
}

class _ClientIdPageState extends State<ClientIdPage> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  final AuthViewmodel _viewmodel = AuthViewmodel();

  bool _isLoading = false;

  List<ClientModel> _clients = [];

  Timer? _debounce;

  Future<void> _searchClient(String query) async {

    setState(() {
      _errorMessage = null;
    });

    if (query.isEmpty) {
      setState(() {
        _clients = [];
      });
      return;
    }

    setState(() => _isLoading = true);

    final resp = await _viewmodel.clients(clientId: query);

    if (!mounted) return;

    setState(() {
      _isLoading = false;

      if (resp.data != null) {
        _clients = (resp.data as List)
            .map((e) => ClientModel.fromJson(e))
            .toList();
      } else {
        _clients = [];
        _errorMessage = resp.message?.toString();
      }
    });
  }

  void _selectClient(dynamic client) async {

    final clientId = client['client_id'];

    await Session().setClientId(clientId);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
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
                            "GLORA",
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
                              text: "GLORA",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: Color(0xFF2962FF),
                              ),
                            ),
                            TextSpan(text: " by Faryandra"),
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
                            onChanged: (value) {

                              final cleaned = value
                                  .toLowerCase()
                                  .trim()
                                  .replaceAll(RegExp(r'\s+'), '');

                              if (_debounce?.isActive ?? false) {
                                _debounce!.cancel();
                              }

                              _debounce = Timer(
                                const Duration(milliseconds: 400),
                                    () => _searchClient(cleaned),
                              );
                            },
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

                          if (_isLoading)
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: CircularProgressIndicator(),
                            ),

                          if (_clients.isNotEmpty)
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
                                itemCount: _clients.length,
                                itemBuilder: (context, index) {

                                  final client = _clients[index];

                                  return ListTile(
                                    title: Text(client.clientName),
                                    onTap: () => _selectClient(client),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "© 2025 Faryandra Tech. All rights reserved.",
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