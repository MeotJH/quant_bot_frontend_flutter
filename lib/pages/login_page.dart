import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // 로고 및 슬로건
            const Column(
              children: [
                Text(
                  'KREAM',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'KICKS RULE EVERYTHING AROUND ME',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // 이메일 주소 입력 필드
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('이메일 주소', style: TextStyle(fontSize: 14)),
                TextField(
                  decoration: InputDecoration(
                    hintText: '예) kream@kream.co.kr',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: const Text(
                          'kream_signin',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 비밀번호 필드
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('비밀번호', style: TextStyle(fontSize: 14)),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // 로그인 버튼
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey[300],
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('로그인'),
            ),
            const SizedBox(height: 10),
            // 네이버 로그인 버튼
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF03C75A),
                minimumSize: const Size(double.infinity, 50),
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
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.black),
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
