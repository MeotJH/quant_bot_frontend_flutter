import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/models/user_model/user_auth_model.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

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
            const SizedBox(height: 40),
            // 로고 및 슬로건
            Column(
              children: [
                Image.asset(
                  'assets/images/quant_bot.png',
                  height: 200,
                ),
                const Text(
                  "I'm Quant Two Bot, your personal quant",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 40),
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
            const SizedBox(height: 30),
            // 로그인 버튼
            ElevatedButton(
              onPressed: () async {
                await ref.read(authProvider(
                  ref.watch(
                    authFormProvider,
                  ),
                ).future);

                context.go('/');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey[300],
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('로그인'),
            ),
            const SizedBox(height: 10),
            // 네이버 로그인 버튼
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF03C75A),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('네이버로 로그인'),
            ),
            const SizedBox(height: 20),
            // 하단 링크
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '이메일 가입',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const Text('|', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '이메일 찾기',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const Text('|', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '비밀번호 찾기',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Apple 로그인 버튼
            OutlinedButton.icon(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              icon: const Icon(Icons.apple, color: Colors.black),
              label: const Text(
                'Apple로 로그인',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
