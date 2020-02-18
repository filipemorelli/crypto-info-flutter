import 'dart:async';
import 'dart:convert' as convert;
import 'dart:developer';
import 'package:crypto_info/global/functions.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  StreamController<int> _streamControllerLimit;

  static final CryptoCurrencyBloc instance = CryptoCurrencyBloc._();

  factory CryptoCurrencyBloc() => instance;

  CryptoCurrencyBloc._() {
    _streamController = new StreamController.broadcast();
    _streamControllerLimit = new StreamController.broadcast();
  }

  Stream<List<CryptoCurrency>> get cryptoCurrencyStream =>
      _streamController.stream;
  Stream<int> get cryptoCurrencyStreamLimit => _streamControllerLimit.stream;
  int get limit => _limit;

  Future loadCryptoCurrenciesData() async {
    try {
      await this.loadData();
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
      return Future.error(e);
    }
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this._limit = prefs.getInt("CryptoCurrencyBloc_limit") ?? this._limit;
  }

  updateLimit(int limit) async {
    this._limit = limit;
    this._streamControllerLimit.sink.add(limit);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("CryptoCurrencyBloc_limit", limit);
    this.loadCryptoCurrenciesData();
  }

  dispose() {
    _streamController.close();
    _streamControllerLimit.close();
  }
}
