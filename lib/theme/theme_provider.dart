import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;
  bool getThemeValue() => _isDark;
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
