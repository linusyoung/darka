import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserSettingHelper {
  static final String _kThemePrefs = "themeMode";
  static final String _kHoleShapePrefs = "holeShape";
  static final String _kHoleSizePrefs = "holeSize";

  static Future<int> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_kThemePrefs) ?? ThemeMode.system.index;
  }

  static Future<bool> setThemeMode(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(_kThemePrefs, value);
  }

  static Future<int> getHoleShape() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kHoleShapePrefs) ?? 1;
  }

  static Future<bool> setHoleShape(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int v = 1;
    switch (value) {
      case 'circle':
        v = 1;
        break;
      case 'box':
        v = 0;
        break;
    }
    return prefs.setInt(_kHoleShapePrefs, v);
  }

  static Future<double> getHoleSize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_kHoleSizePrefs) ?? 5.0;
  }

  static Future<bool> setHoleSize(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(_kHoleSizePrefs, value);
  }
}
