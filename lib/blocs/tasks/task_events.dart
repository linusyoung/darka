import 'package:darka/model/task.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  AddTask(this.task);

  @override
  String toString() => 'AddTask { task: $task.name }';
}

class UpdateTask extends TaskEvent {
  final Task updatedTask;
  UpdateTask(this.updatedTask);

  @override
  String toString() => 'UpdateTask { task: ${updatedTask.punchedToday}';
}

class DeleteTask extends TaskEvent {
  final Task deletedTask;

  DeleteTask(this.deletedTask);

  @override
  String toString() => 'DeleteTask { task: $deletedTask.punchedDay }';
}
