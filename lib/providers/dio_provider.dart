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
  }

  @override
  Dio build() {
    return _dio;
  }
}

final dioProvider = NotifierProvider<DioNotifier, Dio>(DioNotifier.new);
