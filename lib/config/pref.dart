import 'package:shared_preferences/shared_preferences.dart';

// import '../viewmodel/auth_viewmodel.dart';

class Session {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final String userToken = "user_token";
  final String isWelcome = "is_welcome";
  final String fcmToken = "fcmToken";


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

  Future<void> logout() async {
    // await AuthViewModel().logout();

    final SharedPreferences prefs = await _prefs;
    await prefs.remove(userToken);
    await prefs.remove(fcmToken);
  }
}
