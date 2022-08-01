import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blocjsonexample/bloc/bloc_actions.dart';
import 'package:blocjsonexample/bloc/persons_bloc.dart';

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
            ElevatedButton(
              onPressed: () {
                context.read<PersonsBloc>().add(
                      const LoadPersonsAction(
                        url: person1Url,
                        loader: getPersons,
                      ),
                    );
              },
              child: const Text('Load Json #1'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<PersonsBloc>().add(
                      const LoadPersonsAction(
                        url: person2Url,
                        loader: getPersons,
                      ),
                    );
              },
              child: const Text('Load Json #2'),
            ),
            BlocBuilder<PersonsBloc, FetchResult?>(
              buildWhen: (previousResult, currentResult) {
                return previousResult?.persons != currentResult?.persons;
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
