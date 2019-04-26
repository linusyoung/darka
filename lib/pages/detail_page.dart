import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

import 'package:darka/model/task.dart';
import 'package:darka/darka_utils.dart';

class TaskDetail extends StatelessWidget {
  final Task task;

  TaskDetail(this.task);

  @override
  Widget build(BuildContext context) {
    String addDate = DarkaUtils().dateFormat(DateTime.now());
    var _titleEdit = TextEditingController.fromValue(TextEditingValue(
      text: task.name,
      selection: TextSelection.collapsed(offset: task.name.length),
    ));
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
          icon: Icon(Icons.arrow_back),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Data added: $addDate'),
                  Text('Summary: Total done'),
                ],
              ),
            ),
            // TODO: format summary
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Last Week: 10'),
                  Text('Last Month: 20'),
                  Text('Last 12 monthes: 30'),
                ],
              ),
            ),
            Calendar(
              showChevronsToChangeRange: true,
              isExpandable: true,
              dayBuilder: (BuildContext context, DateTime day) {
                //TODO: replace with punched version
                return InkWell(
                  onTap: () => print('$day'),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Text(day.day.toString()),
                  ),
                );
              },
              showCalendarPickerIcon: false,
              showTodayAction: false,
            )
          ],
        ),
      ),
    );
  }
}
