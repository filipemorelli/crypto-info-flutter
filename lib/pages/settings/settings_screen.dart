import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Text("Settings"),
        ),
      ),
    );
  }
}
