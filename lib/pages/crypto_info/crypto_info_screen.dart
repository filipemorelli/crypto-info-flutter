import 'package:crypto_info/bloc/crypto_currency_bloc.dart';
import 'package:crypto_info/global/constants.dart';
import 'package:crypto_info/global/style.dart';
import 'package:flutter/material.dart';

class CryptoInfoScreen extends StatefulWidget {
  final CryptoCurrency cryptoCurrency;

  CryptoInfoScreen({@required this.cryptoCurrency});

  @override
  _CryptoInfoScreenState createState() => _CryptoInfoScreenState();
}

class _CryptoInfoScreenState extends State<CryptoInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cryptoCurrency.name),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(top: spaceSize),
          children: <Widget>[
            Center(
              child: Text(
                widget.cryptoCurrency.rank,
                style: headerStyle,
              ),
            ),
            ListTile(
              title: Text("Simbolo: " + widget.cryptoCurrency.symbol),
            ),
            ListTile(
              title:
                  Text("Preço: " + widget.cryptoCurrency.priceUsd.toString()),
            ),
            ListTile(
              title: Text(
                  "Qtde Atual: " + widget.cryptoCurrency.supply.toString()),
            ),
            ListTile(
              title:
                  Text("Máximo: " + widget.cryptoCurrency.maxSupply.toString()),
            ),
            ListTile(
              title: Text("Preço vs Qtde: " +
                  widget.cryptoCurrency.marketCapUsd.toString()),
            ),
            ListTile(
              title: Text("Vol. USD 24h: " +
                  widget.cryptoCurrency.volumeUsd24Hr.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
