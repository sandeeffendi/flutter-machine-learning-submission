import 'package:flutter/material.dart';

class ThemeProviders extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void themeOnChanged() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
