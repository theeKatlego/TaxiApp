import 'package:TaxiApp/signin/signin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(TaxiApp());
}

class TaxiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi App',
      theme: ThemeData.light(),
      home: Login()
    );
  }
}