import 'package:crypto_info/global/enum.dart';
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
            Navigator.pushNamed(context, "settings");
            break;
          case HomePopupMenuButtonTypes.notFound:
            Navigator.pushNamed(context, "notFound");
            break;
          default:
        }
      },
      itemBuilder: (BuildContext ctx) {
        return [
          PopupMenuItem(
            value: HomePopupMenuButtonTypes.settings,
            child: Text("Configurações"),
          ),
          PopupMenuItem(
            value: HomePopupMenuButtonTypes.notFound,
            child: Text("Não Encontrado"),
          )
        ];
      },
    );
  }
}
