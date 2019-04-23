import 'dart:async';
// import 'dart:io';

import 'package:darka/model/task.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

class DarkaDatabase {
  List<Task> taskList;

  DarkaDatabase() {
    var _task = Task(name: 'task from db1', punchedToday: false);
    this.taskList = [];
    this.taskList.add(_task);
    _task = Task(name: 'task from db2', punchedToday: true);
    this.taskList.add(_task);
  }

  Future<List<Task>> getTasks() async {
    await Future.delayed(Duration(seconds: 3));

    return this.taskList;
  }
}

// class DarkaDatabase {
//   static final DarkaDatabase _instance = DarkaDatabase._internal();

//   factory DarkaDatabase() => _instance;

//   static Database _db;

//   Future<Database> get db async {
//     if (_db != null) {
//       return _db;
//     } else {
//       _db = await initDb();
//       return _db;
//     }
//   }

//   DarkaDatabase._internal();

//   initDb() async {
//     Directory documentDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentDirectory.path, "main.db");
//     var theDb = await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//       // onUpgrade: _onUpgrade,
//     );
//     return theDb;
//   }

//   // void _onUpgrade(Database db, int oldVersion, int newVersion) async {
//   //   await db.execute('''CREATE TABLE APIKey(
//   //     api_key TEXT PRIMARY KEY,
//   //     key_type TEXT
//   //   )''');
//   // }

//   void _onCreate(Database db, int version) async {
//     await db.execute('''CREATE TABLE TASK_LIST (
//         uid TEXT PRIMARY KEY,
//         task_name TEXT,
//         is_deleted BIT,
//         is_visible BIT)''');

//     await db.execute('''CREATE TABLE PUNCH_LIST(
//       uid TEXT PRIMARY KEY,
//       task_id TEXT FOREIGN KEY,
//       date TEXT,
//       is_punched BIT)''');
//   }

//   Future<int> createTask(Task task) async {
//     var dbClient = await db;
//     int res;
//     res = await dbClient.insert("TASK_LIST", task.toMap());
//     // TODO: remove debug text
//     print('Task added $res');
//     return res;
//   }

//   Future<int> updateTask(Task task) async {
//     var dbClient = await db;

//     int res = await dbClient.update("TASK_LIST", task.toMap(),
//         where: "uid = ?", whereArgs: [task.uuid]);
//     // TODO: remove debug text
//     print('Task $res is updated.');
//     return res;
//   }

//   Future<Task> getTask(String uid) async {
//     var dbClient = await db;
//     Task task;
//     List<Map> storedTask =
//         await dbClient.query("TASK_LIST", where: "date = ?", whereArgs: [uid]);
//     if (storedTask.length > 0) {
//       task = Task.fromDb(storedTask[0]);
//     } else {
//       // TODO: remove debug text
//       print('Task not found');
//     }
//     return task;
//   }

//   Future closeDb() async {
//     var dbClient = await db;
//     dbClient.close();
//   }
// }
