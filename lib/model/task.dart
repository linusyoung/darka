// import 'package:uuid/uuid.dart';

class Task {
  final String name;
  bool punchedToday;
  List<bool> recentPunched;
  // bool isDeleted;
  // bool isVisible;
  // final Uuid uuid;

  Task({this.name, this.punchedToday});

  // Map<String, dynamic> toMap() {
  //   var map = Map<String, dynamic>();
  //   map['uid'] = uuid;
  //   map['task_name'] = taskName;
  //   map['is_deleted'] = isDeleted;
  //   map['is_visilbe'] = isVisible;
  //   return map;
  // }

  factory Task.fromDb(Map map) {
    return Task(
        // uuid: map['uid'],
        name: map['task_name'],
        punchedToday: map['punchedToday']);
  }
}
