import 'package:darka/model/task_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darka',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: TaskPage(
        title: 'Darka',
      ),
    );
  }
}
