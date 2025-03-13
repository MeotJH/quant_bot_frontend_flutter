import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/components/custom_password_field.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/models/user_model/user_auth_model.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import 'package:quant_bot_flutter/providers/router_provider.dart';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(authFormProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            context.go(RouteNotifier.stockListPath);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    _buildLogoAndSlogan(),
                    const SizedBox(height: 40),
                    _buildEmailField(ref),
                    const SizedBox(height: 20),
                    _buildPasswordField(ref),
                    const SizedBox(height: 30),
                    _buildLoginButton(context, ref, model),
                    const SizedBox(height: 10),
                    _buildNaverLoginButton(),
                    const SizedBox(height: 20),
                    _buildBottomLinks(context),
                    const Spacer(),
                    //_buildAppleLoginButton(),
                    //const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoAndSlogan() {
    return Column(
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
    );
  }

  Widget _buildEmailField(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('E-mail', style: TextStyle(fontSize: 14)),
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
          controller: ref.watch(authFormProvider.notifier).emailController,
        ),
      ],
    );
  }

  Widget _buildPasswordField(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password', style: TextStyle(fontSize: 14)),
        CustomPasswordTextField(
          controller: ref.watch(authFormProvider.notifier).passwordController,
        ),
      ],
    );
  }

  Widget _buildLoginButton(
      BuildContext context, WidgetRef ref, UserAuthModel model) {
    return ElevatedButton(
      onPressed: model.isValid
          ? () async {
              await ref.read(authProvider(model).future);
              if (!context.mounted) return;
              context.go(RouteNotifier.stockListPath);
            }
          : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.grey[300],
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('로그인'),
    );
  }

  Widget _buildNaverLoginButton() {
    return ElevatedButton(
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
    );
  }

  Widget _buildBottomLinks(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {
            context.push(RouteNotifier.signUpPath);
          },
          child: const Text(
            '이메일 가입',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        const Text('|', style: TextStyle(color: Colors.grey)),
        TextButton(
          onPressed: () {
            subscribeToPush(context);
            //CustomToast.show(message: '해당 기능은 준비중입니다.', isWarn: true);
          },
          child: const Text(
            '이메일 찾기',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        const Text('|', style: TextStyle(color: Colors.grey)),
        TextButton(
          onPressed: () {
            CustomToast.show(message: '해당 기능은 준비중입니다.', isWarn: true);
          },
          child: const Text(
            '비밀번호 찾기',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildAppleLoginButton() {
    return OutlinedButton.icon(
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
    );
  }

  Future<void> subscribeToPush(BuildContext context) async {
    // 1) 페이지(위젯)가 살아있는지 먼저 확인
    if (!context.mounted) return;

    // 2) VAPID 공개 키 (Base64Url 형태)
    //    ✨ 여기를 꼭 "정상적인 Base64Url" 문자열로 교체하세요!
    const String vapidPublicKey =
        "BKw0ZV97Ta6tYqqC_NQibC2qBNfr8O4GPF3ZmZfOf0TApfGe38w5-Q9u8SOWMxdtDKeTad9k33tJUAYzjEZYx6k";

    try {
      await unsubscribeIfNeeded();

      // 3) Service Worker 준비 상태 확인
      final swRegistration = await html.window.navigator.serviceWorker?.ready;
      if (swRegistration == null) {
        debugPrint("❌ Service Worker가 등록되지 않았습니다.");
        return;
      }

      // 4) PushManager 지원 여부 확인
      if (swRegistration.pushManager == null) {
        debugPrint("❌ 현재 브라우저는 Push API를 지원하지 않습니다.");
        return;
      }

      // 5) Base64Url → Uint8Array 변환
      final applicationServerKey = _base64UrlToUint8Array(vapidPublicKey);

      // 6) Push 구독 요청
      final subscription = await js_util.promiseToFuture(
        js_util.callMethod(
          swRegistration.pushManager!,
          'subscribe',
          [
            js_util.jsify({
              "userVisibleOnly": true,
              "applicationServerKey": applicationServerKey,
            })
          ],
        ),
      );

      // 7) 위젯이 여전히 유효한지 재확인
      if (!context.mounted) return;

      // 8) 구독 정보 추출
      final endpoint = js_util.getProperty(subscription, "endpoint");
      final keys = js_util.getProperty(subscription, "keys");
      if (keys == null) {
        debugPrint(
            "❌ subscription.keys가 null 입니다. WebPush가 제대로 지원되지 않을 수 있습니다.");
        return;
      }

      final p256dhBuffer = js_util.getProperty(keys, "p256dh");
      final authBuffer = js_util.getProperty(keys, "auth");
      if (p256dhBuffer == null || authBuffer == null) {
        debugPrint("❌ p256dh 또는 auth 값이 null 입니다.");
        return;
      }

      // 9) 추출한 값들을 Base64로 인코딩 (백엔드 전송 위해)
      final p256dh = _uint8ListToBase64(
        js_util.getProperty(p256dhBuffer, "buffer") as ByteBuffer? ??
            Uint8List(0).buffer,
      );
      final auth = _uint8ListToBase64(
        js_util.getProperty(authBuffer, "buffer") as ByteBuffer? ??
            Uint8List(0).buffer,
      );

      // 10) 최종 구독 정보를 JSON 형태로 준비
      final subscriptionJson = {
        "endpoint": endpoint,
        "keys": {
          "p256dh": p256dh,
          "auth": auth,
        },
      };

      debugPrint("✅ Web Push 구독 정보 생성 완료: $subscriptionJson");

      // 11) 서버에 POST로 전송 (원하는 서버 주소로 맞춰주세요)
      final dio = Dio();
      final response = await dio.post(
        'https://127.0.0.1:8080/api/v1/notification/subscribe',
        options: Options(headers: {"Content-Type": "application/json"}),
        data: subscriptionJson,
      );

      if (response.statusCode == 201) {
        debugPrint("✅ 푸시 구독 성공!");
      } else {
        debugPrint("❌ 푸시 구독 실패: $response");
      }
    } catch (e) {
      debugPrint("❌ 푸시 구독 중 오류 발생: $e");
    }
  }

  /// ▼ Base64Url → Uint8Array 변환 함수
  Uint8List _base64UrlToUint8Array(String base64UrlString) {
    // 1) base64url 표준에 맞게 문자 치환
    String base64 = base64UrlString.replaceAll('-', '+').replaceAll('_', '/');

    // 2) Base64 길이가 4의 배수가 되도록 패딩 추가
    while (base64.length % 4 != 0) {
      base64 += '=';
    }

    // 3) 디코딩 후 Uint8List 로 반환
    return base64Decode(base64);
  }

  /// ▼ Uint8List → Base64 변환 함수 (서버 전송용)
  String _uint8ListToBase64(ByteBuffer buffer) {
    return base64Encode(Uint8List.view(buffer));
  }

  Future<void> unsubscribeIfNeeded() async {
    final swRegistration = await html.window.navigator.serviceWorker?.ready;
    if (swRegistration == null) {
      print("❌ Service Worker 미등록");
      return;
    }

    // 현재 구독 가져오기
    final existingSubscription = await js_util.promiseToFuture(
      js_util.callMethod(swRegistration.pushManager!, 'getSubscription', []),
    );

    // 구독이 존재한다면 unsubscribe 진행
    if (existingSubscription != null) {
      try {
        await js_util.promiseToFuture(
          js_util.callMethod(existingSubscription, 'unsubscribe', []),
        );
        print("✅ 기존 푸시 구독 해지 완료.");
      } catch (e) {
        print("❌ 기존 구독 해지 중 오류: $e");
      }
    }
  }
}
