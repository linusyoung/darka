// import 'package:darka/database/database.dart';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:darka/model/task.dart';
import 'package:darka/model/task_detail.dart';
// import 'package:uuid/uuid.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // DarkaDatabase db;

  // @override
  // void initState() {
  //   super.initState();
  //   db = DarkaDatabase();
  //   db.initDb();
  // }

  List<Task> taskList = [];

  Widget build(BuildContext context) {
    var snackBar = SnackBar(
      content: Text('Task is removed.'),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
              key: Key(taskList[index].name ?? 'null'),
              onDismissed: (direction) {
                taskList.removeAt(index);
                Scaffold.of(context).showSnackBar(snackBar);
              },
              child: _buildTask(index));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewTask,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            title: Text('Tasks'),
            icon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
            title: Text('Chart'),
            icon: Icon(Icons.history),
          ),
        ],
      ),
    );
  }

  Widget _buildTask(int index) {
    print(taskList.length);
    if (index >= taskList.length) {
      return null;
    }
    var taskName = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(taskList[index].name),
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
            children: constructCalendar(index, context),
          ),
        ),
        Divider(
          height: 8.0,
        ),
      ],
    );
  }

  List<Widget> constructCalendar(int index, BuildContext context) {
    // TODO: change past days to list view
    final daysToShow = 7;
    List<Widget> cal = [];
    final calendarDays = getCalendarDays(daysToShow);
    var punchDay = Padding(
      padding: const EdgeInsets.all(4.0),
      child: ButtonTheme(
        minWidth: 50.0,
        height: 50.0,
        child: RaisedButton(
          child: Text(
            calendarDays['dayOfToday'].toString(),
          ),
          textColor: Colors.white,
          shape: CircleBorder(),
          color: Theme.of(context).accentColor,
          disabledElevation: 0.0,
          disabledTextColor: Colors.white,
          elevation: 4.0,
          // set to null once it's pressed.
          onPressed: () {},
        ),
      ),
    );
    var task = taskList[index];
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
      var showDay = calendarDays['startDay'] + i;
      showDay = showDay > calendarDays['lastDayOfLastMonth']
          ? showDay - calendarDays['lastDayOfLastMonth']
          : showDay;

      cal.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          child: Container(
            child: Center(
              child: Text(
                showDay.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            padding: const EdgeInsets.all(4.0),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
            width: 32.0,
            height: 32.0,
          ),
        ),
      ));
    }
    cal.add(punchDay);
    cal.add(viewDetailButton);
    return cal;
  }

  Map getCalendarDays(int daysToShow) {
    var calendarDays = Map();
    var dayOfToday = DateTime.now().day;
    dayOfToday = 7;
    var today = DateTime.now();
    var lastDayOfLastMonth = DateTime(today.year, today.month, 0).day;
    var startDay = dayOfToday - daysToShow;
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
      var task = Task(name: value);
      print(task.name);
      setState(() {
        taskList.insert(0, task);
      });
    });
  }

  void _viewTaskDetail(Task task) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => TaskDetail(task)));
  }

  Future<String> _showTaskInput(BuildContext context) async {
    String taskName = "";
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
          child: const Text('Confirm'),
          onPressed: () {
            Navigator.of(context).pop(taskName);
          },
        ),
        FlatButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        )
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
