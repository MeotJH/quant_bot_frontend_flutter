import 'package:quant_bot_flutter/models/quant_model/quant_model.dart';
import 'package:quant_bot_flutter/models/trend_follow_model/trend_follow_model.dart';

class TrendFollowService {
  final List<QuantModel> models;
  const TrendFollowService({required this.models});

  TrendFollowModel generateTrendFollows() {
    final fistChartData = models.reversed
        .toList()
        .asMap()
        .map((index, entry) => MapEntry(index, {'x': index.toDouble(), 'y': double.parse(entry.close)}))
        .values
        .toList();

    final secondChartData = models.reversed
        .toList()
        .asMap()
        .map((index, entry) => MapEntry(index, {'x': index.toDouble(), 'y': double.tryParse(entry.trendFollow) ?? 0.0}))
        .values
        .toList();
    return TrendFollowModel(firstLineChart: fistChartData, secondLineChart: secondChartData);
  }
}
