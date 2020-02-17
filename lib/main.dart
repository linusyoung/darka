import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:darka/blocs/blocs.dart';
import 'package:darka/database/database.dart';
import 'package:darka/pages/pages.dart';
import 'package:darka/locale/locales.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(DarkaApp()));
  // runApp(DarkaApp());
}

class DarkaApp extends StatefulWidget {
  @override
  _DarkaAppState createState() => _DarkaAppState();
}

class _DarkaAppState extends State<DarkaApp> {
  static final db = DarkaDatabase();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (BuildContext context) => TaskBloc(darkaDb: db),
      child: MaterialApp(
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
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 20.0,
            ),
            subtitle: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
            display1: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
            body2: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          disabledColor: Colors.grey[300],
        ),
        darkTheme: ThemeData.dark(),
        home: TaskPage(),
      ),
    );
  }
}
