import 'package:darka/blocs/blocs.dart';
import 'package:darka/model/models.dart';
import 'package:darka/pages/pages_helper.dart';
import 'package:darka/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskPage extends StatefulWidget {
  final BuildContext context;

  TaskPage(this.context);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    var snackBar = SnackBar(
      content: Text(
        'Task is removed.',
        semanticsLabel: 'Task is removed.',
      ),
    );
    TaskBloc _taskBloc = BlocProvider.of<TaskBloc>(context);
    return BlocBuilder(
      bloc: _taskBloc,
      builder: (
        BuildContext context,
        TasksState state,
      ) {
        if (state is TasksLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TasksLoaded) {
          final tasks = state.tasks;
          return Center(
            child: tasks.length > 0
                ? ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      Task task = tasks[index];
                      return TaskItem(
                        task: task,
                        viewDetail: () =>
                            viewTaskDetail(context, task, _taskBloc),
                        punchToday: () => punchTask(task, _taskBloc),
                        onDismissed: (direction) {
                          _taskBloc.add(DeleteTask(task));
                          Scaffold.of(context).showSnackBar(snackBar);
                        },
                      );
                    },
                  )
                : Text(
                    'Add your first task',
                    style: Theme.of(context).textTheme.display1,
                  ),
          );
        } else if (state is TasksNotLoaded) {
          return Text(
            'not loaded',
            semanticsLabel: 'data is not loaded.',
          );
        }
        return null;
      },
    );
  }

  // void _punchTask(Task task, TaskBloc taskBloc) {
  //   if (!task.punchedToday) {
  //     taskBloc.add(UpdateTask(task.copyWith(punchedToday: !task.punchedToday)));
  //     TaskPage.player.play(holePunchAudioPath);
  //     taskBloc.add(LoadTasks());
  //   }
  // }
}
