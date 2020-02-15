import 'package:crypto_info/bloc/crypto_currency_bloc.dart';
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
        child: Center(
          child: Text(widget.cryptoCurrency.rank),
        ),
      ),
    );
  }
}
