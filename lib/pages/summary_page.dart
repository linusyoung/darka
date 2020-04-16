import 'package:darka/blocs/blocs.dart';
import 'package:darka/locale/locales.dart';
// import 'package:darka/model/models.dart';
import 'package:darka/pages/pages_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:darka/pages/pages.dart';

class Summary extends StatefulWidget {
  final BuildContext context;

  Summary(this.context);

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  TaskBloc _taskBloc;

  @override
  void initState() {
    _taskBloc = BlocProvider.of<TaskBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _taskBloc,
      builder: (BuildContext context, TasksState state) {
        if (state is TasksLoading) {
          return Container();
        } else if (state is TasksLoaded) {
          final tasks = state.tasks;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  '${AppLocalizations.of(context).totalTasks}: ${tasks.length}',
                  semanticsLabel:
                      '${AppLocalizations.of(context).totalTasks} ${tasks.length}',
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
              Expanded(
                child: tasks.length > 0
                    ? ListView.separated(
                        itemCount: tasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          var task = tasks[index];
                          var punched = task.punchedDates?.length ?? 0;
                          return ListTile(
                            title: Text(
                              task.name,
                              overflow: TextOverflow.ellipsis,
                              semanticsLabel: task.name,
                            ),
                            subtitle: Text(
                              """${AppLocalizations.of(context).dateAdded}: ${task.dateAdded} 
${AppLocalizations.of(context).totalPunched}: $punched""",
                              semanticsLabel:
                                  '${AppLocalizations.of(context).dateAdded} ${task.dateAdded}, ${AppLocalizations.of(context).totalPunched} $punched',
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.info,
                                semanticLabel: 'more information',
                              ),
                              onPressed: () =>
                                  viewTaskDetail(context, task, _taskBloc),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 20.0,
                          );
                        },
                      )
                    : Container(),
              ),
            ],
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
}
