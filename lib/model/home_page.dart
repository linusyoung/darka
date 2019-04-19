// import 'package:darka/database/database.dart';
// import 'package:darka/model/task.dart';
import 'package:flutter/material.dart';
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          singleTask(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget singleTask() {
    var taskName = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('I am your first task. Please keep punching.'),
          )
        ],
      ),
    );
    return Container(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 35.0, 8.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: constructCalendar(),
            ),
          ),
          taskName,
        ],
      ),
    );
  }

  List<Widget> constructCalendar() {
    final daysToShow = 8;
    var cal = List<Widget>();
    final calendarDays = getCalendarDays(daysToShow);
    var punchDay = Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        child: Container(
          child: Center(
            child: Text(
              calendarDays['dayOfToday'].toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          padding: const EdgeInsets.all(8.0),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey),
          width: 50.0,
          height: 50.0,
        ),
      ),
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
            padding: const EdgeInsets.all(8.0),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey),
            width: 32.0,
            height: 32.0,
          ),
        ),
      ));
    }
    cal.add(punchDay);
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
}
