// import 'package:uuid/uuid.dart';

class Task {
  final String name;
  bool punchedToday;
  bool isDeleted;
  List<bool> recentPunched;
  // bool isDeleted;
  // bool isVisible;
  // final Uuid uuid;

  Task(this.name, {this.punchedToday = false, this.isDeleted = false}) {
    this.recentPunched = List.filled(8, true);
  }

  Task copyWith({
    String name,
    bool punchedToday,
    bool isDeleted,
    List<bool> recentPunched,
  }) {
    Task _task = Task(
      name ?? this.name,
      punchedToday: punchedToday ?? this.punchedToday,
      isDeleted: isDeleted ?? this.isDeleted,
    );

    _task.recentPunched = recentPunched ?? this.recentPunched;

    return _task;
  }

  @override
  String toString() => 'name: $name, punchedToday: $punchedToday';

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    // map['uid'] = uuid;
    map['task_name'] = name;
    map['punched_today'] = punchedToday;
    map['is_deleted'] = isDeleted;
    return map;
  }

  factory Task.fromDb(Map map) {
    return Task(
        // uuid: map['uid'],
        map['task_name'],
        punchedToday: map['punched_today'],
        isDeleted: map['is_deleted']);
  }
}
