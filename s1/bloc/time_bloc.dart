import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'time.dart';

class TimeBloc extends Bloc<TimeEvent, TimeState> {
  TimeBloc() : super(IntialState(_timeDuration));
  static const int _timeDuration = 60;
  late StreamSubscription<int> _timeSubscription;

  @override
  Stream<TimeState> mapEventToState(TimeEvent event) async* {
    if (event is StartEvent) {
      yield RunningState(event.timeDuration);
      _timeSubscription.cancel();
      _timeSubscription = changeTime(event.timeDuration).listen((timeDuration) {
        return add(RunEvent(event.timeDuration));
      });
    } else if (event is RunEvent) {
      yield event.timeDuration > 0
          ? RunningState(event.timeDuration)
          : CompleteState(event.timeDuration);
    } else if (event is PauseEvent) {
      _timeSubscription.pause();
      yield PauseState(state.timeDuration);
    } else if (event is ResumeEvent) {
      _timeSubscription.resume();
      yield RunningState(state.timeDuration);
    } else if (event is ResetEvent) {
      yield IntialState(_timeDuration);
    }
  }

  Stream<int> changeTime(int time) {
    return Stream.periodic(Duration(seconds: 1), (x) => time - x - 1)
        .take(time);
  }
}
