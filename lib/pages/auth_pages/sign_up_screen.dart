import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/models/user_model/user_auth_model.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 이메일 주소 입력 필드
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('E-mail', style: TextStyle(fontSize: 14)),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'EX) quant-bot@mail.dot',
                  ),
                  controller: ref.watch(authFormProvider.notifier).emailController,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 비밀번호 필드
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PassWord', style: TextStyle(fontSize: 14)),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                  controller: ref.watch(authFormProvider.notifier).passwordController,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
