import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/time.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<TimeBloc>(
      create: (context) => TimeBloc(),
      child: BlocBuilder<TimeBloc, TimeState>(
        builder: ((context, state) {
          final String minuteStr = ((state.timeDuration / 60) % 60)
              .floor()
              .toString()
              .padLeft(2, '0');
          final String secondStr =
              (state.timeDuration / 60).floor().toString().padLeft(2, '0');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$minuteStr :$secondStr'),
                ...button(context, state)
              ],
            ),
          );
        }),
      ),
    ));
  }

  button(context, state) {
    final TimeBloc timeBloc = BlocProvider.of<TimeBloc>(context);

    if (state is IntialState) {
      return [
        FloatingActionButton(
            onPressed: () => timeBloc.add(StartEvent(state.timeDuration)),
            child: Icon(Icons.play_arrow))
      ];
    } else if (state is RunningState) {
      return [
        FloatingActionButton(
            onPressed: () => timeBloc.add(PauseEvent(state.timeDuration)),
            child: Icon(Icons.pause)),
        FloatingActionButton(
            onPressed: () => timeBloc.add(ResetEvent()),
            child: Icon(Icons.play_arrow)),
      ];
    } else if (state is PauseState) {
      return [
        FloatingActionButton(
            onPressed: () => timeBloc.add(ResumeEvent()),
            child: Icon(Icons.pause)),
        FloatingActionButton(
            onPressed: () => timeBloc.add(ResetEvent()),
            child: Icon(Icons.play_arrow)),
      ];
    } else if (state is CompleteState) {
      return [
        FloatingActionButton(
            onPressed: () => timeBloc.add(ResumeEvent()),
            child: Icon(Icons.pause)),
        FloatingActionButton(
            onPressed: () => timeBloc.add(ResetEvent()),
            child: Icon(Icons.play_arrow)),
      ];
    }

    return [];
  }
}
