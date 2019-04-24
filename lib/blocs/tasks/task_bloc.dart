import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:darka/blocs/tasks/task_events.dart';
import 'package:darka/blocs/tasks/task_state.dart';
import 'package:darka/database/database.dart';
import 'package:darka/model/task.dart';
import 'package:meta/meta.dart';

class TaskBloc extends Bloc<TaskEvent, TasksState> {
  final DarkaDatabase darkaDb;

  TaskBloc({@required this.darkaDb});

  @override
  TasksState get initialState => TasksLoading();

  @override
  Stream<TasksState> mapEventToState(TaskEvent event) async* {
    if (event is LoadTasks) {
      yield* _mapLoadTasksToState();
    } else if (event is AddTask) {
      yield* _mapAddTaskToState(currentState, event);
    } else if (event is UpdateTask) {
      yield* _mapUpdateTaskToState(currentState, event);
    } else if (event is DeleteTask) {
      yield* _mapDeleteTaskToState(currentState, event);
    }
  }

  Stream<TasksState> _mapLoadTasksToState() async* {
    try {
      final tasks = await this.darkaDb.getTasks();
      yield TasksLoaded(
        tasks.toList(),
      );
    } catch (_) {
      yield TasksNotLoaded();
    }
  }

  Stream<TasksState> _mapAddTaskToState(
    TasksState currentState,
    AddTask event,
  ) async* {
    if (currentState is TasksLoaded) {
      final List<Task> updatedTasks = List.from(currentState.tasks)
        ..add(event.task);
      yield TasksLoaded(updatedTasks);
      _addTask(event.task);
    }
  }

  Stream<TasksState> _mapUpdateTaskToState(
    TasksState currentState,
    UpdateTask event,
  ) async* {
    if (currentState is TasksLoaded) {
      final List<Task> updatedTasks = currentState.tasks.map((task) {
        return task.name == event.updatedTask.name ? event.updatedTask : task;
      }).toList();
      yield TasksLoaded(updatedTasks);
      // TODO: add to db
      // _saveTasks(updatedTasks);
    }
  }

  Stream<TasksState> _mapDeleteTaskToState(
    TasksState currentState,
    DeleteTask event,
  ) async* {
    if (currentState is TasksLoaded) {
      final updatedTasks = currentState.tasks
          .where((task) => task.name != event.deletedTask.name)
          .toList();
      yield TasksLoaded(updatedTasks);
    }
  }

  Future _addTask(Task task) async {
    DarkaDatabase db = DarkaDatabase();
    await db.createTask(task);
  }
  // Future _saveTask(List<Task> tasks){

  // }
}
