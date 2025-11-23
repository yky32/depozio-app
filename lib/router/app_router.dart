import 'package:depozio/features/home/presentation/pages/home_page.dart';
import 'package:depozio/features/deposit/presentation/pages/deposit_page.dart';
import 'package:depozio/features/analytics/presentation/pages/analytics_page.dart';
import 'package:depozio/features/login/presentation/pages/login_page.dart';
import 'package:depozio/features/setting/presentation/pages/setting_page.dart';
import 'package:depozio/router/app_page.dart';
import 'package:depozio/widgets/scaffold_with_nav_bar.dart';
import 'package:depozio/widgets/splash_screen.dart';
import 'package:depozio/widgets/font_test_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  // Page widget mapping
  static final Map<AppPage, Widget Function()> _appPages = {
    AppPage.home: () => const HomePage(),
    AppPage.deposit: () => const DepositPage(),
    AppPage.analytics: () => const AnalyticsPage(),
    AppPage.setting: () => const SettingPage(),
  };

  // Standalone page widgets (non-navigation pages)
  static final Map<AppPage, Widget Function()> _standaloneAppPages = {
    AppPage.login: () => const LoginPage(),
    AppPage.fontTest: () => const FontTestPage(),
  };

  // Generate navigation branches dynamically
  static List<StatefulShellBranch> get _navigationBranches {
    final navigationPages = AppPage.values
        .where(
            (page) => page.navBarMemberIndex != 99) // Filter out non-nav pages
        .toList()
      ..sort((a, b) => a.navBarMemberIndex
          .compareTo(b.navBarMemberIndex)); // Sort by navBarMemberIndex ASC

    return navigationPages
        .map((page) => StatefulShellBranch(
              routes: [
                GoRoute(
                  name: page.name,
                  path: page.path,
                  builder: (context, state) => _appPages[page]!(),
                ),
              ],
            ))
        .toList();
  }

  // Generate standalone routes dynamically
  static List<GoRoute> get _standaloneRoutes {
    final standalonePages = AppPage.values
        .where((page) => page.navBarMemberIndex == 99) // Filter non-nav pages
        .toList()
      ..sort((a, b) => a.navBarMemberIndex
          .compareTo(b.navBarMemberIndex)); // Sort by navBarMemberIndex ASC

    return standalonePages
        .map((page) => GoRoute(
              name: page.name,
              path: page.path,
              builder: (context, state) => _standaloneAppPages[page]!(),
            ))
        .toList();
  }

  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash screen route
      GoRoute(
        name: 'splash',
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // Standalone routes (non-navigation pages)
      ..._standaloneRoutes,

      // Navigation shell route
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(
            navigationShell: navigationShell,
          );
        },
        branches: _navigationBranches,
      ),
    ],
  );
}
