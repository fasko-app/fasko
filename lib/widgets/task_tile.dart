import 'package:fasko_mobile/models/fasko_user.dart';
import 'package:fasko_mobile/models/task.dart';
import 'package:fasko_mobile/services/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({Key? key, required this.task, required this.toTask}) : super(key: key);

  final Function toTask;

  final Task task;
  static Set<String> monthes = {
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  };

  @override
  Widget build(BuildContext context) {
    final DateTime? date = task.date?.toDate();
    final user = context.watch<FaskoUser?>()!;
    final db = DatabaseService(uid: user.uid);

    return Dismissible(
      key: ValueKey<String>(task.id),
      background: task.done
          ? Container(
              // uncheck
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 30),
              color: Colors.grey[400],
              child: const Icon(Icons.unpublished, color: Colors.white),
            )
          : Container(
              // run
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 30),
              color: Colors.green[200],
              child: const Icon(Icons.access_alarm, color: Colors.white),
            ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        color: Colors.red[200],
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        minLeadingWidth: 8,
        title: Text(task.title,
            style: task.done ? const TextStyle(decoration: TextDecoration.lineThrough) : null),
        subtitle: Text(task.list),
        trailing: date != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${date.day} ${monthes.elementAt(date.month - 1)}'),
                  Text('${date.year == DateTime.now().year ? '' : date.year}'),
                ],
              )
            : null,
        leading: Text(
          task.level,
          textAlign: TextAlign.end,
          style: TextStyle(
              color: task.done ? Task.levelGrayscale[task.level] : Task.levelColor[task.level],
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        onTap: () {
          toTask(task);
        },
      ),
      onDismissed: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          // delete item
          await db.deleteTask(task.id);
        } else if (direction == DismissDirection.startToEnd) {
          // start timer
          await db.updateRun(task.id);
        }
      },
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.startToEnd && task.done) {
          // uncheck without dismiss
          await db.updateTaskDone(task.id, false);
          return false;
        }
        return true;
      },
    );
  }
}
