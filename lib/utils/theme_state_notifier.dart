import 'package:darka/user_setting.dart';
import 'package:flutter/material.dart';

class ThemeStateNotifier extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  void updateTheme(int index) async {
    if (index == 0) {
      this.themeMode = ThemeMode.light;
    } else if (index == 1) {
      this.themeMode = ThemeMode.dark;
    } else {
      this.themeMode = ThemeMode.system;
    }
    notifyListeners();

    await UserSettingHelper.setThemeMode(this.themeMode.index);
  }
}
