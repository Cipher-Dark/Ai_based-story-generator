import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _init();
  }
  bool _isDark = false;
  bool getThemeValue() => _isDark;

  Future<void> _init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', !_isDark);
    _isDark = !_isDark;
    notifyListeners();
  }
}
