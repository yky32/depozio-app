import 'package:flutter/material.dart';

/// Enum representing the different pages in the app with their associated
/// 99 = NA, not for nav bar member.
enum AppPage {
  login("Login", "/login", Icons.login, 99),
  error("Error", "/error", Icons.error, 99),

  home("Home", "/home", Icons.home, 0),
  deposit("Deposit", "/deposit", Icons.account_balance_wallet, 1),
  analytics("Analytics", "/analytics", Icons.bar_chart, 2),
  setting("Setting", "/setting", Icons.settings, 3),
  fontTest("Font Test", "/font-test", Icons.text_fields, 99);

  const AppPage(this.name, this.path, this.icon, this.navBarMemberIndex);

  final String name;
  final String path;
  final IconData icon;
  final int navBarMemberIndex;
}
