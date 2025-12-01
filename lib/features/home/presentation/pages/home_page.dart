import 'package:depozio/core/extensions/localizations.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.home_page_title,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              // Total Savings Card
              _buildTotalSavingsCard(
                context: context,
                theme: theme,
                colorScheme: colorScheme,
                l10n: l10n,
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
                  _buildStatisticCard(
                    context: context,
                    theme: theme,
                    colorScheme: colorScheme,
                    title: l10n.home_page_deposits,
                    value: '0',
                    icon: Icons.account_balance_wallet,
                  ),
                  _buildStatisticCard(
                    context: context,
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
              _buildSavingsGoalCard(
                context: context,
                theme: theme,
                colorScheme: colorScheme,
                l10n: l10n,
              ),
              const SizedBox(height: 24),
              // Monthly Savings
              _buildMonthlySavingsCard(
                context: context,
                theme: theme,
                colorScheme: colorScheme,
                l10n: l10n,
              ),
              const SizedBox(height: 24),
              // Recent Activity
              _buildRecentActivitySection(
                context: context,
                theme: theme,
                colorScheme: colorScheme,
                l10n: l10n,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticCard({
    required BuildContext context,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSavingsCard({
    required BuildContext context,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required dynamic l10n,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.savings, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Text(
                l10n.home_page_total_savings,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '\$0.00',
            style: theme.textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsGoalCard({
    required BuildContext context,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required dynamic l10n,
  }) {
    final progress = 0.0; // Placeholder: 0% progress
    final goalAmount = 10000.0; // Placeholder goal
    final currentAmount = 0.0; // Placeholder current

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.track_changes,
                  color: colorScheme.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.home_page_savings_goal,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${currentAmount.toStringAsFixed(0)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${goalAmount.toStringAsFixed(0)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.secondary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySavingsCard({
    required BuildContext context,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required dynamic l10n,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.calendar_month,
              color: colorScheme.tertiary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.home_page_monthly_savings,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$0.00',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection({
    required BuildContext context,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required dynamic l10n,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.home_page_recent_activity,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.home_page_no_activity,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
