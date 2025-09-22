import 'package:flutter/material.dart';

enum AppPage {
  landing("Landing", "/", Icon(Icons.home)),
  login("Login", "/login", Icon(Icons.login)),
  home("Home", "/home", Icon(Icons.home)),
  propertySearch("Property Search", "/property-search", Icon(Icons.search)),
  homeDashboard("Dashboard", "/home-dashboard", Icon(Icons.dashboard)),
  mapView("Map View", "/map-view", Icon(Icons.map)),
  settings("Settings", "/settings", Icon(Icons.settings));

  const AppPage(this.name, this.path, this.icon);

  final String name;
  final String path;
  final Icon icon;
}
