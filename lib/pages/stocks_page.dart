import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/components/custom_dialog_dropdown.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/core/utils.dart';
import 'package:quant_bot_flutter/providers/stocks_provider.dart';

class StockListPage extends ConsumerStatefulWidget {
  const StockListPage({super.key});

  @override
  ConsumerState<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends ConsumerState<StockListPage> {
  final String _ticker = '';

  @override
  Widget build(BuildContext context) {
    final stocks = ref.watch(stocksProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock List'),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: const Color(0xFFF0F0F0),
          child: Column(
            children: [
              Container(
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: stocks.when(
                    data: (stocks) {
                      return ListView.builder(
                        itemCount: stocks.length,
                        itemBuilder: (context, index) {
                          final stock = stocks[index];
                          return InkWell(
                            onTap: () async {
                              final item =
                                  await CustomDialogDropDown.showCustomDialog(
                                      context);
                              context
                                  .push('/quants/${item.code}/${stock.ticker}');
                            },
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 1),
                              height: 90,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          stock.ticker,
                                          style: const TextStyle(
                                            color: Color(0xFF222222),
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            stock.name,
                                            style: TextStyle(
                                              color: CustomColors.gray50,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          height: 32,
                                          width: 100,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: ShapeDecoration(
                                            color: stock.pctchange.contains('-')
                                                ? CustomColors.success
                                                : CustomColors.error,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                          ),
                                          child: Text(
                                            '\$${double.parse(stock.lastsale.replaceAll('\$', '')).toStringAsFixed(2)}', //상태
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    error: (error, stack) => Center(
                          child: Container(
                              alignment: Alignment.center,
                              color: CustomColors.white,
                              child: const Text(
                                  '문제가 생겼습니다. \n 금방 조치할테니 조금만 기다려주세요.',
                                  textAlign: TextAlign.center)),
                        ),
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        )),
              ),
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_rounded),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Home',
          ),
        ],
      ),
    );
  }
}