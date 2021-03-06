class Task {
  final String uuid;
  final String dateAdded;
  String name;
  bool punchedToday;
  bool isDeleted;
  int labelColor;
  List<bool> recentPunched;
  List<String> punchedDates;

  Task(this.uuid, this.name, this.dateAdded,
      {this.labelColor = 0,
      this.punchedToday = false,
      this.isDeleted = false}) {
    this.recentPunched = List.filled(8, false);
  }

  Task copyWith({
    String name,
    String dateAdded,
    bool punchedToday,
    bool isDeleted,
    List<bool> recentPunched,
    List<String> punchedDates,
    int labelColor,
  }) {
    Task _task = Task(
      uuid ?? this.uuid,
      name ?? this.name,
      dateAdded ?? this.dateAdded,
      labelColor: labelColor ?? this.labelColor,
      punchedToday: punchedToday ?? this.punchedToday,
      isDeleted: isDeleted ?? this.isDeleted,
    );

    _task.recentPunched = recentPunched ?? this.recentPunched;
    _task.punchedDates = punchedDates ?? this.punchedDates;

    return _task;
  }

  @override
  String toString() => 'name: $name, punchedToday: $punchedToday';

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['uuid'] = uuid;
    map['date_added'] = dateAdded;
    map['task_name'] = name;
    map['label_color'] = labelColor.toString();
    map['punched_today'] = punchedToday;
    map['is_deleted'] = isDeleted;
    return map;
  }

  factory Task.fromDb(Map map) {
    return Task(
      map['uuid'],
      map['task_name'],
      map['date_added'],
      labelColor: int.parse(map['label_color']) ?? 0,
      punchedToday: map['punched_today'] == 1 ? true : false,
      isDeleted: map['is_deleted'] == 1 ? true : false,
    );
  }
}
