// import 'package:darka/database/database.dart';
import 'dart:async';

import 'package:darka/animations/custom_fab_animation.dart';
import 'package:darka/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

import 'package:darka/model/task.dart';
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
  TaskBloc _taskBloc;

  List<Task> taskList = [];
  List<Widget> pageList = [];

  var _currentPageIndex = 0;
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
    var page = _currentPageIndex == 0 ? taskPage(context) : summaryPage();
    return page;
  }

  Widget _buildTask(Task task) {
    var taskName = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(task.name),
          )
        ],
      ),
    );
    return Column(
      children: <Widget>[
        taskName,
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _constructCalendar(task, context),
          ),
        ),
        Divider(
          height: 8.0,
        ),
      ],
    );
  }

  List<Widget> _constructCalendar(Task task, BuildContext context) {
    // TODO: change past days to list view
    final daysToShow = 8;
    bool isPunchedToday = task.punchedToday;
    List<Widget> cal = [];
    final calendarDays = getCalendarDays(daysToShow);
    var punchButton = RaisedButton(
      child: Container(
        width: 25.0,
        height: 25.0,
        decoration: isPunchedToday
            ? ShapeDecoration(
                shape: CircleBorder(),
                color: Colors.white,
              )
            : null,
        child: Center(
          child: Text(
            calendarDays['dayOfToday'].toString(),
            style: isPunchedToday ? null : TextStyle(color: Colors.white),
          ),
        ),
      ),
      shape: CircleBorder(),
      // color: Theme.of(context).accentColor,
      disabledElevation: 0.0,
      disabledTextColor: Colors.white,
      elevation: 4.0,
      onPressed: null,
      //  isPunchedToday ? null : () => _punchTask(index),
    );
    var punchDay = Padding(
      padding: const EdgeInsets.all(4.0),
      child: ButtonTheme(
        minWidth: 50.0,
        height: 50.0,
        child: punchButton,
      ),
    );
    var viewDetailButton = GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.keyboard_arrow_right,
            color: Theme.of(context).buttonColor,
          ),
        ),
      ),
      onTap: () => _viewTaskDetail(task),
    );

    for (var i = 0; i < daysToShow; i++) {
      int showDay = calendarDays['startDay'] + i;
      showDay = showDay > calendarDays['lastDayOfLastMonth']
          ? showDay - calendarDays['lastDayOfLastMonth']
          : showDay;
      // bool isPunched = task.recentPunched[i];
      bool isPunched = false;

      var historyDay = Padding(
        padding: const EdgeInsets.all(2.5),
        child: InkWell(
          child: Container(
            child: Center(
              child: Container(
                width: 18.0,
                height: 18.0,
                decoration: isPunched
                    ? ShapeDecoration(
                        shape: CircleBorder(),
                        color: Colors.white,
                      )
                    : null,
                child: Center(
                  child: Text(
                    showDay.toString(),
                    style: isPunched ? null : TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
            width: 32.0,
            height: 32.0,
          ),
        ),
      );
      cal.add(historyDay);
    }
    cal.add(punchDay);
    cal.add(viewDetailButton);
    return cal;
  }

  Map getCalendarDays(int daysToShow) {
    Map calendarDays = Map();
    int dayOfToday = DateTime.now().day;
    DateTime today = DateTime.now();
    int lastDayOfLastMonth = DateTime(today.year, today.month, 0).day;
    int startDay = dayOfToday - daysToShow;
    startDay = startDay >= 1 ? startDay : startDay + lastDayOfLastMonth;
    calendarDays['dayOfToday'] = dayOfToday;
    calendarDays['startDay'] = startDay;
    calendarDays['lastDayOfLastMonth'] = lastDayOfLastMonth;
    return calendarDays;
  }
  // void addNewTask(String taskName) async {
  //   final uuid = new Uuid();
  //   var task =
  //       Task(uuid: uuid, taskName: taskName, isDeleted: false, isVisible: true);
  //   await db.createTask(task);
  // }

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
        setState(() {
          taskList.insert(0, task);
        });
      }
    });
  }

  void _punchTask(int index) {
    player.play(holePunchAudioPath);
    setState(() {
      taskList[index].punchedToday = true;
    });
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
    var newTaskButton = FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: _addNewTask,
    );

    // var taskListView = ListView.builder(
    //   itemCount: taskList.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return Dismissible(
    //         key: Key(taskList[index].name ?? 'null'),
    //         onDismissed: (direction) {
    //           taskList.removeAt(index);
    //           Scaffold.of(context).showSnackBar(snackBar);
    //         },
    //         child: _buildTask(index));
    //   },
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: newTaskButton,
      floatingActionButtonAnimator: CustomFabAnimation(),
      body: BlocBuilder(
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
                return Dismissible(
                    key: Key(tasks[index].name ?? 'null'),
                    onDismissed: (direction) {
                      taskList.removeAt(index);
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: _buildTask(tasks[index]));
              },
            );
          }
        },
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }

  Widget summaryPage() {
    /*  # of tasks
    **  # of tasks did last week, last month
    **  # individual task summary  
    */

    var summaryTitleBar = SliverAppBar(
      expandedHeight: 180.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Summary'),
      ),
      pinned: true,
      floating: false,
    );

    var summaryList = SliverList(
      delegate: SliverChildListDelegate([
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Text('# of tasks'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('1'),
                      Text('punched: 10'),
                      Icon(Icons.info),
                    ],
                  ),
                  Text('211'),
                ],
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            )
          ],
        )
      ]),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          summaryTitleBar,
          summaryList,
        ],
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }

  Widget bottomNavBar() {
    var navigationBarItems = [
      BottomNavigationBarItem(
        title: Text('Tasks'),
        icon: Icon(Icons.chat),
      ),
      BottomNavigationBarItem(
        title: Text('Chart'),
        icon: Icon(Icons.history),
      ),
    ];
    return BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: navigationBarItems);
  }
}
