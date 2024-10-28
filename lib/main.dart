import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/providers/router_provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // do SomeThing afeter message
  print("백그라운드 메시지 처리: ${message.messageId}");
  print("백그라운드 메시지 처리: ${message.data}");
  print("백그라운드 메시지 처리: ${message.notification?.title}");
  print("백그라운드 메시지 처리: ${message.notification?.body}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  log('ENVIROMENT: ${dotenv.env['ENVIROMENT']}');

  setPathUrlStrategy();

  if (!kIsWeb) {
    await initNotifications();
  }

  runApp(const ProviderScope(child: QuantBot()));
}

Future<void> initNotifications() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  print('token is ::: ${await FirebaseMessaging.instance.getToken()}');
}

class QuantBot extends ConsumerStatefulWidget {
  const QuantBot({super.key});

  @override
  ConsumerState<QuantBot> createState() => _QuantBotState();
}

class _QuantBotState extends ConsumerState<QuantBot> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quant Bot',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white).copyWith(background: Colors.white),
        dialogBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      routerConfig: ref.read(routeProvider),
    );
  }
}
