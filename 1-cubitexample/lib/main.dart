import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

void main() {
  runApp(const MyApp());
}

//======================
const names = ["Foo", "Bar", "Bazz", "John", "Dave", "Ardan"];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);
  void pickRandomName() => emit(names.getRandomElement());
}

//=======================

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    cubit = NamesCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<String?>(
          stream: cubit.stream,
          builder: (context, snapshot) {
            final button = Center(
              child: ElevatedButton(
                onPressed: () => cubit.pickRandomName(),
                child: const Text("Pick a Random Name"),
              ),
            );

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return button;
              case ConnectionState.waiting:
                return button;
              case ConnectionState.active:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        snapshot.data ?? "",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      button,
                    ],
                  ),
                );
              case ConnectionState.done:
                return const SizedBox.shrink();
            }
          }),
    );
  }
}
