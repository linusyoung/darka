import 'package:admob_flutter/admob_flutter.dart';
import 'package:darka/utils/utils.dart';
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
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(ChangeNotifierProvider<ThemeStateNotifier>(
            create: (context) => ThemeStateNotifier(),
            child: BlocProvider<TaskBloc>(
                create: (BuildContext context) => TaskBloc(darkaDb: db),
                child: DarkaApp()),
          )));
}

class DarkaApp extends StatefulWidget {
  @override
  _DarkaAppState createState() => _DarkaAppState();
}

class _DarkaAppState extends State<DarkaApp> {
  @override
  void initState() {
    Admob.initialize(AdmobAppId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeStateNotifier>(
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
        home: HomePage(),
        builder: (BuildContext context, Widget child) {
          return child;
        },
        themeMode: settingState.themeMode,
      );
    });
  }
}
