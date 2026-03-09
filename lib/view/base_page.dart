import 'package:flutter/material.dart';
import 'package:school_management/config/pref.dart';
import 'package:school_management/view/client_id_page.dart';
import 'package:school_management/view/home_page.dart';


class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {

  late Future<String?> _tokenFuture;

  @override
  void initState() {
    super.initState();
    _tokenFuture = Session().getUserToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _tokenFuture,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final token = snapshot.data;

        if (token == null || token.isEmpty) {
          return const ClientIdPage();
        }

        return const HomePage();
      },
    );
  }
}
