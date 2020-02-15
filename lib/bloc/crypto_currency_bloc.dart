import 'dart:async';
import 'dart:convert' as convert;
import 'dart:developer';
import 'package:http/http.dart';

class CryptoCurrencyBloc {
  String _url = "https://api.coincap.io/v2/assets";
  StreamController<List<Map<String, dynamic>>> _streamController;

  CryptoCurrencyBloc() {
    _streamController = new StreamController();
  }

  Stream<List<Map<String, dynamic>>> get cryptoCurrencyStream => _streamController.stream;

  loadCryptoCurrenciesData() async {
    try {
      Response response = await get(this._url);
      Map<String, dynamic> result = convert.jsonDecode(response.body);
      List<Map<String, dynamic>> cryptoCurrencies = List<Map<String, dynamic>>.from(result["data"]);
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
