import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/components/confetti_animation.dart';

class SignUpCompleteScreen extends StatelessWidget {
  const SignUpCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 100, color: Colors.green),
                  Text('회원가입이 완료되었습니다.', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            Positioned.fill(
              // 여기 추가
              child: ConfettiAnimation(),
            ),
          ],
        ),
      ),
    );
  }
}
