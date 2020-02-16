import 'package:flutter/material.dart';

import '../../global/constants.dart';

class SettingsScreen extends StatelessWidget {
  static const List<int> menuItens = [
    10,
    20,
    50,
    100,
    200,
    500,
    1000,
    1500,
    2000
  ];

  final List<DropdownMenuItem<int>> dropDownItens = menuItens
      .map(
        (int v) => DropdownMenuItem<int>(
          value: v,
          child: Text(
            v.toString(),
          ),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: spaceSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text("Quantidade de Crypto Moedas"),
                  trailing: DropdownButton(
                    value: menuItens[0],
                    items: dropDownItens,
                    onChanged: (int value) => print(value),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
