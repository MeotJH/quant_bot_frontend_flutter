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

  // 이메일 유효성 검사
  static bool validateEmail(String email) {
    // 이메일 형식에 맞는지 확인
    if (email.isEmpty) return true;
    final emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailReg.hasMatch(email);
  }

  // 비밀번호 유효성 검사
  static bool validatePassword(String password) {
    // 8자리 이상 문자, 숫자, 특수문자를 포함해야 함
    print('in service $password');
    if (password.isEmpty) return true;
    final passwordReg = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    print('passwordReg.hasMatch(password) ${passwordReg.hasMatch(password)}');
    return passwordReg.hasMatch(password);
  }

  // 비밀번호 유효성 검사
  static bool validateMatchPassword({required String password, required String passwordDuplicate}) {
    return password == passwordDuplicate;
  }
}
