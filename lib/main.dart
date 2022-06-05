import 'dart:convert';
import 'dart:developer' as devtools show log;
import 'dart:io';
import 'dart:math' as math show Random;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => PersonsBloc(),
        child: const MyHomePage(),
      ),
    );
  }
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction extends LoadAction {
  final PersonUrl url;
  const LoadPersonsAction({required this.url}) : super();
}

enum PersonUrl {
  person1,
  person2,
}

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.person1:
        return 'http://192.168.8.100:5500/api/persons1.json';
      case PersonUrl.person2:
        return 'http://192.168.8.100:5500/api/persons2.json';
    }
  }
}

@immutable
class Person {
  final String? name;
  final int? age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  @override
  String toString() => 'Person(name: $name, age: $age)';
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() =>
      'FetchResult(persons: $persons, isRetrievedFromCache: $isRetrievedFromCache)';
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  Map<PersonUrl, Iterable<Person>> _cache = {};

  PersonsBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;

      if (_cache.containsKey(url)) {
        final cachedPersons = _cache[url]!;

        final result =
            FetchResult(persons: cachedPersons, isRetrievedFromCache: true);

        emit(result);
      } else {
        final persons = await getPersons(url.urlString);

        _cache[url] = persons;

        final result =
            FetchResult(persons: persons, isRetrievedFromCache: false);
        emit(result);
      }
    });
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                context
                    .read<PersonsBloc>()
                    .add(const LoadPersonsAction(url: PersonUrl.person1));
              },
              child: const Text('Load Json #1'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<PersonsBloc>()
                    .add(const LoadPersonsAction(url: PersonUrl.person2));
              },
              child: const Text('Load Json #2'),
            ),
            BlocBuilder<PersonsBloc, FetchResult?>(
              buildWhen: (previosResult, currentResult) {
                return previosResult?.persons != currentResult?.persons;
              },
              builder: (context, fetchResult) {
                fetchResult?.log();
                final persons = fetchResult?.persons;
                if (persons == null) {
                  return const SizedBox.shrink();
                }
                return SizedBox(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: persons.length,
                      itemBuilder: (context, index) {
                        final person = persons[index];
                        return ListTile(
                          title: Text('Name: ${person?.name}'),
                          subtitle: Text('Age: ${person?.age}'),
                        );
                      }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
