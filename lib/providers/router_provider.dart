import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/pages/quant_page/quant_page.dart';
import 'package:quant_bot_flutter/pages/stocks_page.dart';

class RouteNotifier extends Notifier<GoRouter> {
  late GoRouter _route;

  RouteNotifier() {
    _route = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const StockListPage();
          },
        ),
        GoRoute(
          path: '/quants/:quant/:ticker',
          builder: (BuildContext context, GoRouterState state) {
            final String ticker = state.pathParameters['ticker']!;
            final String quant = state.pathParameters['quant']!;
            return QuantPage(ticker: ticker, quant: quant);
          },
        ),
      ],
      redirect: (context, state) async {
        return null;
      },
      initialLocation: '/',
    );
  }

  @override
  GoRouter build() {
    return _route;
  }
}

final routeProvider =
    NotifierProvider<RouteNotifier, GoRouter>(RouteNotifier.new);
