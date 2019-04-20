// import 'package:uuid/uuid.dart';

// class Task {
//   final String taskName;
//   bool isDeleted;
//   bool isVisible;
//   final Uuid uuid;

//   Task({this.uuid, this.taskName, this.isDeleted, this.isVisible});

//   Map<String, dynamic> toMap() {
//     var map = Map<String, dynamic>();
//     map['uid'] = uuid;
//     map['task_name'] = taskName;
//     map['is_deleted'] = isDeleted;
//     map['is_visilbe'] = isVisible;
//     return map;
//   }

//   factory Task.fromDb(Map map) {
//     return Task(
//         uuid: map['uid'],
//         taskName: map['task_name'],
//         isDeleted: map['is_deleted'],
//         isVisible: map['is_visible']);
//   }
// }
