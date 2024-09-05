import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/core/colors.dart';

class QuantLineChart extends StatelessWidget {
  final List<Map<String, double>> firstChartData;
  final List<Map<String, double>> secondChartData;

  const QuantLineChart({
    super.key,
    required this.firstChartData,
    required this.secondChartData,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: firstChartData.map((element) {
              return FlSpot(element['x'] ?? 0, element['y'] ?? 0);
            }).toList()
            // [
            //   const FlSpot(0, 1),
            //   const FlSpot(1, 1.5),
            //   const FlSpot(2, 1.4),
            //   const FlSpot(3, 3.4),
            //   const FlSpot(4, 2),
            //   const FlSpot(5, 2.2),
            //   const FlSpot(6, 1.8),
            // ]
            ,
            isCurved: true,
            color: CustomColors.brightYellow100,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: const FlDotData(
              show: false, // dot 표시를 숨김
            ),
          ),
          LineChartBarData(
            spots: secondChartData.map((element) {
              return FlSpot(element['x'] ?? 0, element['y'] ?? 0);
            }).toList(),
            isCurved: true,
            color: CustomColors.clearBlue100,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: const FlDotData(
              show: false, // dot 표시를 숨김
            ),
          ),
        ],
        titlesData: const FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false, // X축 레이블 숨기기
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false, // Y축 레이블 숨기기
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false), // 필요 시 위쪽 축도 숨길 수 있음
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false), // 필요 시 오른쪽 축도 숨길 수 있음
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black),
        ),
        gridData: const FlGridData(show: false),
      ),
    );
  }
}
