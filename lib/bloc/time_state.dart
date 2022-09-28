import "package:equatable/equatable.dart";

class TimeState extends Equatable {
  final int timeDuration;
  TimeState(this.timeDuration);
  @override
  List<Object?> get props => [];
}

class IntialState extends TimeState {
  final int timeDuration;
  IntialState(this.timeDuration) : super(timeDuration);
}

class RunningState extends TimeState {
  final int timeDuration;
  RunningState(this.timeDuration) : super(timeDuration);
}

class PauseState extends TimeState {
  final int timeDuration;
  final int tia = 9;
  PauseState(this.timeDuration) : super(timeDuration);
}

class CompleteState extends TimeState {
  final int timeDuration;
  CompleteState(this.timeDuration) : super(0);
}
