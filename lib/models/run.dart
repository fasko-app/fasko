import 'package:cloud_firestore/cloud_firestore.dart';

/*
 * When user doing task 
 */

class Run {
  final String task;
  final Timestamp time;
  Run({
    required this.task,
    required this.time,
  });
}
