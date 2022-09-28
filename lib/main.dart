import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home.dart';

import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final PersonUrl url;

  const LoadPersonAction({required this.url}) : super();
}

enum PersonUrl { person1, person2 }

@immutable
class Person {
  final String name;
  final int age;
  const Person({required this.age, required this.name});

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;
}

Future<Iterable<Person>> getPerson(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  FetchResult({required this.persons, required this.isRetrievedFromCache});

  @override
  String toString() =>
      'FetchResult (isRetrievedFromCache = $isRetrievedFromCache, persons=$persons)';
}

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cache = {};
  PersonBloc() : super(null) {
    on<LoadPersonAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        final cachedPerson = _cache[url]!;
        final result =
            FetchResult(persons: cachedPerson, isRetrievedFromCache: true);
        emit(result);
      } else {
        final persons = await getPerson(url.urlString);
        _cache[url] = persons;
        final result =
            FetchResult(persons: persons, isRetrievedFromCache: false);
        emit(result);
      }
    });
  }
}

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.person1:
        return 'http://127.0.0.1:5500/api/person1.json';

      case PersonUrl.person2:
        return 'http://127.0.0.1:5500/api/person2.json';
    }
  }
}

extension Subscipt<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => PersonBloc(),
        child: HomeOne(),
      ),
    );
  }
}

class HomeOne extends StatelessWidget {
  const HomeOne({super.key});

  @override
  Widget build(BuildContext context) {
    late final Bloc myBloc;
    return Scaffold(
      appBar: AppBar(title: const Text('home')),
      body: Column(children: [
        Row(
          children: [
            TextButton(
                onPressed: () {
                  context
                      .read<PersonBloc>()
                      .add(const LoadPersonAction(url: PersonUrl.person1));
                },
                child: const Text('Load json 1')),
            TextButton(
                onPressed: () {
                  context
                      .read<PersonBloc>()
                      .add(const LoadPersonAction(url: PersonUrl.person2));
                },
                child: const Text('Load json 2')),
          ],
        ),
        BlocBuilder<PersonBloc, FetchResult?>(
            buildWhen: ((previousResult, currentResult) {
          return previousResult?.persons != currentResult?.persons;
        }), builder: (context, fetchResult) {
          final persons = fetchResult?.persons;
          if (persons == null) {
            return const SizedBox();
          }
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: persons.length,
              itemBuilder: (context, index) {
                final person = persons[index];
                return ListTile(
                  title: Text(person!.name),
                );
              });
        })
      ]),
    );
  }
}
