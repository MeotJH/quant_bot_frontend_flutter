import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quant_bot_flutter/constants/api_constants.dart';
import 'package:quant_bot_flutter/models/user_model/user_auth_model.dart';
import 'package:quant_bot_flutter/models/user_model/user_auth_response_model.dart';
import 'package:quant_bot_flutter/providers/dio_provider.dart';

final authStorageProvider = AsyncNotifierProvider.autoDispose<AuthStorageNotifier, String?>(AuthStorageNotifier.new);

class AuthStorageNotifier extends AutoDisposeAsyncNotifier<String?> {
  late final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<String?> build() async {
    return getToken();
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'authorization', value: token);
    state = AsyncValue.data(token);
  }

  Future<String?> _loadToken() async {
    final token = await _storage.read(key: 'authorization');
    state = AsyncValue.data(token);
    return token;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'authorization');
    state = const AsyncValue.data(null);
  }

  Future<String?> getToken() async {
    final String? token = await _loadToken();
    print('this is token: $token');
    return token;
  }
}

final authProvider = AsyncNotifierProvider.autoDispose.family<AuthProvider, void, UserAuthModel>(AuthProvider.new);

class AuthProvider extends AutoDisposeFamilyAsyncNotifier<void, UserAuthModel> {
  @override
  Future<void> build(UserAuthModel model) async {
    final token = await ref.read(authStorageProvider.notifier).getToken();
    final dio = ref.read(dioProvider);
    if (token != null) {
      ref.read(dioProvider.notifier).addAuth(token: token);
    }

    final response = await dio.post(ApiUrl.signIn, data: model.toJson());

    if (response.statusCode != ApiStatus.success) {
      throw Exception();
    }

    final userResponseJson = response.data as Map<String, dynamic>;
    final userAuthResponseModel = UserAuthResponseModel.fromJson(userResponseJson);
    ref.read(dioProvider.notifier).addAuth(token: userAuthResponseModel.authorization);
    ref.read(authStorageProvider.notifier).saveToken(userAuthResponseModel.authorization);
  }
}

final authFormProvider = StateNotifierProvider<AuthFormNotifier, UserAuthModel>(
  (ref) => AuthFormNotifier(),
);

class AuthFormNotifier extends StateNotifier<UserAuthModel> {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  AuthFormNotifier()
      : emailController = TextEditingController(),
        passwordController = TextEditingController(),
        super(UserAuthModel(email: '', password: '')) {
    emailController.addListener(() {
      state = state.copyWith(email: emailController.text);
    });
    passwordController.addListener(() {
      state = state.copyWith(password: passwordController.text);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
