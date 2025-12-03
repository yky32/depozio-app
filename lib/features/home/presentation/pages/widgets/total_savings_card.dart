import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/currency_helper.dart';
import 'package:depozio/core/bloc/app_core_bloc.dart';
import 'package:depozio/core/services/app_setting_service.dart';
import 'package:intl/intl.dart';

class TotalSavingsCard extends StatelessWidget {
  const TotalSavingsCard({
    super.key,
    required this.theme,
    required this.colorScheme,
    required this.l10n,
    required this.amount,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n;
  final double amount;

  /// Get emoji based on saving amount
  /// Ranges:
  /// - Very sad: < -10000
  /// - Sad: -10000 to 0
  /// - Normal: 0 to 5000
  /// - Happy: 5000 to 20000
  /// - Very happy: > 20000
  String _getSavingEmoji(double amount) {
    if (amount < -10000) {
      return '😢'; // Very sad
    } else if (amount < 0) {
      return '😟'; // Sad
    } else if (amount <= 5000) {
      return '😐'; // Normal
    } else if (amount <= 20000) {
      return '😊'; // Happy
    } else {
      return '😄'; // Very happy
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // Title section (left)
              Text(
                l10n.home_page_total_savings,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Spacer to push flag to center
              const Spacer(),
              // Currency flag from AppCoreBloc (centered between title and emoji)
              BlocBuilder<AppCoreBloc, AppCoreState>(
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
                builder: (context, state) {
                  // Load currency if not already loaded
                  if (state is! AppCoreSettingsLoaded &&
                      state is! AppCoreCurrencyLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<AppCoreBloc>().add(const LoadCurrency());
                    });
                  }

                  // Get current currency from state or fallback to service
                  String currentCurrency;
                  if (state is AppCoreSettingsLoaded) {
                    currentCurrency = state.currencyCode;
                  } else if (state is AppCoreCurrencyLoaded) {
                    currentCurrency = state.currencyCode;
                  } else {
                    AppSettingService.init();
                    currentCurrency = AppSettingService.getDefaultCurrency();
                  }

                  final flag = CurrencyHelper.getFlag(currentCurrency);

                  return Text(flag, style: const TextStyle(fontSize: 24));
                },
              ),
              // Spacer to balance and push emoji to right
              const Spacer(),
              // Emoji indicator in top right corner
              Text(
                _getSavingEmoji(amount),
                style: const TextStyle(fontSize: 32),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Format total savings as currency from AppCoreBloc
          BlocBuilder<AppCoreBloc, AppCoreState>(
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
            builder: (context, state) {
              // Load currency if not already loaded
              if (state is! AppCoreSettingsLoaded &&
                  state is! AppCoreCurrencyLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<AppCoreBloc>().add(const LoadCurrency());
                });
              }

              // Get current currency from state or fallback to service
              String currencyCode;
              if (state is AppCoreSettingsLoaded) {
                currencyCode = state.currencyCode;
              } else if (state is AppCoreCurrencyLoaded) {
                currencyCode = state.currencyCode;
              } else {
                AppSettingService.init();
                currencyCode = AppSettingService.getDefaultCurrency();
              }

              final currencySymbol = CurrencyHelper.getSymbol(currencyCode);
              final formattedSavings = NumberFormat.currency(
                symbol: currencySymbol,
                decimalDigits: 2,
              ).format(amount);

              // Color based on amount: green for positive, red for negative
              final amountColor =
                  amount >= 0
                      ? Colors
                          .green
                          .shade400 // Green for positive amounts
                      : Colors.red.shade400; // Red for negative amounts

              return Text(
                formattedSavings,
                style: theme.textTheme.displayLarge?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: amountColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
