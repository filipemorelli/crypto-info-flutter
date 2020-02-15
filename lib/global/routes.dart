import 'package:crypto_info/pages/404/NotFound.dart';
import 'package:crypto_info/pages/home/home_screen.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  "home": (_) => HomeScreen()
};

Route<dynamic> onGeneratedRoutes(RouteSettings settings) {
  switch (settings.name) {
    case "home":
      return MaterialPageRoute(
          builder: (_) => HomeScreen(), settings: settings);
      break;
    default:
      return MaterialPageRoute(
          builder: (_) => NotFoundScreen(), settings: settings);
  }
}
