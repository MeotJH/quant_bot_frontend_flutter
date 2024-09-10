import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonTrendFollowLoading extends StatelessWidget {
  static const String stockInfoSkeleton = 'StockInfoSkeleton';
  static const String stockChartSkeleton = 'StockChartSkeleton';
  static const String trendFollowCardSkeleton = 'TrendFollowCardSkeleton';
  static const String stockInfoCardSkeleton = 'StockDetailInfoSkeleton';

  final String skeletonName;
  const SkeletonTrendFollowLoading({super.key, required this.skeletonName});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SkeletonItems(
        skeletonName: skeletonName,
      ),
    );
  }
}

class SkeletonItems extends StatelessWidget {
  final String skeletonName;
  SkeletonItems({super.key, required this.skeletonName});

  final Map<String, Widget> skeletonMap = {
    SkeletonTrendFollowLoading.stockInfoSkeleton: const StockInfoSkeleton(),
    SkeletonTrendFollowLoading.stockChartSkeleton: const StockChartSkeleton(),
    SkeletonTrendFollowLoading.trendFollowCardSkeleton: const StockContainerSkeleton(),
    SkeletonTrendFollowLoading.stockInfoCardSkeleton: const StockContainerSkeleton(),
  };
  @override
  Widget build(BuildContext context) {
    return skeletonMap[skeletonName] ?? const StockInfoSkeleton();
  }
}

class StockInfoSkeleton extends StatelessWidget {
  const StockInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          width: 100,
          height: 16,
          color: Colors.white,
        ),
        Container(
          margin: const EdgeInsets.all(8),
          width: 50,
          height: 16,
          color: Colors.white,
        ),
        Container(
          margin: const EdgeInsets.all(8),
          width: 180,
          height: 32,
          color: Colors.white,
        ),
        Container(
          margin: const EdgeInsets.all(8),
          width: 30,
          height: 12,
          color: Colors.white,
        ),
      ],
    );
  }
}

class StockChartSkeleton extends StatelessWidget {
  const StockChartSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          height: 300,
          color: Colors.white,
        ),
      ],
    );
  }
}

class StockContainerSkeleton extends StatelessWidget {
  const StockContainerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 128.0,
                  height: 16.0,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 64.0,
                  height: 16.0,
                  color: Colors.white,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 128.0,
                  height: 16.0,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 64.0,
                  height: 16.0,
                  color: Colors.white,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 128.0,
                  height: 16.0,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 64.0,
                  height: 16.0,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 128.0,
                  height: 16.0,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 64.0,
                  height: 16.0,
                  color: Colors.white,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 128.0,
                  height: 16.0,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 64.0,
                  height: 16.0,
                  color: Colors.white,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 128.0,
                  height: 16.0,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 64.0,
                  height: 16.0,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
