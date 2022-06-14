import 'package:fasko_mobile/models/task.dart';
import 'package:fasko_mobile/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.toTask,
    this.compare,
    required this.showLists,
  }) : super(key: key);

  final Function toTask;
  final Function? compare;
  final List<String> showLists;

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = List.from(context.watch<List<Task>>());
    tasks = tasks.where((task) => showLists.contains(task.list)).toList();
    if (compare != null) {
      tasks.sort((a, b) => compare!(a, b));
    }
    tasks.sort((a, b) => a.done == b.done
        ? 0
        : a.done
            ? 1
            : -1);

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 40),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskTile(
          task: tasks[index],
          toTask: toTask,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        indent: 20,
        endIndent: 20,
      ),
    );
  }
}
