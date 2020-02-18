import 'dart:async';
import 'dart:convert' as convert;
import 'dart:developer';
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

class CryptoCurrencyCandle {
  final double open;
  final double high;
  final double low;
  final double close;
  final double volumeto;

  CryptoCurrencyCandle(
      this.open, this.high, this.low, this.close, this.volumeto);

  CryptoCurrencyCandle.fromJson(Map<String, dynamic> json)
      : this.open = double.parse(json["open"] ?? "0"),
        this.high = double.parse(json["high"] ?? "0"),
        this.low = double.parse(json["low"] ?? "0"),
        this.close = double.parse(json["close"] ?? "0"),
        this.volumeto = double.parse(json["volume"] ?? "0");

  Map<String, double> toJson() => {
        "open": this.open,
        "high": this.high,
        "low": this.low,
        "close": this.close,
        "volumeto": this.volumeto
      };
}

class CryptoCurrencyBloc {
  String _urlAssets = "https://api.coincap.io/v2/assets";
  String _urlCandle = "https://api.coincap.io/v2/candles";
  int _limit = 2000;
  StreamController<List<CryptoCurrency>> _streamController;
  StreamController<List<CryptoCurrencyCandle>> _streamControllerCandle;
  StreamController<int> _streamControllerLimit;

  static final CryptoCurrencyBloc instance = CryptoCurrencyBloc._();

  factory CryptoCurrencyBloc() => instance;

  CryptoCurrencyBloc._() {
    _streamController = StreamController.broadcast();
    _streamControllerLimit = StreamController.broadcast();
    _streamControllerCandle = StreamController.broadcast();
  }

  Stream<List<CryptoCurrency>> get cryptoCurrencyStream =>
      _streamController.stream;
  Stream<List<CryptoCurrencyCandle>> get cryptoCurrencyCandleStream =>
      _streamControllerCandle.stream;
  Stream<int> get cryptoCurrencyStreamLimit => _streamControllerLimit.stream;
  int get limit => _limit;

  Future loadCryptoCurrenciesData() async {
    try {
      await this.loadData();
      Response response = await get(this._urlAssets + "?limit=$_limit");
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

  Future loadCryptoCurrencyCandle(CryptoCurrency cryptoCurrency) async {
    try {
      Response response = await get(this._urlCandle +
          "?exchange=binance&interval=d1&baseId=${cryptoCurrency.id}&quoteId=tether");
      Map<String, dynamic> result = convert.jsonDecode(response.body);
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(result["data"]);
      List<CryptoCurrencyCandle> cryptoCurrenciesCandle = data
          .map((Map<String, dynamic> crypto) =>
              CryptoCurrencyCandle.fromJson(crypto))
          .toList();
      _streamControllerCandle.sink.add(cryptoCurrenciesCandle);
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
    _streamControllerCandle.close();
  }
}
