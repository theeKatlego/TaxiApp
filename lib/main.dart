import 'package:TaxiApp/services/AuthService.dart';
import 'package:TaxiApp/services/NamelaAuthService.dart';
import 'package:TaxiApp/style/themeData.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:provider/provider.dart';
import 'auth/auth-widget-builder.dart';
import 'auth/auth_widget.dart';
import 'models/User.dart';

void main() {
  SdkContext.init(IsolateOrigin.main);
  runApp(TaxiApp());
}

class TaxiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (_) => NamelaAuthService(),
            dispose: (_, AuthService authService) => authService.dispose()),
      ],
      child: AuthWidgetBuilder(
        builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
          return MaterialApp(
            title: 'Namela',
            theme: namelaTheme,
            home: AuthWidget(userSnapshot: userSnapshot),
          );
        },
      ),
    );
  }
}
