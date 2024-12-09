import 'package:ai_story_gen/share_preference/keep_login.dart';
import 'package:flutter/material.dart';

class KeepLoignProvider extends ChangeNotifier {
  final KeepLogin _keepLogin = KeepLogin();
  String? _storedValue;

  String? storedValue() => _storedValue;

  Future<void> loadStoredValue(String key) async {
    _storedValue = await _keepLogin.getData(key);
    notifyListeners();
  }

  Future<void> saveStoredValue(String key, String value) async {
    await _keepLogin.saveData(key, value);
    _storedValue = value;
    notifyListeners();
  }

  Future<void> removeStoredValue(String key) async {
    await _keepLogin.removeData(key);
    _storedValue = null;
    notifyListeners();
  }
}
