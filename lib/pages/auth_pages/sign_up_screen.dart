import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/components/custom_password_field.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/models/user_model/user_auth_model.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import 'package:quant_bot_flutter/providers/sign_up_provider.dart';
import 'package:quant_bot_flutter/services/phone_formatter_service.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupFormNotifier = ref.watch(signUpFormProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 유저명 주소 입력 필드
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('이름 *',
                      style: TextStyle(
                        fontSize: 12,
                      )),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'EX) 김퀀트',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.gray40),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.black),
                      ),
                    ),
                    controller: signupFormNotifier.nameController,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // 이메일 주소 입력 필드
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('이메일 주소 *', style: TextStyle(fontSize: 12)),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'EX) quant-bot@mail.dot',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.gray40),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.black),
                      ),
                    ),
                    controller: signupFormNotifier.emailController,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // 비밀번호 필드
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('비밀번호 *', style: TextStyle(fontSize: 12)),
                  CustomPasswordTextField(controller: signupFormNotifier.passwordController),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('비밀번호 확인 *', style: TextStyle(fontSize: 12)),
                  CustomPasswordTextField(controller: signupFormNotifier.passwordDuplicateController),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('핸드폰 번호', style: TextStyle(fontSize: 12)),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'EX) 홍길동',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.gray40),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.black),
                      ),
                    ),
                    controller: signupFormNotifier.mobileController,
                    inputFormatters: [
                      PhoneInputFormatter(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              await ref.read(
                signUpProvider(ref.watch(signUpFormProvider)).future,
              );
              context.go('/');
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.grey[300],
              backgroundColor: CustomColors.black,
              fixedSize: const Size(600, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('회원가입'),
          ),
        ),
      ),
    );
  }
}
