import 'package:dio/dio.dart';

class StockService {
  final Dio dio;

  StockService(this.dio);

  Future<void> addStockToProfile(String ticker, String quantType) async {
    final data = {
      "quant_type": quantType,
    };

    try {
      final response =
          await dio.post('/quants/trend_follow/$ticker', data: data);

      if (response.statusCode == 200) {
        print('주식이 프로필에 추가되었습니다.');
      } else {
        throw Exception('주식 추가 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('예외 발생: $e');
      rethrow;
    }
  }
}
