import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/models/profile_stock_model/profile_stock_model.dart';
// import 'package:quant_bot_flutter/providers/dio_provider.dart';

final profileStocksProvider =
    AsyncNotifierProvider<ProfileStocksNotifier, List<ProfileStockModel>>(
        ProfileStocksNotifier.new);

class ProfileStocksNotifier extends AsyncNotifier<List<ProfileStockModel>> {
  @override
  Future<List<ProfileStockModel>> build() async {
    return fetchProfileStocks();
  }

  Future<List<ProfileStockModel>> fetchProfileStocks() async {
    // 임시 데이터를 사용하기 위해 API 호출 부분을 주석 처리합니다.
    // try {
    //   final dio = ref.read(dioProvider);
    //   final response = await dio.get('/profile/stocks');

    //   if (response.statusCode != 200) {
    //     throw Exception('프로필 주식 정보를 불러오는데 실패했습니다.');
    //   }

    //   final List<dynamic> stocksJson = response.data['stocks'] as List<dynamic>;
    //   return stocksJson
    //       .map((stock) => ProfileStockModel.fromJson(stock))
    //       .toList();
    // } catch (e) {
    //   throw Exception('프로필 주식 정보를 불러오는 중 오류가 발생했습니다: $e');
    // }

    // 임시 데이터를 반환합니다.
    await Future.delayed(const Duration(seconds: 2)); // 네트워크 지연 시뮬레이션
    return [
      ProfileStockModel(
          ticker: 'AAPL',
          name: 'Apple Inc.',
          quantType: 'TF',
          notification: false),
      ProfileStockModel(
          ticker: 'GOOGL',
          name: 'Alphabet Inc.',
          quantType: 'TF',
          notification: true),
      ProfileStockModel(
          ticker: 'MSFT',
          name: 'Microsoft Corporation',
          quantType: 'TF',
          notification: false),
      ProfileStockModel(
          ticker: 'AMZN',
          name: 'Amazon.com, Inc.',
          quantType: 'TF',
          notification: true),
      ProfileStockModel(
          ticker: 'FB',
          name: 'Facebook, Inc.',
          quantType: 'TF',
          notification: false),
    ];
  }

  Future<void> refreshProfileStocks() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchProfileStocks());
  }

  Future<void> toggleNotification(String ticker) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updatedStocks = state.value?.map((stock) {
            if (stock.ticker == ticker) {
              return ProfileStockModel(
                ticker: stock.ticker,
                name: stock.name,
                quantType: stock.quantType,
                notification: !stock.notification,
              );
            }
            return stock;
          }).toList() ??
          [];

      // TODO: API 호출로 서버에 변경사항 저장
      // await _stockService.updateNotificationStatus(ticker, !stock.notification);

      return updatedStocks;
    });
  }
}
