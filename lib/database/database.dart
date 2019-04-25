import 'dart:async';
import 'dart:io';

import 'package:darka/model/task.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DarkaDatabase {
  factory DarkaDatabase() => _instance;
  static final DarkaDatabase _instance = DarkaDatabase._internal();

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

    // await db.execute('''CREATE TABLE PUNCH_LIST(
    //   uid TEXT PRIMARY KEY,
    //   task_id TEXT FOREIGN KEY,
    //   date TEXT,
    //   is_punched BIT)''');
  }

  Future<int> createTask(Task task) async {
    var dbClient = await db;
    int res;
    res = await dbClient.insert("TASK_LIST", task.toMap());
    // TODO: remove debug text
    print('Task added $res');
    return res;
  }

  // Future<int> updateTask(Task task) async {
  //   var dbClient = await db;

  //   int res = await dbClient.update("TASK_LIST", task.toMap(),
  //       where: "uid = ?", whereArgs: [task.uuid]);
  //   // TODO: remove debug text
  //   print('Task $res is updated.');
  //   return res;
  // }

  Future<List<Task>> getTasks() async {
    var dbClient = await db;
    List<Map> storedTask = await dbClient
        .query("TASK_LIST", where: "is_deleted = ?", whereArgs: [0]);

    return storedTask.length > 0
        ? storedTask.map((task) => Task.fromDb(task)).toList()
        : [];
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }
}
