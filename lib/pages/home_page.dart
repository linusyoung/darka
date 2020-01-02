import 'dart:async';

// import 'package:darka/locale/locales.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

import 'package:darka/model/models.dart';
import 'package:darka/animations/custom_fab_animation.dart';
import 'package:darka/pages/pages.dart';
import 'package:darka/widgets/widgets.dart';
import 'package:darka/blocs/blocs.dart';
import 'package:darka/darka_utils.dart';

const holePunchAudioPath = 'sound/hole_punch.mp3';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
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
    // Locale locale = Localizations.localeOf(context);
    // print(locale.languageCode);
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
                    activeTab == AppTab.tasks ? Text('Tasks') : Text('Summary'),
                centerTitle: true,
              ),
              body: activeTab == AppTab.tasks
                  ? taskPage(context)
                  : Summary(context),
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
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TasksLoaded) {
          final tasks = state.tasks;
          return Center(
            child: tasks.length > 0
                ? ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      Task task = tasks[index];
                      return TaskItem(
                        task: task,
                        viewDetail: () => _viewTaskDetail(task),
                        punchToday: () => _punchTask(task),
                        onDismissed: (direction) {
                          _taskBloc.dispatch(DeleteTask(task));
                          Scaffold.of(context).showSnackBar(snackBar);
                        },
                      );
                    },
                  )
                : Text(
                    'Add your first task',
                    style: Theme.of(context).textTheme.display1,
                  ),
          );
        } else if (state is TasksNotLoaded) {
          return Text('not loaded');
        }
        return null;
      },
    );
  }

  void _addNewTask() {
    _showTaskInput(context).then((String value) {
      if (value != null) {
        var task = Task(
          DarkaUtils().generateV4(),
          value,
          DarkaUtils().dateFormat(DateTime.now()),
          punchedToday: false,
        );
        _taskBloc.dispatch(AddTask(task));
      }
    });
  }

  void _punchTask(Task task) {
    if (!task.punchedToday) {
      _taskBloc.dispatch(
          UpdateTask(task.copyWith(punchedToday: !task.punchedToday)));
      player.play(holePunchAudioPath);
      _taskBloc.dispatch(LoadTasks());
    }
  }

  // TODO: change view task detail to global
  void _viewTaskDetail(Task task) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => TaskDetail(task))).then((task) {
      _taskBloc.dispatch(UpdateTask(task));
    });
  }

  Future<String> _showTaskInput(BuildContext context) async {
    String taskName;
    var inputText = AlertDialog(
      title: Text('Task Name'),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Give a task name...',
        ),
        onChanged: (text) {
          taskName = text;
        },
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Cancel',
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
            child: Text(
              'Confirm',
            ),
            textColor: Colors.deepOrange,
            onPressed: () {
              Navigator.of(context).pop(taskName);
              print(taskName);
            }),
      ],
    );

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return inputText;
      },
    );
  }
}
