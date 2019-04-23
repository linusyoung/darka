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
  // TODO: implement initialState
  TasksState get initialState => TasksLoading();

  @override
  Stream<TasksState> mapEventToState(TaskEvent event) async* {
    if (event is LoadTasks) {
      yield* _mapLoadTasksToState();
    } else if (event is AddTask) {
      yield* _mapAddTaskToState(currentState, event);
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
      // TODO: add to db
      // _saveTasks(updatedTasks);
    }
  }

  // Future _saveTask(List<Task> tasks){

  // }
}
