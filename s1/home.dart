import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

const names = ['foo', 'bar', 'baz', 'sadas', 'haha', 'ẻt', 'yui'];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() => emit(names.getRandomElement());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final NamesCubit cubit = NamesCubit();

  @override
  void initstate() {
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home"), centerTitle: true),
        body: StreamBuilder<String?>(
          stream: cubit.stream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            // ignore: prefer_function_declarations_over_variables
            final button = (title) => TextButton(
                  onPressed: () => cubit.pickRandomName(),
                  child: Text("pick random name $title"),
                );

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return button("none");
              case ConnectionState.waiting:
                return button("waiting");
              case ConnectionState.active:
                return Column(
                  children: [Text(snapshot.data ?? ""), button("active")],
                );
              case ConnectionState.done:
                return const Text("done");
              default:
                return const SizedBox();
            }
          },
        ));
  }
}
