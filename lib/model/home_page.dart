import 'package:darka/database/database.dart';
import 'package:darka/model/task.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DarkaDatabase db;

  @override
  void initState() {
    super.initState();
    db = DarkaDatabase();
    db.initDb();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
              decoration: InputDecoration(hintText: "Task name"),
              autofocus: true,
              onChanged: (String taskName) {
                addNewTask(taskName);
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void addNewTask(String taskName) async {
    final uuid = new Uuid();
    var task =
        Task(uuid: uuid, taskName: taskName, isDeleted: false, isVisible: true);
    await db.createTask(task);
  }
}
