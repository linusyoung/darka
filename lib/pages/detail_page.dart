import 'package:darka/locale/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:darka/model/task.dart';
import 'package:darka/darka_utils.dart';
import 'package:darka/widgets/widgets.dart';

class TaskDetail extends StatelessWidget {
  final Task task;

  TaskDetail(this.task);

  @override
  Widget build(BuildContext context) {
    String addDate = task.dateAdded;
    var _titleEdit = TextEditingController.fromValue(TextEditingValue(
      text: task.name,
      selection: TextSelection.collapsed(offset: task.name.length),
    ));
    List<String> punchedDates = task.punchedDates ?? [];
    String totalPunched = punchedDates?.length.toString() ?? '0';
    List<String> last7days = [];
    List<String> last30days = [];
    List<String> last365days = [];
    for (var i = 0; i < 365; i++) {
      if (i < 7) {
        last7days.add(DarkaUtils()
            .dateFormat(DateTime.now().subtract(Duration(days: i))));
      }
      if (i < 30) {
        last30days.add(DarkaUtils()
            .dateFormat(DateTime.now().subtract(Duration(days: i))));
      }
      last365days.add(
          DarkaUtils().dateFormat(DateTime.now().subtract(Duration(days: i))));
    }
    var checked7days = punchedDates
        .map((punched) => last7days.contains(punched))
        .toList()
          ..retainWhere((p) => p == true);
    var checked30days = punchedDates
        .map((punched) => last30days.contains(punched))
        .toList()
          ..retainWhere((p) => p == true);
    var checked365days = punchedDates
        .map((punched) => last365days.contains(punched))
        .toList()
          ..retainWhere((p) => p == true);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          textAlign: TextAlign.start,
          controller: _titleEdit,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: Icon(
              Icons.edit,
            ),
          ),
          style: Theme.of(context).textTheme.display1,
          onChanged: (text) {
            task.name = text;
          },
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            semanticLabel: 'back',
          ),
          onPressed: () => Navigator.pop(context, task),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${AppLocalizations.of(context).dateAdded}: $addDate',
                    semanticsLabel:
                        '${AppLocalizations.of(context).dateAdded} $addDate',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Text(
                      '${AppLocalizations.of(context).totalPunched}: $totalPunched',
                      semanticsLabel:
                          '${AppLocalizations.of(context).totalPunched} $totalPunched',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${AppLocalizations.of(context).recentActivities}',
                          semanticsLabel:
                              '${AppLocalizations.of(context).recentActivities}',
                        ),
                        Label(color: task.labelColor)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '    7 ${AppLocalizations.of(context).days}',
                          semanticsLabel:
                              '7 ${AppLocalizations.of(context).days}',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: SizedBox(
                            width: 200.0,
                            child: LinearPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              percent: (checked7days.length / last7days.length),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '  30 ${AppLocalizations.of(context).days}',
                          semanticsLabel:
                              '30 ${AppLocalizations.of(context).days}',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: SizedBox(
                            width: 200.0,
                            child: LinearPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              percent:
                                  (checked30days.length / last30days.length),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '365 ${AppLocalizations.of(context).days}',
                          semanticsLabel:
                              '365 ${AppLocalizations.of(context).days}',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: SizedBox(
                            width: 200.0,
                            child: LinearPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              percent:
                                  (checked365days.length / last365days.length),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Calendar(
              showChevronsToChangeRange: true,
              isExpandable: true,
              dayBuilder: (BuildContext context, DateTime day) {
                String dayString = DarkaUtils().dateFormat(day);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                      color: Theme.of(context).disabledColor,
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Text(
                            day.day.toString(),
                            style: Theme.of(context).textTheme.body2,
                          ),
                          punchedDates.contains(dayString)
                              ? Container(
                                  width: 5.0,
                                  height: 5.0,
                                  decoration: ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Colors.white,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                );
              },
              showCalendarPickerIcon: false,
              showTodayAction: false,
            )
          ],
        ),
      ),
      floatingActionButton: ColorFab(),
    );
  }
}
