import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
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
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    primaryColor: Colors.teal,
    textTheme: TextTheme(
      title: TextStyle(
        fontSize: 20.0,
      ),
      subtitle: TextStyle(
        fontSize: 18.0,
        // color: Colors.white,
      ),
      display1: TextStyle(
        fontSize: 20.0,
        // color: Colors.white,
      ),
      body2: TextStyle(
        fontSize: 16.0,
        // color: Colors.black,
      ),
    ),
    // disabledColor: Colors.grey[300],
  );
}
