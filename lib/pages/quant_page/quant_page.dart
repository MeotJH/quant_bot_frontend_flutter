import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/components/custom_dialog.dart';
import 'package:quant_bot_flutter/components/line_chart.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/models/quant_model/quant_stock_model.dart';
import 'package:quant_bot_flutter/pages/quant_page/quant_page_table.dart';
import 'package:quant_bot_flutter/pages/quant_page/trend_follow_quant_table.dart';
import 'package:quant_bot_flutter/providers/quant_provider.dart';

class QuantPage extends ConsumerStatefulWidget {
  final String ticker;
  final String quant;

  const QuantPage({super.key, required this.ticker, required this.quant});

  @override
  ConsumerState<QuantPage> createState() => _QuantPageState();
}

class _QuantPageState extends ConsumerState<QuantPage> {
  @override
  Widget build(BuildContext context) {
    final trendFollow = ref.watch(trendFollowProvider(widget.ticker));
    final ticker = widget.ticker;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: trendFollow.when(
                  data: (data) {
                    final recentOne = data.recentStockOne;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recentOne.shortName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ticker,
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.gray50,
                          ),
                        ),
                        Text(
                          '\$${recentOne.currentPrice}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _calNetChange(recentOne),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getNetChangeColor(recentOne),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) {
                    return const Text('모..몬가 잘못되었음');
                  },
                )),
            SizedBox(
              height: 300,
              child: trendFollow.when(
                data: (data) {
                  return QuantLineChart(
                    firstChartData: data.firstLineChart,
                    secondChartData: data.secondLineChart,
                  );
                },
                error: (error, stack) {
                  return Text('Error: $error');
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      const Text(
                        '추세 정보',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 77),
                        child: InkWell(
                          onTap: () async {
                            await showQuantBotDialog(
                                context: context,
                                title: '추세추종 투자법 정보',
                                content:
                                    '추세 추종 투자법은 시장의 상승 또는 하락 추세를 따라 매수하거나 매도하는 전략입니다.');
                          },
                          child: Icon(
                            CupertinoIcons.question_circle_fill,
                            size: 18,
                            color: CustomColors.brightYellow120,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: trendFollow.when(
                data: (data) {
                  final recentStockData = data.recentStockOne;
                  return TrendFollowQuantTable(recentStockOne: recentStockData);
                },
                error: (error, stack) {
                  return Text('Error: $error');
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              alignment: Alignment.centerLeft,
              child: const Text(
                '주식 정보',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: trendFollow.when(
                data: (data) {
                  final recentStockData = data.recentStockOne;
                  return QuantPageTable(recentStockOne: recentStockData);
                },
                error: (error, stack) {
                  return Text('Error: $error');
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calNetChange(QuantStockModel recentStockOne) {
    final double netChange = double.parse(recentStockOne.currentPrice) -
        double.parse(recentStockOne.previousClose);

    final strNetChange = netChange.toStringAsFixed(2);
    final strNetChangePercent =
        (netChange / double.parse(recentStockOne.previousClose) * 100)
            .toStringAsFixed(2);
    return '\$$strNetChange ($strNetChangePercent%)';
  }

  Color _getNetChangeColor(QuantStockModel recentStockOne) {
    final double netChange = double.parse(recentStockOne.currentPrice) -
        double.parse(recentStockOne.previousClose);
    return netChange > 0 ? CustomColors.error : CustomColors.clearBlue100;
  }
}
