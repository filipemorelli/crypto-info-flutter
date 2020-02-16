import 'package:flutter/material.dart';
import 'package:crypto_info/global/constants.dart';
import 'package:crypto_info/global/style.dart';

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Not Found"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: spaceSize),
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset("assets/image/coin_not_found.png"),
              Container(
                margin: EdgeInsets.only(top: spaceSize),
                child: Text("Not Found", style: headerStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
