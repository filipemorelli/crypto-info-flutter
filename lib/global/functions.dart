import 'package:flutter/material.dart';

showToast({
  @required GlobalKey<ScaffoldState> scaffoldKey,
  @required String text,
}) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(text),
    duration: Duration(seconds: 5),
  ));
}
