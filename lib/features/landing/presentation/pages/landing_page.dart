import 'package:flutter/material.dart';
import 'package:depozio/router/app_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(AppPage.landing.name),
      ),
    );
  }
}
