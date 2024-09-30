import 'package:dio/dio.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/models/sign_up_model/sign_up_model.dart';

class SignUpService {
  final SignUpModel model;
  const SignUpService({required this.model});

  Future<bool> signUp({required Dio dio}) async {
    validate();
    final response = await dio.post('/users/sign-up', data: model.toJson());
    if (response.statusCode != 200) {
      CustomToast.show(message: '회원가입에 실패했습니다.', isWarn: true);
      return false;
    }
    return true;
  }

  void validate() {
    final fields = {
      '이메일': model.email,
      '비밀번호': model.password,
      '이름': model.userName,
      '전화번호': model.mobile,
    };

    // 빈 필드가 있는지 체크하고 첫 번째로 빈 필드에 대한 오류 메시지를 출력
    for (var entry in fields.entries) {
      if (entry.value.isEmpty) {
        CustomToast.show(message: '${entry.key}이(가) 올바르지 않습니다.', isWarn: true);
        return;
      }
    }
  }
}
