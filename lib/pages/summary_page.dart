import 'package:admob_flutter/admob_flutter.dart';
import 'package:darka/admob_utils.dart';
import 'package:darka/blocs/blocs.dart';
import 'package:darka/locale/locales.dart';
import 'package:darka/pages/pages_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Summary extends StatefulWidget {
  final BuildContext context;

  Summary(this.context);

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    TaskBloc _taskBloc = BlocProvider.of<TaskBloc>(context);
    return BlocBuilder(
      bloc: _taskBloc,
      builder: (BuildContext context, TasksState state) {
        if (state is TasksLoading) {
          return CircularProgressIndicator();
        } else if (state is TasksLoaded) {
          final tasks = state.tasks;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 0.0),
                    child: AdmobBanner(
                      adUnitId: BannerAdUnitId,
                      adSize: AdmobBannerSize.BANNER,
                    ),
                  ),
                ],
              ),
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
                          Widget taskItem = ListTile(
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
                            trailing: Icon(
                              Icons.info,
                              color: Theme.of(context).primaryColor,
                              semanticLabel: 'more information',
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                          );

                          return GestureDetector(
                            child: taskItem,
                            onTap: () =>
                                viewTaskDetail(context, task, _taskBloc),
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
