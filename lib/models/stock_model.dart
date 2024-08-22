import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_model.freezed.dart';
part 'stock_model.g.dart';

@freezed
class StockModel with _$StockModel {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
    includeIfNull: false,
    explicitToJson: true,
  )
  factory StockModel({
    @Default('') String ticker,
    @Default('') String date,
    @Default(0.0) double open,
    @Default(0.0) double high,
    @Default(0.0) double low,
    @Default(0.0) double close,
    @Default(0.0) double adjClose,
    @Default(0) int volume,
  }) = _StockModel;
  factory StockModel.fromJson(Map<String, dynamic> json) {
    final ticker = json.keys.first;
    final stockData = json[ticker] as Map<String, dynamic>;

    return StockModel(
      ticker: ticker,
      date: stockData['Date'] as String,
      open: stockData['Open'] as double,
      high: stockData['High'] as double,
      low: stockData['Low'] as double,
      close: stockData['Close'] as double,
      adjClose: stockData['Adj Close'] as double,
      volume: stockData['Volume'] as int,
    );
  }
}

// "MMM": {
//     "Date": "2024-08-16",
//     "Open": 126.73999786376953,
//     "High": 127.33999633789062,
//     "Low": 126.0199966430664,
//     "Close": 127.05000305175781,
//     "Adj Close": 127.05000305175781,
//     "Volume": 3812600
//   },