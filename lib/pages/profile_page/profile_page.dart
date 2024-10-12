import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/constants/quant_type.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/models/profile_stock_model/profile_stock_model.dart';
import 'package:quant_bot_flutter/pages/loading_pages/profile_info_skeleton.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import 'package:quant_bot_flutter/providers/profile_provider.dart';
import 'package:quant_bot_flutter/pages/loading_pages/skeleton_list_loading.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStocks = ref.watch(profileStocksProvider);
    final authStorageNotifier = ref.read(authStorageProvider.notifier);

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
            FutureBuilder<Widget>(
              future: _buildProfileInfo(authStorageNotifier),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data ?? const SizedBox();
                }
                return const ProfileInfoSkeleton();
              },
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
          ],
        ),
      ),
    );
  }

  Future<Widget> _buildProfileInfo(
      AuthStorageNotifier authStorageNotifier) async {
    final user = await authStorageNotifier.findUserByAuth();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: CustomColors.gray40,
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.userName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(user.email,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockList(List<ProfileStockModel> stocks, WidgetRef ref) {
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return InkWell(
          onTap: () {
            ref
                .read(profileStocksProvider.notifier)
                .toggleNotification(stock.ticker);
            CustomToast.show(
                message:
                    '${stock.name} 알림 : ${stock.notification ? 'Off' : 'On'}');
          },
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 1),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stock.ticker,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(stock.name,
                        style: TextStyle(
                            fontSize: 14, color: CustomColors.gray50)),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: stock.quantType == QuantType.TREND_FOLLOW.code
                            ? CustomColors.clearBlue120
                            : CustomColors.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        QuantType.fromCode(stock.quantType).name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: stock.notification
                            ? CustomColors.clearBlue120
                            : CustomColors.gray50,
                      ),
                      onPressed: () {
                        ref
                            .read(profileStocksProvider.notifier)
                            .toggleNotification(stock.ticker);
                        CustomToast.show(
                            message:
                                '${stock.name} 알림 : ${stock.notification ? 'Off' : 'On'}');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
