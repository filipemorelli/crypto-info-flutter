import 'dart:async';
import 'dart:convert' as convert;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CryptoCurrency {
  final String id;
  final String rank;
  final String symbol;
  final String name;
  final String supply;
  final String maxSupply;
  final String marketCapUsd;
  final String volumeUsd24Hr;
  final String priceUsd;
  final String changePercent24Hr;
  final String vwap24Hr;

  CryptoCurrency(
      this.id,
      this.rank,
      this.symbol,
      this.name,
      this.supply,
      this.maxSupply,
      this.marketCapUsd,
      this.volumeUsd24Hr,
      this.priceUsd,
      this.changePercent24Hr,
      this.vwap24Hr);

  CryptoCurrency.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        rank = json["rank"],
        symbol = json["symbol"],
        name = json["name"],
        supply = json["supply"],
        maxSupply = json["maxSupply"],
        marketCapUsd = json["marketCapUsd"],
        volumeUsd24Hr = json["volumeUsd24Hr"],
        priceUsd = json["priceUsd"],
        changePercent24Hr = json["changePercent24Hr"],
        vwap24Hr = json["vwap24Hr"];

  Map<String, String> toJson() {
    return {
      "id": this.id,
      "rank": this.rank,
      "symbol": this.symbol,
      "name": this.name,
      "supply": this.supply,
      "maxSupply": this.maxSupply,
      "marketCapUsd": this.marketCapUsd,
      "volumeUsd24Hr": this.volumeUsd24Hr,
      "priceUsd": this.priceUsd,
      "changePercent24Hr": this.changePercent24Hr,
      "vwap24Hr": this.vwap24Hr
    };
  }
}

class CryptoCurrencyBloc {
  String _url = "https://api.coincap.io/v2/assets";
  int _limit = 2000;
  StreamController<List<CryptoCurrency>> _streamController;

  CryptoCurrencyBloc() {
    _streamController = new StreamController();
  }

  Stream<List<CryptoCurrency>> get cryptoCurrencyStream =>
      _streamController.stream;

  loadCryptoCurrenciesData() async {
    try {
      Response response = await get(this._url + "?limit=$_limit");
      Map<String, dynamic> result = convert.jsonDecode(response.body);
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(result["data"]);
      List<CryptoCurrency> cryptoCurrencies = data
          .map((Map<String, dynamic> crypto) => CryptoCurrency.fromJson(crypto))
          .toList();
      _streamController.sink.add(cryptoCurrencies);
    } catch (e) {
      log(e.toString(),
          name: "loadCryptoCurrenciesData", stackTrace: StackTrace.current);
    }
  }

  dispose() {
    _streamController.close();
  }
}

class CryptoCurrencyBlocProvider extends InheritedWidget {
  final CryptoCurrencyBloc bloc;
  final Widget child;

  CryptoCurrencyBlocProvider({
    Key key,
    @required this.bloc,
    this.child,
  }) : super(key: key, child: child);

  static CryptoCurrencyBlocProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CryptoCurrencyBlocProvider>();

  @override
  bool updateShouldNotify(CryptoCurrencyBlocProvider oldWidget) => true;
}
