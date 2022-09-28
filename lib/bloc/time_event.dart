import "package:equatable/equatable.dart";

class TimeEvent extends Equatable {
  const TimeEvent();

  @override
  List<Object> get props => [];
}

class StartEvent extends TimeEvent {
  final int timeDuration;
  StartEvent(this.timeDuration);
}

class RunEvent extends TimeEvent {
  final int timeDuration;
  RunEvent(this.timeDuration);
}

class PauseEvent extends TimeEvent {
  final int timeDuration;
  final int time = 9;
  PauseEvent(this.timeDuration);
}

class ResumeEvent extends TimeEvent {}

class ResetEvent extends TimeEvent {}
