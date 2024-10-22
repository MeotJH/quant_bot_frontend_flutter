import 'package:dio/dio.dart';

import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import 'package:riverpod/riverpod.dart';

class DioNotifier extends Notifier<Dio> {
  String local = 'http://127.0.0.1:8080/api/v1';
  late Dio _dio;

  @override
  Dio build() {
    _dio = Dio(BaseOptions(baseUrl: local));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await ref.read(authStorageProvider.notifier).getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          CustomToast.show(message: 'mail 또는 비밀번호가 올바르지 않습니다.', isWarn: true);
          return;
        }
        return handler.next(error);
      },
    ));

    return _dio;
  }

  void addAuth({required String token}) {
    _dio.options = _dio.options.copyWith(
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  void removeAuth() {
    _dio.options = _dio.options.copyWith(headers: {});
  }
}

final dioProvider = NotifierProvider<DioNotifier, Dio>(DioNotifier.new);
