import 'package:darka/l10n/messages_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get title {
    return Intl.message(
      'Darka',
      name: 'title',
      desc: 'The title of the application',
    );
  }

  String get bottomNavSummary {
    return Intl.message(
      'Summary',
      name: 'bottomNavSummary',
      desc: 'Text for summary in bottom nav',
    );
  }

  String get bottomNavTask {
    return Intl.message(
      'Tasks',
      name: 'bottomNavTask',
      desc: 'Text for tasks in bottom nav',
    );
  }

  String get taskName {
    return Intl.message(
      'Task name',
      name: 'taskName',
      desc: 'Text for new task input box',
    );
  }

  String get buttonCancel {
    return Intl.message(
      'Cancel',
      name: 'buttonCancel',
      desc: 'Cancel button text',
    );
  }

  String get buttonConfirm {
    return Intl.message(
      'Confirm',
      name: 'buttonConfirm',
      desc: 'Cancel button text',
    );
  }

  String get newTaskHintText {
    return Intl.message(
      'Give a task name...',
      name: 'newTaskHintText',
      desc: 'hint text when creating a new task.',
    );
  }

  String get totalTasks {
    return Intl.message(
      'Total Tasks',
      name: 'totalTasks',
      desc: 'display total tasks in summary',
    );
  }

  String get totalPunched {
    return Intl.message(
      'Total punched',
      name: 'totalPunched',
      desc: 'display total punched in single task detail',
    );
  }

  String get dateAdded {
    return Intl.message(
      'Date added',
      name: 'dateAdded',
      desc: 'display added date.',
    );
  }

  String get recentActivities {
    return Intl.message(
      'Recent Activities',
      name: 'recentActivities',
      desc: 'single task detail recent activities.',
    );
  }

  String get days {
    return Intl.message(
      'days',
      name: 'days',
      desc: 'display days in single task details.',
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) {
    return false;
  }
}
