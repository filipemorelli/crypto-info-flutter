import 'package:flutter/material.dart';

final NAVIGATOR_KEY = GlobalKey<NavigatorState>();

enum HomePopupMenuButtonTypes { settings }

showToast({
  @required GlobalKey<ScaffoldState> scaffoldKey,
  @required String text,
}) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(text),
    duration: Duration(seconds: 3),
  ));
}
