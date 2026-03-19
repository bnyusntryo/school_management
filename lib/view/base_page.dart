import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management/config/pref.dart';
import 'package:school_management/view/auth/auth_provider.dart';
import 'package:school_management/view/auth/client_id_page.dart';
import 'package:school_management/view/home_page.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  late Future<bool> _sessionCheckFuture;

  @override
  void initState() {
    super.initState();
    _sessionCheckFuture = _checkCompleteSession(context);
  }

  Future<bool> _checkCompleteSession(BuildContext context) async {
    String? token = await Session().getUserToken();

    if (token == null || token.isEmpty) return false;

    String savedRole = await Session().getUserRole() ?? 'Student';
    String savedName = await Session().getUserName() ?? 'User';

    if (!context.mounted) return false;

    Provider.of<AuthProvider>(
      context,
      listen: false,
    ).setUserData(role: savedRole, userName: savedName);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _sessionCheckFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF2962FF)),
            ),
          );
        }

        final isLoggedIn = snapshot.data ?? false;

        if (!isLoggedIn) {
          return const ClientIdPage();
        }

        return const HomePage();
      },
    );
  }
}
