import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:darka/user_setting.dart';

class DarkaUtils {
  String generateV4() {
    return Uuid().v4().toString();
  }

  String dateFormat(DateTime d) => DateFormat("yyyy.MM.dd", "en_US").format(d);
}

class SettingStateNotifier extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  void updateTheme(List<bool> theme) async {
    if (theme[0]) {
      this.themeMode = ThemeMode.light;
    } else if (theme[1]) {
      this.themeMode = ThemeMode.dark;
    } else {
      this.themeMode = ThemeMode.system;
    }
    print(this.themeMode);
    notifyListeners();

    // await UserSettingHelper.setThemeMode(this.themeMode);
  }
}
