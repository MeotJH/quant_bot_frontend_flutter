import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/components/custom_button.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/core/utils.dart';
import 'package:quant_bot_flutter/pages/comm/quant_bot_detail_page_header.dart';
import 'package:quant_bot_flutter/pages/loading_pages/skeleton_detail_page_loading.dart';
import 'package:quant_bot_flutter/pages/quant_page/dual_momentums/international/dual_momentum_international_graph.dart';
import 'package:quant_bot_flutter/pages/quant_page/dual_momentums/international/dual_momentum_international_table.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import 'package:quant_bot_flutter/providers/dual_momentum_international_provider.dart';
import 'package:quant_bot_flutter/providers/quant_provider.dart';
import 'package:quant_bot_flutter/providers/router_provider.dart';
import 'package:shimmer/shimmer.dart';

class DualMomentumInternational extends ConsumerStatefulWidget {
  const DualMomentumInternational({super.key});

  @override
  ConsumerState<DualMomentumInternational> createState() =>
      _DualMomentumInternationalState();
}

class _DualMomentumInternationalState
    extends ConsumerState<DualMomentumInternational> {
  @override
  Widget build(BuildContext context) {
    const params = BacktestParams(
      etfSymbols: ['SPY', 'FEZ', 'EWJ', 'EWY'],
      duration: 10,
      savingsRate: 3,
    );

    Widget buildSkeletonLoading() {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 300,
              color: Colors.white,
            ),
          ],
        ),
      );
    }

    final provider = ref.watch(dualMomentumInternationalFamilyProvider(params));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const QuantBotDetailPageHeader(title: '국제 ETF 듀얼 모멘텀 전략'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    provider.when(
                      data: (data) => DualMomentumInternationalGraph(
                        data: data,
                        onTap: () {},
                        etfSymbols: params.etfSymbols,
                      ),
                      error: (error, stack) => Center(
                        child: Text('Error: $error'),
                      ),
                      loading: () => Column(
                        children: [
                          Container(
                            height: 150,
                            alignment: Alignment.centerLeft,
                            child: const SkeletonDetailPageLoading(
                              skeletonName:
                                  SkeletonDetailPageLoading.stockInfoSkeleton,
                            ),
                          ),
                          const SizedBox(
                            height: 300,
                            child: SkeletonDetailPageLoading(
                              skeletonName:
                                  SkeletonDetailPageLoading.stockChartSkeleton,
                            ),
                          ),
                        ],
                      ),
                    ),
                    provider.when(
                      data: (data) => DualMomentumInternationalTable(
                        summary: data.summary,
                      ),
                      error: (error, stack) => Text('Error: $error'),
                      loading: () => const SizedBox(
                        height: 300,
                        child: SkeletonDetailPageLoading(
                          skeletonName:
                              SkeletonDetailPageLoading.stockInfoCardSkeleton,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        text: '퀀트 알림 설정',
                        onPressed: () =>
                            _handleQuantAlertSetting("AAPL", context),
                        textColor: Colors.white,
                        backgroundColor: CustomColors.clearBlue120,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleQuantAlertSetting(
      String ticker, BuildContext context) async {
    final auth = await ref.read(authStorageProvider.future);
    if (auth == null) {
      CustomToast.show(message: '로그인이 필요합니다.', isWarn: true);

      if (!context.mounted) return;
      context.push(RouteNotifier.loginPath);
      return;
    }
    final notifier = ref.read(trendFollowProvider(ticker).notifier);
    try {
      final trendFollowData =
          await ref.read(trendFollowProvider(ticker).future);
      final recentStockOne = trendFollowData.recentStockOne;

      final initialPrice = double.parse(recentStockOne.currentPrice);
      final initialTrendFollow =
          double.parse(recentStockOne.lastCrossTrendFollow);

      await notifier.addStockToProfile(
          ticker, 'TF', initialPrice, initialTrendFollow);
      CustomToast.show(message: '퀀트 알림이 성공적으로 설정되었습니다.');
    } catch (e) {
      CustomToast.show(message: getErrorMessage(e), isWarn: true);
      print('퀀트 알림 설정 오류: $e');
    }
  }
}
