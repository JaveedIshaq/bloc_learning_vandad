import 'package:flutter/foundation.dart' show immutable;
import 'package:testingbloc_course/bloc/person.dart';

const person1Url = 'http://192.168.8.100:5500/api/persons1.json';
const person2Url = 'http://192.168.8.100:5500/api/persons2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

Future<Iterable<Person>> personLoader(String url) async {
  Iterable<Person> persons = [];
  return persons;
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction extends LoadAction {
  final String url;
  final PersonsLoader loader;
  const LoadPersonsAction({required this.url, required this.loader}) : super();
}
