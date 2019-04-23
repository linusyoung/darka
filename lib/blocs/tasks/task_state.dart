import 'package:darka/model/task.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task> tasks;

  TasksLoaded(this.tasks);
}

class TasksNotLoaded extends TasksState {}
