import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

extension ToListView<T> on Iterable<T> {
  Widget toListView() => IterableListView(
        iterable: this,
      );
}

class IterableListView<T> extends StatelessWidget {
  const IterableListView({super.key, required this.iterable});

  final Iterable<T> iterable;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: iterable.length,
      itemBuilder: ((context, index) => ListTile(
            title: Text(iterable.elementAt(index).toString()),
          )),
    );
  }
}
