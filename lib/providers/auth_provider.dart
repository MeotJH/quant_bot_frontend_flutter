import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthNotifier extends AutoDisposeAsyncNotifier<String?> {
  late FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<String?> build() async {
    _storage = const FlutterSecureStorage();
    loadToken();
    return await _storage.read(key: 'authorization');
  }

  // authorization 저장 후 상태 업데이트
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'authorization', value: token);
    state = AsyncValue.data(token); // 상태 업데이트
  }

  // authorization 읽기 및 상태 설정
  Future<void> loadToken() async {
    final token = await _storage.read(key: 'authorization');
    state = AsyncValue.data(token); // 상태 업데이트
  }

  // authorization 삭제 후 상태 null로 업데이트
  Future<void> deleteToken() async {
    await _storage.delete(key: 'authorization');
    state = const AsyncValue.data(null); // 상태를 null로 설정
  }
}

final authProvider =
    AsyncNotifierProvider.autoDispose<AuthNotifier, String?>(AuthNotifier.new);
