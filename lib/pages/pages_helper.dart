import 'package:darka/blocs/blocs.dart';
import 'package:darka/model/models.dart';
import 'package:darka/pages/detail_page.dart';
import 'package:flutter/material.dart';

void viewTaskDetail(BuildContext context, Task task, TaskBloc taskBloc) {
  Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) => TaskDetail(task)));
  taskBloc.add(LoadTasks());
}
