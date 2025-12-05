import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/currency_helper.dart';
import 'package:depozio/features/home/presentation/bloc/home_bloc.dart';
import 'package:depozio/core/enum/category_type.dart';
import 'package:depozio/core/bloc/app_core_bloc.dart';
import 'package:depozio/core/services/app_setting_service.dart';
import 'package:depozio/core/services/exchange_rate_service.dart';
import 'package:depozio/core/models/exchange_rate_response.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.theme,
    required this.colorScheme,
    required this.transaction,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final TransactionWithCategory transaction;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCoreBloc, AppCoreState>(
      buildWhen: (previous, current) {
        // Rebuild when currency changes
        if (previous is AppCoreSettingsLoaded &&
            current is AppCoreSettingsLoaded) {
          return previous.currencyCode != current.currencyCode;
        }
        return current is AppCoreSettingsLoaded ||
            current is AppCoreCurrencyLoaded;
      },
      builder: (context, appCoreState) {
        // Get selected currency
        String selectedCurrency;
        if (appCoreState is AppCoreSettingsLoaded) {
          selectedCurrency = appCoreState.currencyCode;
        } else if (appCoreState is AppCoreCurrencyLoaded) {
          selectedCurrency = appCoreState.currencyCode;
        } else {
          AppSettingService.init();
          selectedCurrency = AppSettingService.getDefaultCurrency();
        }

        // Check if conversion is needed
        final needsConversion =
            transaction.currencyCode.toUpperCase() !=
            selectedCurrency.toUpperCase();

        return _TransactionAmountDisplay(
          theme: theme,
          colorScheme: colorScheme,
          transaction: transaction,
          selectedCurrency: selectedCurrency,
          needsConversion: needsConversion,
        );
      },
    );
  }
}

class _TransactionAmountDisplay extends StatelessWidget {
  const _TransactionAmountDisplay({
    required this.theme,
    required this.colorScheme,
    required this.transaction,
    required this.selectedCurrency,
    required this.needsConversion,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final TransactionWithCategory transaction;
  final String selectedCurrency;
  final bool needsConversion;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    final formattedDate = dateFormat.format(transaction.createdAt);
    final formattedTime = timeFormat.format(transaction.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Category icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              transaction.categoryIcon,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.categoryName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (transaction.notes != null &&
                    transaction.notes!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    transaction.notes!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Amount with currency conversion
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildAmountDisplay(context),
              const SizedBox(height: 4),
              Text(
                '$formattedDate • $formattedTime',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountDisplay(BuildContext context) {
    if (!needsConversion) {
      // Same currency - show original amount
      return _buildAmountRow(transaction.currencyCode, transaction.amount);
    }

    // Different currency - convert and show
    return FutureBuilder<ExchangeRateResponse>(
      future: ExchangeRateService().convert(
        from: transaction.currencyCode,
        to: selectedCurrency,
        amount: transaction.amount,
        useCache: true,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show original while loading
          return _buildAmountRow(
            transaction.currencyCode,
            transaction.amount,
            isLoading: true,
          );
        }

        if (snapshot.hasError) {
          // On error, show original amount
          return _buildAmountRow(transaction.currencyCode, transaction.amount);
        }

        if (snapshot.hasData) {
          final convertedAmount = snapshot.data!.converted;
          // Show converted amount with original in smaller text
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildAmountRow(selectedCurrency, convertedAmount),
              const SizedBox(height: 2),
              // Show original amount in smaller text
              Text(
                '${CurrencyHelper.getFlag(transaction.currencyCode)} ${NumberFormat.currency(symbol: CurrencyHelper.getSymbol(transaction.currencyCode), decimalDigits: 2).format(transaction.amount)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
              ),
            ],
          );
        }

        // Fallback
        return _buildAmountRow(transaction.currencyCode, transaction.amount);
      },
    );
  }

  Widget _buildAmountRow(
    String currencyCode,
    double amount, {
    bool isLoading = false,
  }) {
    final currencySymbol = CurrencyHelper.getSymbol(currencyCode);
    final formattedAmount = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 2,
    ).format(amount);

    final categoryType = CategoryType.fromString(transaction.categoryType);
    final amountColor =
        categoryType == CategoryType.deposits
            ? Colors.green.shade700
            : categoryType == CategoryType.expenses
            ? Colors.red.shade700
            : colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Green icon for deposits
        if (categoryType == CategoryType.deposits) ...[
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.arrow_upward,
              size: 14,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(width: 6),
        ],
        // Red icon for expenses
        if (categoryType == CategoryType.expenses) ...[
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.arrow_downward,
              size: 14,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          CurrencyHelper.getFlag(currencyCode),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 6),
        if (isLoading)
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(amountColor),
            ),
          )
        else
          Text(
            formattedAmount,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: amountColor,
            ),
          ),
      ],
    );
  }
}
