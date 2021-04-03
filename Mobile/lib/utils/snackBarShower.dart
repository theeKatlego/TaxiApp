import 'package:flutter/material.dart';

class SnackBarShower {
  static void showSnackBar(BuildContext context, String value) {
    FocusScope.of(context).requestFocus(new FocusNode());

    var scaffold = Scaffold.of(context);
    scaffold.removeCurrentSnackBar();

    scaffold.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.0, fontFamily: "WorkSansSemiBold"),
      ),
      duration: Duration(seconds: 3),
    ));
  }
}
