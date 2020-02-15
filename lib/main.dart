import 'package:crypto_info/global/constants.dart';
import 'package:crypto_info/global/style.dart';
import 'package:crypto_info/pages/home/home_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      showSemanticsDebugger: showSemanticsDebugger,
      navigatorKey: navigatorKey,
      theme: mainThemData,
      home: HomeScreen(),
    );
  }
}
