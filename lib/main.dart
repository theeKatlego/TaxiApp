import 'package:TaxiApp/home/home.dart';
import 'package:TaxiApp/routes.dart';
import 'package:TaxiApp/style/themeData.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'account/signin-or-signup.dart';

final routes = <String, WidgetBuilder>{
  Routes.signinOrSignup: (BuildContext context) => SigninOrSignup(),
  Routes.home: (BuildContext context) => HomeDrawer(),
};

void main() {
  SdkContext.init(IsolateOrigin.main);
  runApp(TaxiApp());
}

class TaxiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Taxi App',
        theme: namelaTheme,
        initialRoute: Routes.signinOrSignup,
        routes: {
          Routes.signinOrSignup: (BuildContext context) => SigninOrSignup(),
          Routes.home: (BuildContext context) => HomeDrawer(),
        });
  }
}
