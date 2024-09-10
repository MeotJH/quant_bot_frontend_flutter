import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/pages/login_page.dart';
import 'package:quant_bot_flutter/pages/quant_page/quant_page.dart';
import 'package:quant_bot_flutter/pages/stocks_page/stocks_page.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import '../pages/profile_page/profile_page.dart';

class RouteNotifier extends Notifier<GoRouter> {
  late final GoRouter _router;

  RouteNotifier() {
    _router = GoRouter(
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            // 공통 Scaffold와 BottomNavigationBar 추가
            return ScaffoldWithNavBar(state: state, child: child);
          },
          routes: _buildRoutes(),
        ),
      ],
      initialLocation: _initialLocation,
    );
  }

  static const String _initialLocation = '/';
  static const String _stockListPath = '/';
  static const String _quantPath = '/quants/:quant/:ticker';
  static const String _profilePath = '/profile';
  static const String _loginPath = '/login';

  List<GoRoute> _buildRoutes() => [
        GoRoute(
          path: _stockListPath,
          builder: (context, state) => const StockListPage(),
        ),
        GoRoute(
          path: _quantPath,
          builder: (context, state) {
            final String ticker = state.pathParameters['ticker']!;
            final String quant = state.pathParameters['quant']!;
            return QuantPage(ticker: ticker, quant: quant);
          },
        ),
        GoRoute(
          path: _profilePath,
          builder: (context, state) {
            final String? token = ref.read(authProvider).when(
                data: (data) => data,
                error: (e, a) => null,
                loading: () => null);

            if (token == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                GoRouter.of(context).go('/login');
              });
              return const SizedBox.shrink();
            }

            return const ProfilePage();
          },
        ),
        GoRoute(
          path: _loginPath,
          builder: (context, state) => const LoginScreen(),
        ),
      ];

  @override
  GoRouter build() => _router;
}

class ScaffoldWithNavBar extends ConsumerStatefulWidget {
  final Widget child;
  final GoRouterState state;

  const ScaffoldWithNavBar(
      {super.key, required this.child, required this.state});

  @override
  ConsumerState<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends ConsumerState<ScaffoldWithNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: isLoginPage()
          ? null // 로그인 페이지 일떄는 BottomNavigationBar를 숨김
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              selectedItemColor: CustomColors.black,
              unselectedItemColor: CustomColors.gray40,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });

                switch (index) {
                  case 0:
                    context.go('/');
                    break;
                  case 1:
                    context.go('/profile');
                    break;
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.show_chart_rounded),
                  label: 'Stocks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
    );
  }

  bool isLoginPage() {
    final path = widget.state.fullPath;
    const String loginPath = '/login';
    bool hideBottomNav = path == loginPath;
    return hideBottomNav;
  }
}

final routeProvider =
    NotifierProvider<RouteNotifier, GoRouter>(RouteNotifier.new);
