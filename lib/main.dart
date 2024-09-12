import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/pages/stocks_page/stocks_page.dart';
import 'package:quant_bot_flutter/providers/router_provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const ProviderScope(child: QuantBot()));
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
