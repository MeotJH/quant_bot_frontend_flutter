import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/constants/api_constants.dart';
import 'package:quant_bot_flutter/models/user_model/user_auth_model.dart';
import 'package:quant_bot_flutter/models/user_model/user_auth_response_model.dart';
import 'package:quant_bot_flutter/models/user_model/user_model.dart';
import 'package:quant_bot_flutter/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
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
    return token;
  }
}

 **/
/// SecuredStorage를 사용하지 않음 HTTPS 때문에 후에 AWS로 이주하면 사용할 예정

//로그인 후 auth 토큰 관리하는 상태관리
final authStorageProvider =
    AsyncNotifierProvider.autoDispose<AuthStorageNotifier, String?>(
        AuthStorageNotifier.new);

class AuthStorageNotifier extends AutoDisposeAsyncNotifier<String?> {
  late SharedPreferences _prefs;
  final String tokenKey = 'authorization'; // 토큰 키값
  UserModel? _user;

  @override
  Future<String?> build() async {
    await _ensurePrefsInitialized();

    return getToken();
  }

  Future<void> saveToken(String token) async {
    await _ensurePrefsInitialized();
    await _prefs.setString(tokenKey, token);
    state = AsyncValue.data(token);
  }

  Future<String?> _loadToken() async {
    await _ensurePrefsInitialized();
    final token = _prefs.getString(tokenKey);

    // 서버에서 복호화 로직 추가
    try {
      state = AsyncValue.data(token);
      return token;
    } catch (e) {
      print(e); // 디버깅을 위해 에러 로그를 출력
      state =
          const AsyncValue.error("Failed to decrypt token", StackTrace.empty);
      return null;
    }
  }

  Future<void> deleteToken() async {
    await _ensurePrefsInitialized();
    await _prefs.remove(tokenKey);
    state = const AsyncValue.data(null);
  }

  Future<String?> getToken() async {
    return await _loadToken();
  }

  // SharedPreferences 초기화 함수
  Future<void> _ensurePrefsInitialized() async {
    try {
      _prefs;
    } catch (e) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Future<UserModel> findUserByAuth() async {
    if (_user != null) return _user!;

    final dio = ref.read(dioProvider);
    final response = await dio.get(ApiUrl.findUserByAuth);

    if (response.statusCode != ApiStatus.success) {
      throw Exception();
    }

    final userResponseJson = response.data as Map<String, dynamic>;
    _user = UserModel.fromJson(userResponseJson);
    return _user!;
  }
}

// 인증과 관련된 서버와 통신하는 상태관리
final authProvider = AsyncNotifierProvider.autoDispose
    .family<AuthProvider, void, UserAuthModel>(AuthProvider.new);

class AuthProvider extends AutoDisposeFamilyAsyncNotifier<void, UserAuthModel> {
  @override
  Future<void> build(UserAuthModel model) async {
    final token = await ref.read(authStorageProvider.future);
    final dio = ref.read(dioProvider);

    if (token != null) {
      ref.read(dioProvider.notifier).addAuth(token: token);
    }

    final response = await dio.post(ApiUrl.signIn, data: model.toJson());

    if (response.statusCode != ApiStatus.success) {
      throw Exception();
    }

    final userResponseJson = response.data as Map<String, dynamic>;
    final userAuthResponseModel =
        UserAuthResponseModel.fromJson(userResponseJson);
    ref
        .read(dioProvider.notifier)
        .addAuth(token: userAuthResponseModel.authorization);

    ref
        .read(authStorageProvider.notifier)
        .saveToken(userAuthResponseModel.authorization);
  }

  Future<void> signOut() async {
    ref.read(dioProvider.notifier).removeAuth();
    await ref.read(authStorageProvider.notifier).deleteToken();
  }
}

//회원가입을 위한 상태관리
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
