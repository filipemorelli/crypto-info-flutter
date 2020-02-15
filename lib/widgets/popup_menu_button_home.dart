import 'package:crypto_info/global/functions.dart';
import 'package:flutter/material.dart';

class PopupMenuButtonHome extends StatelessWidget {
  const PopupMenuButtonHome({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      onSelected: (HomePopupMenuButtonTypes option) {
        switch (option) {
          case HomePopupMenuButtonTypes.settings:
            print("Oii");
            break;
          default:
        }
      },
      itemBuilder: (BuildContext ctx) {
        return [
          PopupMenuItem(
            value: HomePopupMenuButtonTypes.settings,
            child: Text("Configurações"),
          )
        ];
      },
    );
  }
}
