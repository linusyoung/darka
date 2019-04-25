import 'dart:async';
import 'dart:io';

import 'package:darka/darka_utils.dart';
import 'package:darka/model/task.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DarkaDatabase {
  static final DarkaDatabase _instance = DarkaDatabase._internal();

  factory DarkaDatabase() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  DarkaDatabase._internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    print(path);
    var theDb = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade,
    );
    return theDb;
  }

  // void _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   await db.execute('''CREATE TABLE APIKey(
  //     api_key TEXT PRIMARY KEY,
  //     key_type TEXT
  //   )''');
  // }

  void _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE TASK_LIST (
      uuid TEXT PRIMARY KEY,
      task_name TEXT,
      is_deleted BIT,
      punched_today BIT)''');

    await db.execute('''CREATE TABLE PUNCH_LIST(
      uuid TEXT PRIMARY KEY,
      task_id TEXT,
      date TEXT,
      FOREIGN KEY (task_id) REFERENCES TASK_LIST(uuid))''');
  }

  Future<int> createTask(Task task) async {
    var dbClient = await db;
    int res;
    res = await dbClient.insert("TASK_LIST", task.toMap());
    // TODO: remove debug text
    print('Task added $res');
    return res;
  }

  Future<void> updateTask(Task task) async {
    var dbClient = await db;

    await dbClient.update("TASK_LIST", task.toMap(),
        where: "uuid = ?", whereArgs: [task.uuid]);
    var punchValue = Map<String, dynamic>();
    punchValue['uuid'] = DarkaUtils().generateV4();
    punchValue['task_id'] = task.uuid;
    punchValue['date'] = DarkaUtils().dateFormat(DateTime.now());

    int res = await dbClient.insert("PUNCH_LIST", punchValue);
    print(res);
  }

  Future<List<Task>> getTasks() async {
    var dbClient = await db;
    List<Map> storedTasks = await dbClient
        .query("TASK_LIST", where: "is_deleted = ?", whereArgs: [0]);

    List<Task> tasks = [];
    if (storedTasks.length > 0) {
      List<Task> returnTasks = [];
      List<Task> tasks = storedTasks.map((task) => Task.fromDb(task)).toList();
      for (var task in tasks) {
        List<bool> recentPunch = List.filled(8, false);
        for (var i = 8; i > 0; i--) {
          var recentDate = DarkaUtils()
              .dateFormat(DateTime.now().subtract(Duration(days: i)));
          List<Map> punched = await dbClient.query("PUNCH_LIST",
              where: "task_id = ? and date = ?",
              whereArgs: [task.uuid, recentDate]);
          if (punched.length > 0) {
            recentPunch[8 - i] = true;
            print(punched);
          }
        }
        returnTasks.add(task.copyWith(recentPunched: recentPunch));
      }
      tasks.clear();
      return returnTasks;
    }
    return tasks;
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }
}
