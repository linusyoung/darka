import 'package:darka/model/models.dart';
import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final GestureTapCallback viewDetail;
  final DismissDirectionCallback onDismissed;
  final Function punchToday;
  final Task task;

  TaskItem({
    @required this.task,
    @required this.viewDetail,
    @required this.punchToday,
    @required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    var taskName = Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 4.0,
                top: 8.0,
              ),
              child: Text(
                task.name,
                style: Theme.of(context).textTheme.title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
    return Dismissible(
      key: Key(task.name ?? 'null'),
      onDismissed: onDismissed,
      child: Column(
        children: <Widget>[
          taskName,
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _constructCalendar(context),
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
              style: Theme.of(context).textTheme.subtitle,
            ),
            isPunchedToday
                ? Center(
                    child: Container(
                      width: 6.0,
                      height: 6.0,
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      shape: CircleBorder(),
      // color: Theme.of(context).accentColor,
      disabledElevation: 0.0,
      disabledTextColor: Colors.white,
      elevation: 4.0,
      onPressed: isPunchedToday ? null : punchToday,
    );
    var punchDay = ButtonTheme(
      minWidth: 50.0,
      height: 50.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 1.0),
        child: punchButton,
      ),
    );
    var viewDetailButton = GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
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

    for (var i = 0; i < daysToShow; i++) {
      int showDay = calendarDays['startDay'] + i;
      showDay = showDay > calendarDays['lastDayOfLastMonth']
          ? showDay - calendarDays['lastDayOfLastMonth']
          : showDay;
      bool isPunched = task.recentPunched[i + 8 - daysToShow];

      var historyDay = Padding(
        padding: const EdgeInsets.all(2.5),
        child: Container(
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
                    ? Container(
                        width: 6.0,
                        height: 6.0,
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: Colors.white,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          width: 32.0,
          height: 32.0,
        ),
      );
      cal.add(historyDay);
    }

    cal.add(punchDay);
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