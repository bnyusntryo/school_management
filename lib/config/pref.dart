import 'package:shared_preferences/shared_preferences.dart';

class Session {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final String userToken = "user_token";
  final String isWelcome = "is_welcome";
  final String fcmToken = "fcmToken";
  final String clientIdKey = "client_id";

  final String userRoleKey = "user_role";
  final String userNameKey = "user_name";

  Future<void> setUserToken(dynamic value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(userToken, value);
  }

  Future<String?> getUserToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(userToken);
  }

  Future<void> setFcmToken(dynamic value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(fcmToken, value);
  }

  Future<String?> getFcmToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(fcmToken);
  }

  Future<void> setIsWelcome({required bool value}) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(isWelcome, value);
  }

  Future<bool?> getIsWelcome() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(isWelcome);
  }

  Future<void> setClientId(String value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(clientIdKey, value);
  }

  Future<String?> getClientId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(clientIdKey);
  }

  Future<void> setUserRole(String value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(userRoleKey, value);
  }

  Future<String?> getUserRole() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(userRoleKey);
  }

  Future<void> setUserName(String value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(userNameKey, value);
  }

  Future<String?> getUserName() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(userNameKey);
  }

  Future<void> logout() async {

    final SharedPreferences prefs = await _prefs;
    await prefs.remove(userToken);
    await prefs.remove(fcmToken);
    await prefs.remove(clientIdKey);

    await prefs.remove(userRoleKey);
    await prefs.remove(userNameKey);
  }
}