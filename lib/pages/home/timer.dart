import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fasko_mobile/models/fasko_user.dart';
import 'package:fasko_mobile/models/run.dart';
import 'package:fasko_mobile/models/task.dart';
import 'package:fasko_mobile/models/user_settings.dart';
import 'package:fasko_mobile/services/db.dart';
import 'package:fasko_mobile/utilities/timer_stage.dart';
import 'package:flutter/material.dart';
import 'package:fasko_mobile/widgets/bar.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerPage extends StatefulWidget {
  TimerPage({Key? key, required this.settings, required this.run}) : super(key: key);

  final UserSettings settings;
  final Run run;
  final AudioPlayer player = AudioPlayer();

  @override
  State<TimerPage> createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  Task? task;
  late TimerStage stage;

  late int minutesLeft;
  late int secondsLeft;
  Timer? timer;

  void _nextStage() {
    stage.nextStage();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (secondsLeft == 0) {
        if (minutesLeft == 0) {
          _nextStage();
          // play sound
          await widget.player.play(AssetSource('sound/alarm.wav'));
          //await FlutterPlatformAlert.playAlertSound(iconStyle: IconStyle.stop);
        } else {
          setState(() {
            minutesLeft--;
            secondsLeft = 60;
          });
        }
      }
      setState(() {
        secondsLeft--;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    int difference = Timestamp.now().seconds - widget.run.time.seconds - 5;

    if (difference < 0) {
      // preperation time
      setState(() {
        minutesLeft = 0;
        secondsLeft = difference < -5 ? 5 : -difference;
        stage = PreparationStage(this);
      });
    } else {
      // count = how much (work + rest) stages in difference
      int count = (difference / (widget.settings.work * 60 + widget.settings.rest * 60)).floor();
      // minus full (work + rest) stages time
      // get as first stage
      difference = difference - (count * (widget.settings.work * 60 + widget.settings.rest * 60));
      int fullMinutes; // full minutes in difference

      // compare difference
      if (difference < widget.settings.work * 60) {
        // work stage
        fullMinutes = (difference / 60).floor();
        setState(() {
          stage = WorkStage(this);
          minutesLeft = widget.settings.work - fullMinutes - 1; // -1 because is seconds
          secondsLeft = 60 - (difference - fullMinutes * 60);
        });
      } else {
        // rest stage
        difference = difference - widget.settings.work * 60;
        fullMinutes = (difference / 60).floor();
        setState(() {
          stage = RestStage(this);
          minutesLeft = widget.settings.rest - fullMinutes - 1;
          secondsLeft = 60 - (difference - fullMinutes * 60);
        });
      }
    }
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    // check is widget in the tree
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<FaskoUser?>()!;
    final db = DatabaseService(uid: user.uid);
    db.getTask(widget.run.task).then((value) {
      setState(() {
        task = value;
      });
    });

    return Scaffold(
      appBar: const FaskoAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          children: [
            Container(
              height: 240,
              margin: const EdgeInsets.only(top: 75, bottom: 50),
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: 240,
                      height: 240,
                      child: CircularProgressIndicator(
                        value: stage.percent,
                        color: const Color.fromARGB(255, 36, 176, 42),
                        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                        strokeWidth: 12,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      stage.text,
                      style:
                          const TextStyle(fontSize: 38, height: 1.3, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Text(
              task?.title ?? '',
              style: const TextStyle(fontSize: 26, height: 1.3, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30, top: 15),
              child: Text(
                task?.description ?? '',
                style: const TextStyle(fontSize: 18, height: 1.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: TextButton(
                onPressed: () async {
                  await db.updateRun(null);
                  await db.updateTaskDone(task!.id, true);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(const Size.fromHeight(60)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 246, 249)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(const Color.fromARGB(255, 193, 54, 87)),
                ),
                child: const Text(
                  'End task',
                  style: TextStyle(fontSize: 16, height: 1.3), // up text bit
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
