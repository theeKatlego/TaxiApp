import 'package:TaxiApp/style/themeData.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'account/signin-or-signup.dart';

void main() {
  SdkContext.init(IsolateOrigin.main);
  runApp(TaxiApp());
}

class TaxiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Taxi App', theme: namelaTheme, home: SigninOrSignup());
  }
}
