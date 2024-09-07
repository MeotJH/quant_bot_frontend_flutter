import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/models/quant_model/quant_model.dart';
import 'package:quant_bot_flutter/models/quant_model/quant_stock_model.dart';
import 'package:quant_bot_flutter/models/trend_follow_model/trend_follow_model.dart';
import 'package:quant_bot_flutter/providers/dio_provider.dart';
import 'package:quant_bot_flutter/services/trend_follow_service.dart';

//변수 받아서 get 요청하는 notifier 예제
final trendFollowProvider = AsyncNotifierProvider.autoDispose
    .family<TrendFollowNotifier, TrendFollowModel, String>(
  TrendFollowNotifier.new,
);

class TrendFollowNotifier
    extends AutoDisposeFamilyAsyncNotifier<TrendFollowModel, String> {
  @override
  Future<TrendFollowModel> build(String ticker) async {
    final dio = ref.read(dioProvider);
    try {
      final response = await dio.get('/quants/trend_follow/$ticker');

      if (response.statusCode != 200) {
        return TrendFollowModel(
            firstLineChart: [],
            secondLineChart: [],
            models: [],
            recentStockOne: QuantStockModel());
      }

      final List stockHistory = response.data['stock_history'];
      final Map<String, dynamic> stockInfo = response.data['stock_info'];

      List<QuantModel> models =
          stockHistory.map((e) => QuantModel.fromJson(stock: e)).toList();
      final QuantStockModel quantStockModel =
          QuantStockModel.fromJson(json: stockInfo);

      return TrendFollowService(models: models, recentStockOne: quantStockModel)
          .generateTrendFollows();
    } catch (e) {
      return TrendFollowModel(
          firstLineChart: [],
          secondLineChart: [],
          models: [],
          recentStockOne: QuantStockModel());
    }
  }
}
