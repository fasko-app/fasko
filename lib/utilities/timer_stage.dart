import 'package:fasko_mobile/pages/home/timer.dart';
// State pattern for timer stages

abstract class TimerStage {
  late TimerPageState _timerPageState;

  TimerStage(TimerPageState timerPageState) {
    _timerPageState = timerPageState;
  }

  double get percent;
  String get text {
    String text = _timerPageState.minutesLeft < 10
        ? '0${_timerPageState.minutesLeft}:'
        : '${_timerPageState.minutesLeft}:';

    text += _timerPageState.secondsLeft < 10
        ? '0${_timerPageState.secondsLeft}'
        : '${_timerPageState.secondsLeft}';
    return text;
  }

  void nextStage() {
    _timerPageState.setState(() {
      _timerPageState.secondsLeft = 60;
    });
  }
}

class PreparationStage extends TimerStage {
  PreparationStage(super.timerPageState);

  @override
  double get percent {
    return 1 - _timerPageState.secondsLeft / 5;
  }

  @override
  String get text {
    return '00:0${_timerPageState.secondsLeft}';
  }

  @override
  void nextStage() {
    super.nextStage();
    _timerPageState.setState(() {
      _timerPageState.stage = WorkStage(_timerPageState);
      _timerPageState.minutesLeft = _timerPageState.widget.settings.work - 1;
    });
  }
}

class WorkStage extends TimerStage {
  WorkStage(super.timerPageState);

  @override
  double get percent {
    return 1 -
        (_timerPageState.minutesLeft * 60 + _timerPageState.secondsLeft) /
            (_timerPageState.widget.settings.work * 60);
  }

  @override
  void nextStage() {
    super.nextStage();
    _timerPageState.setState(() {
      _timerPageState.stage = RestStage(_timerPageState);
      _timerPageState.minutesLeft = _timerPageState.widget.settings.rest - 1;
    });
  }
}

class RestStage extends TimerStage {
  RestStage(super.timerPageState);

  @override
  double get percent {
    return 1 -
        (_timerPageState.minutesLeft * 60 + _timerPageState.secondsLeft) /
            (_timerPageState.widget.settings.rest * 60);
  }

  @override
  void nextStage() {
    super.nextStage();
    _timerPageState.setState(() {
      _timerPageState.stage = WorkStage(_timerPageState);
      _timerPageState.minutesLeft = _timerPageState.widget.settings.work - 1;
    });
  }
}
