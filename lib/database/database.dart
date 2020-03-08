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
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return theDb;
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('''ALTER TABLE TASK_LIST ADD COLUMN label_color TEXT''');
      await db.execute('''INSERT INTO TASK_LIST (label_color) VALUES ('0')''');
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE TASK_LIST (
      uuid TEXT PRIMARY KEY,
      task_name TEXT,
      date_added TEXT,
      is_deleted BIT,
      label_color TEXT,
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
    return res;
  }

  Future<void> updateTask(Task task) async {
    var dbClient = await db;
    print(task.runtimeType != null);
    if (task.runtimeType != null) {
      await dbClient.update("TASK_LIST", task.toMap(),
          where: "uuid = ?", whereArgs: [task.uuid]);
      if (task.punchedToday) {
        String today = DarkaUtils().dateFormat(DateTime.now());
        List<Map> isTodayPunched = await dbClient.query("PUNCH_LIST",
            where: "task_id = ? and date = ?", whereArgs: [task.uuid, today]);
        if (isTodayPunched.length == 0) {
          var punchValue = Map<String, dynamic>();
          punchValue['uuid'] = DarkaUtils().generateV4();
          punchValue['task_id'] = task.uuid;
          punchValue['date'] = DarkaUtils().dateFormat(DateTime.now());
          int res = await dbClient.insert("PUNCH_LIST", punchValue);
          print(res);
        }
      }
    }
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
        List<bool> recentPunched = List.filled(8, false);
        bool punchedToday = false;
        for (var i = 8; i >= 0; i--) {
          var recentDate = DarkaUtils()
              .dateFormat(DateTime.now().subtract(Duration(days: i)));
          List<Map> recentDatePunched = await dbClient.query("PUNCH_LIST",
              where: "task_id = ? and date = ?",
              whereArgs: [task.uuid, recentDate]);
          if (recentDatePunched.length > 0) {
            i == 0 ? punchedToday = true : recentPunched[8 - i] = true;
          }
        }
        task.punchedToday = punchedToday;
        List<Map<String, dynamic>> allPunched = await dbClient.query(
            "PUNCH_LIST",
            columns: ['date'],
            where: "task_id = ?",
            whereArgs: [task.uuid]);
        var punchedDates =
            allPunched.map((punch) => punch['date'].toString()).toList();
        returnTasks.add(task.copyWith(
          recentPunched: recentPunched,
          punchedDates: punchedDates,
        ));
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
