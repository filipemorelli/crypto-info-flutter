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
