import 'package:flutter/material.dart';
import 'package:depozio/core/extensions/localizations.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            l10n.analytics_page_coming_soon,
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 48,
            ),
          ),
        ),
      ),
    );
  }
}
