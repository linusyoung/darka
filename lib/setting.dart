import 'package:flutter/material.dart';

class SettingStateNotifier extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  void updateTheme(List<bool> theme) {
    if (theme[0]) {
      this.themeMode = ThemeMode.light;
    } else if (theme[1]) {
      this.themeMode = ThemeMode.dark;
    } else {
      this.themeMode = ThemeMode.system;
    }
    notifyListeners();
  }
}
