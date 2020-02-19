import 'dart:async';
import 'dart:convert' as convert;
import 'dart:developer';
import 'package:crypto_info/classes/crypto_currency.dart';
import 'package:crypto_info/classes/crypto_currency_candle.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

class CryptoCurrencyBloc {
  String _urlAssets = "https://api.coincap.io/v2/assets";
  String _urlCandle = "https://api.coincap.io/v2/candles";
  int _limit = 10;
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

  getPriceUsdUpdates(CryptoCurrency cryptoCurrency) {
    return IOWebSocketChannel.connect(
            "wss://ws.coincap.io/prices?assets=${cryptoCurrency.id}")
        .stream
        .cast<String>()
        .asBroadcastStream();
  }

  dispose() {
    _streamController.close();
    _streamControllerLimit.close();
    _streamControllerCandle.close();
  }
}
