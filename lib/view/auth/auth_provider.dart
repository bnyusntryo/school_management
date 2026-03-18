import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String _role = 'Student';
  String _userName = 'User';

  String get role => _role;
  String get userName => _userName;

  void setUserData({required String role, required String userName}) {
    _role = role;
    _userName = userName;

    notifyListeners();
  }
}