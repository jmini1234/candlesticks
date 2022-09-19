  // 5023 종가
  // 5029 시가
  // 5030 고가
  // 5031 저가
  // 5646 날짜
  // 5033 등락률
  // 5023 거래량

/// Candle model wich holds a single candle data.
/// It contains five required double variables that hold a single candle data: high, low, open, close and volume.
/// It can be instantiated using its default constructor or fromJson named custructor.
class Candle {
  /// DateTime for the candle
  final DateTime date;

  /// The highet price during this candle lifetime
  /// It if always more than low, open and close
  final double high;

  /// The lowest price during this candle lifetime
  /// It if always less than high, open and close
  final double low;

  /// Price at the beginnig of the period
  final double open;

  /// Price at the end of the period
  final double close;

  /// Volume is the number of shares of a
  /// security traded during a given period of time.
  final double volume;

  bool get isBull => open <= close;

  Candle({
    required this.date,
    required this.high,
    required this.low,
    required this.open,
    required this.close,
    required this.volume,
  });

  Candle.fromJson(List<dynamic> json)
      : date = DateTime.parse(json[5]),
        high = double.parse(json[0]),
        low = double.parse(json[1]),
        open = double.parse(json[2]),
        close = double.parse(json[3]),
        volume = double.parse(json[4]);
}
