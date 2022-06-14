import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fasko_mobile/models/run.dart';
import 'package:fasko_mobile/models/user_settings.dart';
import 'package:fasko_mobile/models/task.dart';
import 'dart:async';

import 'package:fasko_mobile/models/user_data.dart';

// Service to comunicate with db

class DatabaseService {
  DatabaseService({required this.uid})
      : user = FirebaseFirestore.instance.collection('users').doc(uid);
  final String uid;

  // final CollectionReference userCollection =
  //  FirebaseFirestore.instance.collection('users');

  final DocumentReference user;

  Future updateUserData({int work = 30, int rest = 5}) async {
    return await user.set({
      'run': null,
      'lists': [],
      'settings': {
        'work': work, // work time in minutes
        'rest': rest, // work time in minutes
      }
    });
  }

  // update run
  Future<void> updateRun(String? taskId) async {
    return await user.update({
      'run': taskId != null
          ? {
              'task': taskId,
              'time': Timestamp.now(), // start time
            }
          : null
    });
  }

  // update settings
  Future<void> updateSettings(int work, int rest) async {
    return await user.update({
      'settings': {'work': work, 'rest': rest}
    });
  }

  // operations with lists
  Future updateLists(List<String> lists) async {
    return await user.update({'lists': lists});
  }

  // lists has already deleted list
  Future deleteList(List<String> lists, String list) async {
    // delete from user data
    await user.update({'lists': lists});
    // delete all tasks from this list
    return await user.collection('tasks').where('list', isEqualTo: list).get().then((query) {
      for (var doc in query.docs) {
        doc.reference.delete();
      }
    });
  }

  // operations with tasks
  Future addTask(String title, String description, String level, String list, bool done,
      Timestamp? date) async {
    return await user.collection('tasks').add({
      'title': title,
      'description': description,
      'level': level,
      'list': list,
      'done': done,
      'date': date
    });
  }

  Future updateTask(String id, String title, String description, String level, String list,
      bool done, Timestamp? date) async {
    return await user.collection('tasks').doc(id).update({
      'title': title,
      'description': description,
      'level': level,
      'list': list,
      'done': done,
      'date': date
    });
  }

  Future deleteTask(String id) async {
    return await user.collection('tasks').doc(id).delete();
  }

  Future updateTaskDone(String id, bool done) async {
    return await user.collection('tasks').doc(id).update({'done': done});
  }

  // make task from doc
  Task _taskFromSnapshot(DocumentSnapshot snapshot) {
    return Task(
        id: snapshot.id,
        title: snapshot['title'],
        description: snapshot['description'],
        level: snapshot['level'],
        list: snapshot['list'],
        done: snapshot['done'],
        date: snapshot['date']);
  }

  // make tasks list from collection
  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    List<Task> list = snapshot.docs.map(_taskFromSnapshot).toList();
    // moved to outside
    //list.sort(((a, b) {
    //   return a.done == b.done
    //       ? 0
    //       : a.done == true
    //           ? 1
    //           : -1;
    // }));
    return list;
  }

  Stream<List<Task>> get tasks {
    return user.collection('tasks').snapshots().map(_taskListFromSnapshot);
  }

  Future<Task> getTask(String id) async {
    return await user.collection('tasks').doc(id).get().then((value) => _taskFromSnapshot(value));
    //return _taskFromSnapshot(await user.collection('tasks').doc(id).get());
  }

  // work with user data
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      lists: List<String>.from(snapshot['lists']),
      run: snapshot['run'] != null
          ? Run(
              task: snapshot['run']['task'],
              time: snapshot['run']['time'],
            )
          : null,
      settings: UserSettings(
        work: snapshot['settings']['work'],
        rest: snapshot['settings']['rest'],
      ),
    );
  }

  Stream<UserData> get userData {
    return user.snapshots().map(_userDataFromSnapshot);
  }

  // work with run may be not nessasery beacause use user for it
  Run _runFromSnapshot(DocumentSnapshot snapshot) {
    return Run(
      task: snapshot['run']['task'],
      time: snapshot['run']['time'],
    );
  }

  Stream<Run> get run {
    return user.snapshots().map(_runFromSnapshot);
  }
}
