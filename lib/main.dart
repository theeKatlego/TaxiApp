import 'package:TaxiApp/home/home.dart';
import 'package:TaxiApp/signin/signin.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';

void main() {
  SdkContext.init(IsolateOrigin.main);
  runApp(TaxiApp());
}

class TaxiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Taxi App',
        theme: ThemeData(primarySwatch: Colors.grey),
        home: MapPage());
  }
}
