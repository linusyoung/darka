import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserSettingHelper {
  static final String _kThemePrefs = "themeMode";

  static Future<int> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_kThemePrefs) ?? ThemeMode.system;
  }

  static Future<bool> setThemeMode(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(_kThemePrefs, value);
  }
}
