import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:testingbloc_course/bloc/bloc_actions.dart';
import 'package:testingbloc_course/bloc/person.dart';
import 'package:testingbloc_course/bloc/persons_bloc.dart';

const mockPersons1 = [
  Person(name: 'Foo 1', age: 20),
  Person(name: 'Bazz 1', age: 25),
  Person(name: 'Bar 1', age: 30),
  Person(name: 'John 1', age: 35),
  Person(name: 'Dave 1', age: 40),
];

const mockPersons2 = [
  Person(name: 'Foo 2', age: 20),
  Person(name: 'Bazz 2', age: 30),
  Person(name: 'Bar 2', age: 40),
  Person(name: 'John 2', age: 50),
  Person(name: 'Dave 2', age: 60),
];

Future<Iterable<Person>> mockGetPersons1(String _) =>
    Future.value(mockPersons1);
Future<Iterable<Person>> mockGetPersons2(String _) =>
    Future.value(mockPersons2);

void main() {
  group('Testing Bloc', () {
    // write our tests

    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test Initail State',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state, null),
    );

    // Fetch some mock data and compare it with Fetch Resulsts

    blocTest<PersonsBloc, FetchResult?>(
      'mock Retreiving persons1 from first iterable ',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const LoadPersonsAction(
            url: 'dummy_url_1', loader: mockGetPersons1));
        bloc.add(const LoadPersonsAction(
            url: 'dummy_url_1', loader: mockGetPersons1));
      },
      expect: () => [
        const FetchResult(persons: mockPersons1, isRetrievedFromCache: false),
        const FetchResult(persons: mockPersons1, isRetrievedFromCache: true)
      ],
    );

    // Fetch some mock data and compare it with Fetch Resulsts

    blocTest<PersonsBloc, FetchResult?>(
      'mockk Retreiving persons2 from first iterable ',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const LoadPersonsAction(
            url: 'dummy_url_2', loader: mockGetPersons2));
        bloc.add(const LoadPersonsAction(
            url: 'dummy_url_2', loader: mockGetPersons2));
      },
      expect: () => [
        const FetchResult(persons: mockPersons2, isRetrievedFromCache: false),
        const FetchResult(persons: mockPersons2, isRetrievedFromCache: true)
      ],
    );
  });
}
