import 'package:crypto_info/pages/404/NotFound.dart';
import 'package:crypto_info/pages/crypto_info/crypto_info_screen.dart';
import 'package:crypto_info/pages/home/home_screen.dart';
import 'package:crypto_info/pages/settings/settings_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGeneratedRoutes(RouteSettings settings) {
  switch (settings.name) {
    case "home":
      return MaterialPageRoute(
          builder: (_) => HomeScreen(), settings: settings);
      break;
    case "settings":
      return MaterialPageRoute(
          builder: (_) => SettingsScreen(), settings: settings);
      break;
    case "crypto-info":
      return MaterialPageRoute(
          builder: (_) => CryptoInfoScreen(cryptoCurrency: settings.arguments),
          settings: settings);
      break;
    default:
      return MaterialPageRoute(
          builder: (_) => NotFoundScreen(), settings: settings);
  }
}
