import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/constants/quant_type.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/models/profile_stock_model/profile_stock_model.dart';
import 'package:quant_bot_flutter/pages/loading_pages/profile_info_skeleton.dart';
import 'package:quant_bot_flutter/providers/profile_provider.dart';
import 'package:quant_bot_flutter/pages/loading_pages/skeleton_list_loading.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStocks = ref.watch(profileStocksProvider);
    final profileInfo = ref.watch(profileInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: const Color(0xFFF0F0F0),
        child: Column(
          children: [
            profileInfo.when(
              data: (widget) => widget,
              loading: () => const ProfileInfoSkeleton(),
              error: (error, stack) => Text('프로필 정보 로딩 오류: $error'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: profileStocks.when(
                data: (stocks) => _buildStockList(stocks, ref),
                loading: () => const Center(child: SkeletonLoadingList()),
                error: (error, stack) => Center(
                  child: Text('오류가 발생했습니다: $error'),
                ),
              ),
            ),
            //여기
          ],
        ),
      ),
    );
  }

  Widget _buildStockList(List<ProfileStockModel> stocks, WidgetRef ref) {
    return ListView.builder(
      itemCount: stocks.length + 1,
      itemBuilder: (context, index) {
        if (index == stocks.length) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                context.push('/quant-form/strategy');
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: CustomColors.gray100,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '퀀트 추가하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: CustomColors.gray100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final stock = stocks[index];
        return InkWell(
          onTap: () {
            ref.read(profileStocksProvider.notifier).toggleNotification(stock);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stock.ticker,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stock.name,
                          style: TextStyle(
                              fontSize: 12, color: CustomColors.gray50),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: CustomColors.clearBlue120,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                QuantType.fromCode(stock.quantType).name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: stock.currentStatus == 'BUY'
                                    ? CustomColors.error.withOpacity(0.1)
                                    : CustomColors.clearBlue120
                                        .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                stock.currentStatus,
                                style: TextStyle(
                                  color: stock.currentStatus == 'BUY'
                                      ? CustomColors.error
                                      : CustomColors.clearBlue120,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "알림시 ${double.parse(stock.profit) >= 0 ? '수익' : '예방 손해'}",
                    style: TextStyle(
                      fontSize: 11,
                      color: CustomColors.gray50,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: double.parse(stock.profit) >= 0
                              ? CustomColors.error.withOpacity(0.1)
                              : CustomColors.clearBlue120.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '\$${stock.profit}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: double.parse(stock.profit) >= 0
                                    ? CustomColors.error
                                    : Colors.blue,
                              ),
                            ),
                            Text(
                              '${stock.profitPercent}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: double.parse(stock.profit) >= 0
                                    ? CustomColors.error
                                    : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color: stock.notification
                              ? CustomColors.brightYellow120
                              : CustomColors.gray50,
                          size: 32,
                        ),
                        onPressed: () {
                          ref
                              .read(profileStocksProvider.notifier)
                              .toggleNotification(stock);
                        },
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
