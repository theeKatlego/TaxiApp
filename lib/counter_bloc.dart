import 'dart:async';

import 'counter_provider.dart';
// import 'package:rxdart/rxdart.dart'; if you want to make use of PublishSubject, ReplaySubject or BehaviourSubject.
// make sure you have rxdart: as a dependency in your pubspec.yaml file to use the above import


class CounterBloc {
  final counterProvider = CounterProvider();  // create a StreamController or
  final counterController = StreamController();  // create a StreamController or
  // final counterController = PublishSubject() or any other rxdart option;
  Stream get getCount => counterController.stream; // create a getter for our Stream
  // the rxdart stream controllers returns an Observable instead of a Stream
  
  Future<void> updateCount() async {
    counterController.sink.add(null);
    await Future.delayed(Duration(seconds: 1));
    counterProvider.increaseCount();
    counterController.sink.add(counterProvider.count); // add whatever data we want into the Sink
  }
  
  void dispose() {
    counterController.close(); // close our StreamController to avoid memory leak
  }
}

final bloc = CounterBloc(); // create an instance of the counter bloc