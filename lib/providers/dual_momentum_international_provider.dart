import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/models/dual_momentum_international_model/dual_momentum_international_model.dart';
import 'package:quant_bot_flutter/providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dual_momentum_international_provider.g.dart';

class BacktestParams {
  final List<String> etfSymbols;
  final int duration;
  final double savingsRate;

  const BacktestParams({
    required this.etfSymbols,
    required this.duration,
    required this.savingsRate,
  });
}

@Riverpod(keepAlive: false)
class DualMomentumInternationalFamily
    extends _$DualMomentumInternationalFamily {
  @override
  FutureOr<DualMomentumInternationalModel> build(BacktestParams params) async {
    return runBacktest(
      etfSymbols: params.etfSymbols,
      duration: params.duration,
      savingsRate: params.savingsRate,
    );
  }

  Future<DualMomentumInternationalModel> runBacktest({
    required List<String> etfSymbols,
    required int duration,
    required double savingsRate,
  }) async {
    final dio = ref.read(dioProvider);
    try {
      final response = await dio.get(
        '/quants/dual_momentum',
        queryParameters: {
          'etf_symbols': etfSymbols.join(','),
          'duration': duration,
          'savings_rate': savingsRate,
        },
      );

      debugPrint('response: ${response.data}');
      return DualMomentumInternationalModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
