import 'package:audioplayers/audio_cache.dart';
import 'package:darka/blocs/blocs.dart';
import 'package:darka/model/models.dart';
import 'package:darka/pages/detail_page.dart';
import 'package:darka/pages/pages.dart';
import 'package:flutter/material.dart';

const holePunchAudioPath = 'sound/hole_punch.mp3';

void viewTaskDetail(BuildContext context, Task task, TaskBloc taskBloc) {
  Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) => TaskDetail(task)));
  taskBloc.add(LoadTasks());
}

void punchTask(Task task, TaskBloc taskBloc) {
  AudioCache player = AudioCache();
  if (!task.punchedToday) {
    taskBloc.add(UpdateTask(task.copyWith(punchedToday: !task.punchedToday)));
    player.play(holePunchAudioPath);
    taskBloc.add(LoadTasks());
  }
}
