import 'package:crypto_info/bloc/crypto_currency_bloc.dart';
import 'package:crypto_info/classes/crypto_currency.dart';
import 'package:crypto_info/classes/crypto_currency_candle.dart';
import 'package:crypto_info/global/constants.dart';
import 'package:crypto_info/global/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';

class CryptoInfoScreen extends StatefulWidget {
  final CryptoCurrency cryptoCurrency;

  CryptoInfoScreen({@required this.cryptoCurrency});

  @override
  _CryptoInfoScreenState createState() => _CryptoInfoScreenState();
}

class _CryptoInfoScreenState extends State<CryptoInfoScreen> {
  @override
  void initState() {
    super.initState();
    CryptoCurrencyBloc.instance.loadCryptoCurrencyCandle(widget.cryptoCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cryptoCurrency.id),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(top: spaceSize),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(spaceSize),
              child: StreamBuilder<List<CryptoCurrencyCandle>>(
                  stream:
                      CryptoCurrencyBloc.instance.cryptoCurrencyCandleStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.isNotEmpty) {
                      return OHLCVGraph(
                        data: snapshot.data
                            .map((CryptoCurrencyCandle c) => c.toJson())
                            .toList(),
                        enableGridLines: false,
                        volumeProp: 0.2,
                      );
                    } else if (snapshot.hasData && snapshot.data.isEmpty) {
                      return Center(
                        child: Text(
                          "Não possui informações.",
                          style: header2Style,
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
            ListTile(
              title: Text("Simbolo: " + widget.cryptoCurrency.symbol),
            ),
            ListTile(
              title:
                  Text("Preço: \$ " + widget.cryptoCurrency.priceUsd.toString()),
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
