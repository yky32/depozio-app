import 'package:flutter/material.dart';

/// Enum representing the different pages in the app with their associated
/// 99 = NA, not for nav bar member.
enum AppPage {
  login("Login", "/login", Icons.login, 99),
  error("Error", "/error", Icons.error, 99),

  home("Home", "/home", Icons.home, 0),
  propertySearch("Property Search", "/property-search", Icons.search, 1),
  homeDashboard("Dashboard", "/home-dashboard", Icons.dashboard, 2),
  settings("Settings", "/settings", Icons.settings, 3);

  const AppPage(this.name, this.path, this.icon, this.navBarMemberIndex);

  final String name;
  final String path;
  final IconData icon;
  final int navBarMemberIndex;
}
