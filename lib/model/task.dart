class Task {
  final String uuid;
  final String name;
  bool punchedToday;
  final bool isDeleted;
  List<bool> recentPunched;
  List<DateTime> punchedDates;

  Task(this.uuid, this.name,
      {this.punchedToday = false, this.isDeleted = false}) {
    this.recentPunched = List.filled(8, false);
  }

  Task copyWith({
    String name,
    bool punchedToday,
    bool isDeleted,
    List<bool> recentPunched,
  }) {
    Task _task = Task(
      uuid ?? this.uuid,
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
    map['uuid'] = uuid;
    map['task_name'] = name;
    map['punched_today'] = punchedToday;
    map['is_deleted'] = isDeleted;
    return map;
  }

  factory Task.fromDb(Map map) {
    return Task(
      map['uuid'],
      map['task_name'],
      punchedToday: map['punched_today'] == 1 ? true : false,
      isDeleted: map['is_deleted'] == 1 ? true : false,
    );
  }
}
