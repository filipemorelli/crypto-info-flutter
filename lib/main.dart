import 'package:crypto_info/bloc/crypto_currency_bloc.dart';
import 'package:crypto_info/global/constants.dart';
import 'package:crypto_info/global/routes.dart';
import 'package:crypto_info/global/style.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    CryptoCurrencyBloc();
  }
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoCurrency Info',
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      showSemanticsDebugger: showSemanticsDebugger,
      navigatorKey: navigatorKey,
      theme: mainThemData,
      initialRoute: "home",
      onGenerateRoute: onGeneratedRoutes,
    );
  }
}
