import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

class DioNotifier extends Notifier<Dio> {
  String local = 'http://localhost:8080/api/v1'; //'http://quantwo-bot.iptime.org/api/v1';
  late Dio _dio;
  DioNotifier() {
    _dio = Dio(
      BaseOptions(
        baseUrl: local,
      ),
    );
  }

  @override
  Dio build() {
    return _dio;
  }

  void addAuth({required String token}) {
    _dio.options = _dio.options.copyWith(
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}

final dioProvider = NotifierProvider<DioNotifier, Dio>(DioNotifier.new);
