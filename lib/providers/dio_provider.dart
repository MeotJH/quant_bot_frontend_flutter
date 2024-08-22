import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

class DioNotifier extends Notifier<Dio> {
  String local = 'http://localhost:8080/api/v1';
  late Dio _dio;
  DioNotifier() {
    _dio = Dio(
      BaseOptions(
        baseUrl: local,
      ),
    );

    // _dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onError: (DioException error, ErrorInterceptorHandler handler) async {
    //       final int statusCode = error.response?.statusCode ?? 0;

    //       if (statusCode == 403 || statusCode == 401 || statusCode == 422) {
    //         final route = ref.read(routeProvider);
    //         route.go('/');
    //       }

    //       return handler.next(error);
    //     },
    //   ),
    // );
  }

  @override
  Dio build() {
    return _dio;
  }
}

final dioProvider = NotifierProvider<DioNotifier, Dio>(DioNotifier.new);
