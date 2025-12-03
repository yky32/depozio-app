import 'package:flutter/material.dart';
import 'package:depozio/features/home/presentation/bloc/home_bloc.dart';
import 'package:depozio/features/home/presentation/pages/widgets/total_savings_card.dart';
import 'package:depozio/features/home/presentation/pages/widgets/statistic_card.dart';
import 'package:depozio/features/home/presentation/pages/widgets/savings_goal_card.dart';
import 'package:depozio/features/home/presentation/pages/widgets/monthly_savings_card.dart';
import 'package:depozio/features/home/presentation/pages/widgets/recent_activity_section.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.theme,
    required this.colorScheme,
    required this.l10n,
    required this.state,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total Savings Card
        TotalSavingsCard(theme: theme, colorScheme: colorScheme, l10n: l10n),
        const SizedBox(height: 24),
        // Grid with 2 columns
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.25,
          children: [
            StatisticCard(
              theme: theme,
              colorScheme: colorScheme,
              title: l10n.home_page_deposits,
              value: '0',
              icon: Icons.account_balance_wallet,
            ),
            StatisticCard(
              theme: theme,
              colorScheme: colorScheme,
              title: l10n.home_page_expenses,
              value: '0',
              icon: Icons.receipt_long,
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Savings Goal Progress
        SavingsGoalCard(theme: theme, colorScheme: colorScheme, l10n: l10n),
        const SizedBox(height: 24),
        // Monthly Savings
        MonthlySavingsCard(theme: theme, colorScheme: colorScheme, l10n: l10n),
        const SizedBox(height: 24),
        // Recent Activity
        RecentActivitySection(
          theme: theme,
          colorScheme: colorScheme,
          l10n: l10n,
          state: state,
        ),
      ],
    );
  }
}
