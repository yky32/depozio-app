import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/features/home/presentation/bloc/home_bloc.dart';
import 'package:depozio/core/bloc/app_core_bloc.dart';
import 'package:depozio/core/services/app_setting_service.dart';
import 'package:depozio/features/home/presentation/pages/widgets/total_savings_card.dart';
import 'package:depozio/features/home/presentation/pages/widgets/statistic_card.dart';
import 'package:depozio/features/home/presentation/pages/widgets/savings_goal_card.dart';
import 'package:depozio/features/home/presentation/pages/widgets/monthly_savings_card.dart';
import 'package:depozio/features/home/presentation/pages/widgets/recent_activity_section.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/currency_helper.dart';
import 'package:intl/intl.dart';

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
    // Get total deposits and expenses from state
    final totalDeposits =
        state is HomeLoaded ? (state as HomeLoaded).totalDeposits : 0.0;
    final totalExpenses =
        state is HomeLoaded ? (state as HomeLoaded).totalExpenses : 0.0;

    // Calculate total savings (deposits - expenses)
    final totalSavings = totalDeposits - totalExpenses;

    return BlocBuilder<AppCoreBloc, AppCoreState>(
      buildWhen: (previous, current) {
        // Rebuild when currency changes
        if (previous is AppCoreSettingsLoaded &&
            current is AppCoreSettingsLoaded) {
          return previous.currencyCode != current.currencyCode;
        }
        // Rebuild when transitioning to settings loaded state
        return current is AppCoreSettingsLoaded ||
            current is AppCoreCurrencyLoaded;
      },
      builder: (context, appCoreState) {
        // Load currency if not already loaded
        if (appCoreState is! AppCoreSettingsLoaded &&
            appCoreState is! AppCoreCurrencyLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AppCoreBloc>().add(const LoadCurrency());
          });
        }

        // Get current currency from state or fallback to service
        String currencyCode;
        if (appCoreState is AppCoreSettingsLoaded) {
          currencyCode = appCoreState.currencyCode;
        } else if (appCoreState is AppCoreCurrencyLoaded) {
          currencyCode = appCoreState.currencyCode;
        } else {
          AppSettingService.init();
          currencyCode = AppSettingService.getDefaultCurrency();
        }

        final currencySymbol = CurrencyHelper.getSymbol(currencyCode);
        final formattedDeposits = NumberFormat.currency(
          symbol: currencySymbol,
          decimalDigits: 2,
        ).format(totalDeposits);
        final formattedExpenses = NumberFormat.currency(
          symbol: currencySymbol,
          decimalDigits: 2,
        ).format(totalExpenses);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Savings Card
            TotalSavingsCard(
              theme: theme,
              colorScheme: colorScheme,
              l10n: l10n,
              amount: totalSavings,
            ),
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
                  value: formattedDeposits,
                  icon: Icons.account_balance_wallet,
                  valueColor: Colors.green.shade700,
                  topRightIcon: Icons.arrow_upward,
                  topRightIconColor: Colors.green.shade700,
                  topRightIconBackgroundColor: Colors.green.withValues(
                    alpha: 0.1,
                  ),
                ),
                StatisticCard(
                  theme: theme,
                  colorScheme: colorScheme,
                  title: l10n.home_page_expenses,
                  value: formattedExpenses,
                  icon: Icons.receipt_long,
                  valueColor: Colors.red.shade700,
                  topRightIcon: Icons.arrow_downward,
                  topRightIconColor: Colors.red.shade700,
                  topRightIconBackgroundColor: Colors.red.withValues(
                    alpha: 0.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Savings Goal Progress
            SavingsGoalCard(theme: theme, colorScheme: colorScheme, l10n: l10n),
            const SizedBox(height: 24),
            // Monthly Savings
            MonthlySavingsCard(
              theme: theme,
              colorScheme: colorScheme,
              l10n: l10n,
            ),
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
      },
    );
  }
}
