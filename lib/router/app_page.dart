import 'package:flutter/material.dart';

/// 99 = NA
enum AppPage {
  landing("Landing", "/", Icons.home, 99),
  login("Login", "/login", Icons.login, 99),
  home("Home", "/home", Icons.home, 0),
  propertySearch("Property Search", "/property-search", Icons.search, 1),
  homeDashboard("Dashboard", "/home-dashboard", Icons.dashboard, 2),
  settings("Settings", "/settings", Icons.settings, 3);

  const AppPage(this.name, this.path, this.icon, this.navItemIndex);

  final String name;
  final String path;
  final IconData icon;
  final int navItemIndex;
}
