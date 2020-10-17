import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static void notify(
      {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required String message}) {
    final snackBar = SnackBar(
      content: Text(message,
          style: TextStyle(
              fontFamily: 'Klavika',
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5)),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
