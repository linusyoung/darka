import 'package:bloc/bloc.dart';
import 'package:darka/database/database.dart';
import 'package:darka/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darka/blocs/blocs.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(DarkaApp());
}

class DarkaApp extends StatefulWidget {
  @override
  _DarkaAppState createState() => _DarkaAppState();
}

class _DarkaAppState extends State<DarkaApp> {
  final taskBloc = TaskBloc(darkaDb: DarkaDatabase());
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      bloc: taskBloc,
      child: MaterialApp(
        title: 'Darka',
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: TaskPage(
          title: 'Darka',
        ),
      ),
    );
  }
}
