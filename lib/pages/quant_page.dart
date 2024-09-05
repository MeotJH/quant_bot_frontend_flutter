import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/components/line_chart.dart';
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

    return Scaffold(
      body: Column(
        children: [
          Text(widget.ticker),
          Expanded(
            child: trendFollow.when(
              data: (data) {
                return QuantLineChart(firstChartData: data.firstLineChart, secondChartData: data.secondLineChart);
              },
              error: (error, stack) {
                return Text('Error: $error');
              },
              loading: () {
                return const CircularProgressIndicator();
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            alignment: Alignment.centerLeft,
            child: const Text(
              '추세 추종법 데이터',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
