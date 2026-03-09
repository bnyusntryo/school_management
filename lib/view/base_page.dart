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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: Session().getUserToken(), builder: (context, snapshot) {
      String? token = snapshot.data;
      if (token == null) {
        return const ClientIdPage();
      } else {
        return const HomePage();
      }
    },);
  }
}
