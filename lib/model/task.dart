// import 'package:uuid/uuid.dart';

class Task {
  final String name;
  bool punchedToday;
  List<bool> recentPunched;
  // bool isDeleted;
  // bool isVisible;
  // final Uuid uuid;

  Task(this.name, {this.punchedToday = false}) {
    this.recentPunched = List.filled(8, false);
  }

  Task copyWith({String name, bool punchedToday, List<bool> recentPunched}) {
    Task _task = Task(
      name ?? this.name,
      punchedToday: punchedToday ?? this.punchedToday,
    );

    _task.recentPunched = recentPunched;

    return _task;
  }

  @override
  String toString() => 'name: $name, punchedToday: $punchedToday';
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
        map['task_name'],
        punchedToday: map['punchedToday']);
  }
}
