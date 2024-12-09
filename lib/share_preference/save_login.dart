import 'package:shared_preferences/shared_preferences.dart';

class SaveLogin {
  void setLoginPref(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("login", val);
  }

  Future<bool> getLoginPref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("login") ?? false;
  }
}
