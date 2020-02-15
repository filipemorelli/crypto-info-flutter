import 'package:crypto_info/global/functions.dart';
import 'package:crypto_info/pages/home/home_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      navigatorKey: NAVIGATOR_KEY,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          elevation: 5,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
