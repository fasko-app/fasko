import 'package:fasko_mobile/models/task.dart';
import 'package:fasko_mobile/models/user_data.dart';
import 'package:fasko_mobile/pages/home/task.dart';
import 'package:fasko_mobile/pages/home/timer.dart';
import 'package:flutter/material.dart';
import 'package:fasko_mobile/pages/home/home.dart';
import 'package:fasko_mobile/pages/home/settings.dart';
import 'package:provider/provider.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  String page = 'home';
  Task? task;

  void toggleView(String path) {
    setState(() {
      page = path;
    });
  }

  void toTask(Task? editTask) {
    setState(() {
      page = 'task';
      task = editTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserData>();

    if (userData.run != null) {
      return TimerPage(settings: userData.settings, run: userData.run!);
    }

    return page == 'settings'
        ? SettingsPage(toggleView: toggleView)
        : page == 'task'
            ? TaskPage(toggleView: toggleView, task: task)
            : HomePage(toggleView: toggleView, toTask: toTask);
  }
}
