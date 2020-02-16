import 'package:flutter/material.dart';

final ThemeData mainThemData = ThemeData(
  primarySwatch: Colors.teal,
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    elevation: 5,
  ),
  appBarTheme: AppBarTheme(
    elevation: 5,
  ),
);

final TextStyle headerStyle = TextStyle(
  fontSize: 48,
  fontWeight: FontWeight.w700,
  color: Colors.teal,
);
