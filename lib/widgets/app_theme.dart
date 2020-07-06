import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepOrange,
    textTheme: TextTheme(
      headline6: TextStyle(
        fontSize: 20.0,
      ),
      subtitle2: TextStyle(
        fontSize: 18.0,
        color: Colors.white,
      ),
      headline4: TextStyle(
        fontSize: 20.0,
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    ),
    disabledColor: Colors.grey[300],
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    primaryColor: Colors.teal,
    textTheme: TextTheme(
      headline6: TextStyle(
        fontSize: 20.0,
      ),
      subtitle2: TextStyle(
        fontSize: 18.0,
        // color: Colors.white,
      ),
      headline4: TextStyle(
        fontSize: 20.0,
        // color: Colors.white,
      ),
      bodyText1: TextStyle(
        fontSize: 16.0,
        // color: Colors.black,
      ),
    ),
    // disabledColor: Colors.grey[300],
  );
}
