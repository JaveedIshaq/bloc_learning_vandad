import 'package:blocjsonexample/bloc/bloc_actions.dart';
import 'package:blocjsonexample/bloc/person.dart';
import 'package:blocjsonexample/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPersons1 = [
  Person(name: 'Foo1', age: 20),
  Person(name: 'Bar1', age: 25),
  Person(name: 'Baz1', age: 30),
  Person(name: 'Dave1', age: 35),
];

const mockedPersons2 = [
  Person(name: 'Foo2', age: 22),
  Person(name: 'Bar2', age: 27),
  Person(name: 'Baz2', age: 32),
  Person(name: 'Dave2', age: 37),
];

Future<Iterable<Person>> mockedLoader1(String url) =>
    Future.value(mockedPersons1);
Future<Iterable<Person>> mockedLoader2(String url) =>
    Future.value(mockedPersons2);

void main() {
  group('Testing Bloc', () {
    // write tests here
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test Initial State',
      build: () => bloc,
      verify: (bloc) => bloc.state == null,
    );

    // fetch some mock data mockedPersons1 and compare it with FetchResult
    blocTest<PersonsBloc, FetchResult?>(
      'Mock receiving persons from first iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const LoadPersonsAction(
          url: 'dummy_url_1',
          loader: mockedLoader1,
        ));

        bloc.add(const LoadPersonsAction(
          url: 'dummy_url_1',
          loader: mockedLoader1,
        ));
      },
      expect: () => [
        const FetchResult(persons: mockedPersons1, isRetrievedFromCache: false),
        const FetchResult(persons: mockedPersons1, isRetrievedFromCache: true)
      ],
    );

    // fetch some mock data mockedPersons2 and compare it with FetchResult
    blocTest<PersonsBloc, FetchResult?>(
      'Mock receiving persons from first iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const LoadPersonsAction(
          url: 'dummy_url_2',
          loader: mockedLoader2,
        ));

        bloc.add(const LoadPersonsAction(
          url: 'dummy_url_2',
          loader: mockedLoader2,
        ));
      },
      expect: () => [
        const FetchResult(persons: mockedPersons2, isRetrievedFromCache: false),
        const FetchResult(persons: mockedPersons2, isRetrievedFromCache: true)
      ],
    );
  });
}
