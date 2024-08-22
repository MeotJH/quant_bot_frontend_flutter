import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/models/stock_model.dart';
import 'package:quant_bot_flutter/providers/dio_provider.dart';

final stocksProvider = FutureProvider.autoDispose<List<StockModel>>((ref) async {
  final dio = ref.read(dioProvider);

  final response = await dio.get('/stocks');

  if (response.statusCode != 200) {
    return [];
  }

  final Map<String, dynamic> stocksJson = response.data as Map<String, dynamic>;
  final List<StockModel> stocks = stocksJson.entries.map((entry) {
    final String ticker = entry.key;
    final Map<String, dynamic> stockData = entry.value as Map<String, dynamic>;
    return StockModel.fromJson({ticker: stockData});
  }).toList();

  return stocks;
});
