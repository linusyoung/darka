// import 'package:darka/database/database.dart';
import 'dart:async';

import 'package:darka/animations/custom_fab_animation.dart';
import 'package:darka/pages/pages.dart';
import 'package:darka/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

import 'package:darka/model/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darka/blocs/blocs.dart';
// import 'package:uuid/uuid.dart';

const holePunchAudioPath = 'sound/hole_punch.mp3';

class TaskPage extends StatefulWidget {
  TaskPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  // DarkaDatabase db;

  static AudioCache player = AudioCache();
  final TabBloc _tabBloc = TabBloc();
  TaskBloc _taskBloc;

  @override
  void initState() {
    _taskBloc = BlocProvider.of<TaskBloc>(context);
    _taskBloc.dispatch(LoadTasks());
    super.initState();
  }

  @override
  void dispose() {
    _taskBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _tabBloc,
        builder: (BuildContext context, AppTab activeTab) {
          return BlocProviderTree(
            blocProviders: [
              BlocProvider<TabBloc>(bloc: _tabBloc),
              BlocProvider<TaskBloc>(bloc: _taskBloc),
            ],
            child: Scaffold(
              appBar: AppBar(
                title:
                    activeTab == AppTab.tasks ? Text('Darka') : Text('Summary'),
              ),
              body: activeTab == AppTab.tasks ? taskPage(context) : Summary(),
              floatingActionButtonLocation: activeTab == AppTab.tasks
                  ? FloatingActionButtonLocation.centerDocked
                  : null,
              floatingActionButton: activeTab == AppTab.tasks
                  ? FloatingActionButton(
                      child: Icon(Icons.add), onPressed: _addNewTask)
                  : null,
              floatingActionButtonAnimator:
                  activeTab == AppTab.tasks ? CustomFabAnimation() : null,
              bottomNavigationBar: TabSelector(
                activeTab: activeTab,
                onTabSelected: (tab) => _tabBloc.dispatch(UpdateTab(tab)),
              ),
            ),
          );
        });
  }

  void _addNewTask() {
    _showTaskInput(context).then((String value) {
      if (value != null) {
        var task = Task(name: value, punchedToday: false);
        task.recentPunched = [
          true,
          false,
          false,
          true,
          true,
          false,
          true,
          false
        ];
        _taskBloc.dispatch(AddTask(task));
      }
    });
  }

  void _punchTask(Task task) {
    if (task.punchedToday) {
      player.play(holePunchAudioPath);
    }
  }

  void _viewTaskDetail(Task task) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => TaskDetail(task)));
  }

  Future<String> _showTaskInput(BuildContext context) async {
    String taskName;
    var inputText = AlertDialog(
      title: Text('Task name'),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Give a short name to track your task.',
        ),
        onChanged: (text) {
          taskName = text;
        },
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: const Text('Confirm'),
          textColor: Colors.white,
          onPressed: () => Navigator.of(context).pop(taskName),
        ),
      ],
    );

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return inputText;
      },
    );
  }

  Widget taskPage(BuildContext context) {
    var snackBar = SnackBar(
      content: Text('Task is removed.'),
    );

    return BlocBuilder(
      bloc: _taskBloc,
      builder: (
        BuildContext context,
        TasksState state,
      ) {
        if (state is TasksLoading) {
          return CircularProgressIndicator();
        } else if (state is TasksLoaded) {
          final tasks = state.tasks;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              Task task = tasks[index];
              return TaskItem(
                task: task,
                viewDetail: () => _viewTaskDetail(task),
                punchTooday: () => _punchTask(task),
                onDismissed: (direction) {
                  // tasks.removeAt(index);
                  Scaffold.of(context).showSnackBar(snackBar);
                },
              );
            },
          );
        }
      },
    );
  }
}
