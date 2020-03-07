import 'package:darka/darka_utils.dart';
import 'package:darka/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:darka/blocs/blocs.dart';
import 'package:darka/database/database.dart';
import 'package:darka/pages/pages.dart';
import 'package:darka/locale/locales.dart';
import 'package:provider/provider.dart';

void main() {
  final db = DarkaDatabase();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: update theme mode to sqlite and use bloc to update theme setting.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(ChangeNotifierProvider<SettingStateNotifier>(
            create: (context) => SettingStateNotifier(),
            child: BlocProvider<TaskBloc>(
                create: (BuildContext context) => TaskBloc(darkaDb: db),
                child: DarkaApp()),
          )));
  // runApp(DarkaApp());
}

class DarkaApp extends StatefulWidget {
  @override
  _DarkaAppState createState() => _DarkaAppState();
}

class _DarkaAppState extends State<DarkaApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingStateNotifier>(
        builder: (context, settingState, child) {
      return MaterialApp(
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ""),
          const Locale('zh', ""),
        ],
        debugShowCheckedModeBanner: false,
        title: 'Darka',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: TaskPage(),
        themeMode: settingState.themeMode,
      );
    });
  }
}
