import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/models/stock_model/stock_model.dart';
import 'package:quant_bot_flutter/providers/dio_provider.dart';

final stocksProvider = FutureProvider.autoDispose<List<StockModel>>((ref) async {
  try {
    final dio = ref.read(dioProvider);

    final response = await dio.get('/stocks');

    if (response.statusCode != 200) {
      return [];
    }
    final List<dynamic> stocksJson = response.data['stocks'] as List<dynamic>;
    final List<StockModel> stocks = stocksJson.map((stock) {
      return StockModel.fromJson(stock: stock);
    }).toList();
    return stocks;
  } catch (e) {
    print(e);
    return [];
  }
});
