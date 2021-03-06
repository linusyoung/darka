import 'package:darka/model/models.dart';
import 'package:darka/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:darka/user_setting.dart';

class TaskItem extends StatelessWidget {
  final GestureTapCallback viewDetail;
  final DismissDirectionCallback onDismissed;
  final Function punchToday;
  final Task task;
  final bool leftHandMode;

  TaskItem({
    @required this.task,
    @required this.viewDetail,
    @required this.punchToday,
    @required this.onDismissed,
    this.leftHandMode = false,
  });

  @override
  Widget build(BuildContext context) {
    bool _isLabelled = false;
    if (task.labelColor != null) {
      _isLabelled = true;
    }

    var taskName = Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 8.0, 0),
                child: Text(
                  task.name,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            _isLabelled
                ? Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Label(color: task.labelColor))
                : Container(),
          ],
        ),
      ),
    );
    return Dismissible(
      key: Key(task.name ?? 'null'),
      onDismissed: onDismissed,
      child: Column(
        children: <Widget>[
          taskName,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _constructCalendar(context),
              ),
              onTap: viewDetail,
            ),
          ),
          Divider(
            height: 8.0,
          ),
        ],
      ),
    );
  }

  List<Widget> _constructCalendar(BuildContext context) {
    final daysToShow = MediaQuery.of(context).size.width <= 360 ? 7 : 8;
    bool isPunchedToday = task.punchedToday;
    List<Widget> cal = [];
    final calendarDays = getCalendarDays(daysToShow);
    var punchButton = RaisedButton(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              calendarDays['dayOfToday'].toString(),
              style: isPunchedToday
                  ? TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    )
                  : Theme.of(context).textTheme.subtitle2,
            ),
            isPunchedToday
                ? FutureBuilder<List<dynamic>>(
                    future: Future.wait([
                      UserSettingHelper.getHoleShape(),
                      UserSettingHelper.getHoleSize()
                    ]),
                    initialData: [1, 5.0],
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      return snapshot.hasData
                          ? PunchHole(
                              shapeIndex: snapshot.data[0],
                              holeSize: snapshot.data[1],
                            )
                          : PunchHole();
                    },
                  )
                : Container(),
          ],
        ),
      ),
      shape: CircleBorder(),
      disabledElevation: 0.0,
      elevation: 5.0,
      onPressed: isPunchedToday ? null : punchToday,
    );
    var punchDay = ButtonTheme(
      disabledColor: Theme.of(context).disabledColor,
      minWidth: 50.0,
      height: 50.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 1.0),
        child: isPunchedToday
            ? GestureDetector(
                child: punchButton,
                onTap: viewDetail,
              )
            : punchButton,
      ),
    );
    var viewDetailButton = GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 4.0, 0.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.keyboard_arrow_right,
            color: Theme.of(context).buttonColor,
          ),
        ),
      ),
      onTap: viewDetail,
    );
    if (leftHandMode) {
      cal.add(punchDay);
    }
    for (var i = 0; i < daysToShow; i++) {
      int showDay = calendarDays['startDay'] + i;
      showDay = showDay > calendarDays['lastDayOfLastMonth']
          ? showDay - calendarDays['lastDayOfLastMonth']
          : showDay;
      bool isPunched = task.recentPunched[i + 8 - daysToShow];

      var historyDay = Padding(
        padding: const EdgeInsets.all(3.5),
        child: Container(
          alignment: Alignment.center,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Text(
                  showDay.toString(),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                isPunched
                    ? FutureBuilder<List<dynamic>>(
                        future: Future.wait([
                          UserSettingHelper.getHoleShape(),
                          UserSettingHelper.getHoleSize(),
                        ]),
                        initialData: [1, 5.0],
                        builder: (BuildContext context,
                            AsyncSnapshot<List<dynamic>> snapshot) {
                          return snapshot.hasData
                              ? PunchHole(
                                  shapeIndex: snapshot.data[0],
                                  holeSize: snapshot.data[1],
                                )
                              : PunchHole();
                        },
                      )
                    : Container(),
              ],
            ),
          ),
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: Theme.of(context).disabledColor,
          ),
          width: 32.0,
          height: 32.0,
        ),
      );
      if (leftHandMode) {
        cal.insert(1, historyDay);
      } else {
        cal.add(historyDay);
      }
    }
    if (!leftHandMode) {
      cal.add(punchDay);
    }
    cal.add(viewDetailButton);
    return cal;
  }

  Map getCalendarDays(int daysToShow) {
    Map calendarDays = Map();
    int dayOfToday = DateTime.now().day;
    DateTime today = DateTime.now();
    int lastDayOfLastMonth = DateTime(today.year, today.month, 0).day;
    int startDay = dayOfToday - daysToShow;
    startDay = startDay >= 1 ? startDay : startDay + lastDayOfLastMonth;
    calendarDays['dayOfToday'] = dayOfToday;
    calendarDays['startDay'] = startDay;
    calendarDays['lastDayOfLastMonth'] = lastDayOfLastMonth;
    return calendarDays;
  }
}
