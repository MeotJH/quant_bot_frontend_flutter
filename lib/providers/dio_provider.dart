import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
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
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          CustomToast.show(message: '비밀번호가 틀렸어여!!', isWarn: true);
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
}

final dioProvider = NotifierProvider<DioNotifier, Dio>(DioNotifier.new);
