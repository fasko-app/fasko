import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final Timestamp? date;
  final String level;
  final String list;
  final bool done;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    required this.level,
    required this.list,
    required this.done,
  });

  static Map<String, Color> levelColor = {
    'A': const Color.fromARGB(255, 238, 17, 17),
    'B': const Color.fromARGB(255, 255, 157, 10),
    'C': const Color.fromARGB(255, 255, 233, 35),
  };

  static Map<String, Color> levelGrayscale = {
    'A': const Color.fromARGB(255, 125, 125, 125),
    'B': const Color.fromARGB(255, 150, 150, 150),
    'C': const Color.fromARGB(255, 175, 175, 175),
  };

  static int compareByLevel(Task a, Task b) {
    int res = a.level.compareTo(b.level);
    // check can be compared by date
    if (res == 0 && (a.date != null || b.date != null)) {
      return compareByDate(a, b);
    }
    // more understandable
    // if (res == 0 && !(a.date == null && b.date == null)) {
    //   return compareByDate(a, b);
    // }
    return res;
  }

  static int compareByDate(Task a, Task b) {
    if (a.date == null && b.date == null) {
      return compareByLevel(a, b);
    }
    if (a.date == null) {
      return 1;
    }
    if (b.date == null) {
      return -1;
    }
    return a.date!.compareTo(b.date!);
  }
}
