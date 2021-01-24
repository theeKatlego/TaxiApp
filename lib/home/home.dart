import 'package:flutter/material.dart';

import '../counter_bloc.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      bloc.updateCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taxi App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder(
              // Wrap our widget with a StreamBuilder
              stream: bloc.getCount, // pass our Stream getter here
              initialData: 0, // provide an initial data
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('${snapshot.data}');
                }
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Text('No Posts');
                }
              }, // access the data in our Stream here
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CounterProvider {
  int count = 0;
  void increaseCount() => count++;
}
