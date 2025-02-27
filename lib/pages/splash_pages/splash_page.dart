import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/providers/stocks_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  double _opacity = 1.0;

  void _startAnimation() {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(
          () {
            _opacity = _opacity == 1.0 ? 0.3 : 1.0;
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _startAnimation();
    ref.read(stocksProvider.future);
    Future.delayed(
      const Duration(seconds: 4),
      () {
        context.push('/main');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: _opacity,
        child: Image.asset(
          'assets/images/quant_bot.png',
        ),
      ),
    ));
  }
}
