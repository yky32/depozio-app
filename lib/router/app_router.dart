import 'package:sample_app/features/landing/presentation/pages/landing_page.dart';
import 'package:sample_app/router/app_page.dart';
import 'package:sample_app/features/home/presentation/pages/home_page.dart';
import 'package:sample_app/features/settings/presentation/pages/settings_page.dart';
import 'package:sample_app/features/login/presentation/pages/login_page.dart';
import 'package:sample_app/features/property_search/presentation/pages/property_search_page.dart';
import 'package:sample_app/features/home_dashboard/presentation/pages/home_dashboard_page.dart';
import 'package:sample_app/features/map_view/presentation/pages/map_view_page.dart';
import 'package:sample_app/widgets/scaffold_with_nav_bar.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        name: AppPage.landing.name,
        path: AppPage.landing.path,
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        name: AppPage.login.name,
        path: AppPage.login.path,
        builder: (context, state) => const LoginPage(),
      ),
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
                name: AppPage.mapView.name,
                path: AppPage.mapView.path,
                builder: (context, state) => const MapViewPage(),
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
    ],
  );
}
