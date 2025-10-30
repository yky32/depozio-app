import 'package:depozio/features/home/presentation/pages/home_page.dart';
import 'package:depozio/features/home_dashboard/presentation/pages/home_dashboard_page.dart';
import 'package:depozio/features/login/presentation/pages/login_page.dart';
import 'package:depozio/features/property_search/presentation/pages/property_search_page.dart';
import 'package:depozio/features/settings/presentation/pages/settings_page.dart';
import 'package:depozio/router/app_page.dart';
import 'package:depozio/widgets/scaffold_with_nav_bar.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/home',
    routes: [
      // *** Apps Routes
      // *** Apps Routes
      GoRoute(
        name: AppPage.login.name,
        path: AppPage.login.path,
        builder: (context, state) => const LoginPage(),
      ),
      // *** Apps Routes END
      // *** Apps Routes END

      // *** Navigation Bar
      // *** Navigation Bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppPage.home.name,
                path: AppPage.home.path,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppPage.propertySearch.name,
                path: AppPage.propertySearch.path,
                builder: (context, state) => const PropertySearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppPage.homeDashboard.name,
                path: AppPage.homeDashboard.path,
                builder: (context, state) => const HomeDashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppPage.settings.name,
                path: AppPage.settings.path,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
      // *** Navigation Bar END
      // *** Navigation Bar END
    ],
  );
}
