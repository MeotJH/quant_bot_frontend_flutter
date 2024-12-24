import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/pages/quant_page/dual_momentums/international/dual_momentum_international.dart';
import 'package:quant_bot_flutter/pages/quant_page/trend_follow/trend_follow_detail_page.dart';
import 'package:quant_bot_flutter/pages/quant_page/trend_follow/trend_follow_page.dart';
import 'package:quant_bot_flutter/pages/quant_select_page/quant_select_page.dart';

const String _quantTypePath = '/quant-form/quant';
const String _trendFollowPath = '/quant-form/quant/trend-follow';
const String _trendFollowDetailPath = '/quant-form/quant/trend-follow/:ticker';
const String _internationalDualMomentumPath =
    '/quant-form/quant/dual-momentum/international';
List<GoRoute> quantTypeRoutes = [
  GoRoute(
    path: _quantTypePath,
    builder: (context, state) => const QuantSelectPage(),
  ),
  GoRoute(
    path: _trendFollowPath,
    builder: (context, state) => const TrendFollowPage(),
  ),
  GoRoute(
    path: _trendFollowDetailPath,
    builder: (context, state) => TrendFollowDetailPage(
      ticker: state.pathParameters['ticker']!,
    ),
  ),
  GoRoute(
    path: _internationalDualMomentumPath,
    builder: (context, state) => const DualMomentumInternational(),
  ),
];
