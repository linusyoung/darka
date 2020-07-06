import 'dart:async';

import 'package:darka/locale/locales.dart';
import 'package:darka/user_setting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:darka/model/models.dart';
import 'package:darka/animations/custom_fab_animation.dart';
import 'package:darka/pages/pages.dart';
import 'package:darka/widgets/widgets.dart';
import 'package:darka/blocs/blocs.dart';
import 'package:darka/utils/utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final TabBloc _tabBloc = TabBloc();
  TaskBloc _taskBloc;

  @override
  void initState() {
    _taskBloc = BlocProvider.of<TaskBloc>(context);
    _taskBloc.add(LoadTasks());
    UserSettingHelper.getThemeMode().then((int value) {
      int _index = (value + 2) % 3;
      Provider.of<ThemeStateNotifier>(context, listen: false)
          .updateTheme(_index);
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _taskBloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _tabBloc,
        builder: (BuildContext context, AppTab activeTab) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<TabBloc>(create: (BuildContext context) => _tabBloc),
              BlocProvider<TaskBloc>(
                  create: (BuildContext context) => _taskBloc),
            ],
            child: Scaffold(
              appBar: AppBar(
                title: activeTab == AppTab.tasks
                    ? Text(
                        '${AppLocalizations.of(context).bottomNavTask}',
                        semanticsLabel:
                            '${AppLocalizations.of(context).bottomNavTask}',
                      )
                    : Text(
                        '${AppLocalizations.of(context).bottomNavSummary}',
                        semanticsLabel:
                            '${AppLocalizations.of(context).bottomNavSummary}',
                      ),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () => _viewSetting(),
                  )
                ],
              ),
              body: activeTab == AppTab.tasks
                  ? TaskPage(context)
                  : Summary(context),
              floatingActionButtonLocation: activeTab == AppTab.tasks
                  ? FloatingActionButtonLocation.centerDocked
                  : null,
              floatingActionButton: activeTab == AppTab.tasks
                  ? FloatingActionButton(
                      heroTag: 'add_task',
                      child: Icon(Icons.add),
                      onPressed: () => _addNewTask())
                  : null,
              floatingActionButtonAnimator:
                  activeTab == AppTab.tasks ? CustomFabAnimation() : null,
              bottomNavigationBar: TabSelector(
                activeTab: activeTab,
                onTabSelected: (tab) => _tabBloc.add(UpdateTab(tab)),
              ),
            ),
          );
        });
  }

  void _addNewTask() {
    _showTaskInput(context).then((String value) {
      if (value != null) {
        var task = Task(
          DarkaUtils().generateV4(),
          value,
          DarkaUtils().dateFormat(DateTime.now()),
          punchedToday: false,
        );
        _taskBloc.add(AddTask(task));
      }
    });
  }

  // TODO: change to push route by name
  void _viewSetting() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => SettingPage()),
    );
  }

  Future<String> _showTaskInput(BuildContext context) async {
    String taskName;
    var inputText = AlertDialog(
      title: Text(
        '${AppLocalizations.of(context).taskName}',
        semanticsLabel: '${AppLocalizations.of(context).taskName}',
      ),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(
            hintText: '${AppLocalizations.of(context).newTaskHintText}',
            semanticCounterText:
                '${AppLocalizations.of(context).newTaskHintText}'),
        onChanged: (text) {
          taskName = text;
        },
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            '${AppLocalizations.of(context).buttonCancel}',
            semanticsLabel: '${AppLocalizations.of(context).buttonCancel}',
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: Text(
            '${AppLocalizations.of(context).buttonConfirm}',
            semanticsLabel: '${AppLocalizations.of(context).buttonConfirm}',
          ),
          onPressed: () => Navigator.of(context).pop(taskName),
        ),
      ],
    );
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return inputText;
      },
    );
  }
}
