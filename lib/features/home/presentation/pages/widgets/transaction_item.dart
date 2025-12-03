import 'package:flutter/material.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/currency_helper.dart';
import 'package:depozio/features/home/presentation/bloc/home_bloc.dart';
import 'package:depozio/core/enum/category_type.dart';
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
    final currencySymbol = CurrencyHelper.getSymbol(transaction.currencyCode);
    final formattedAmount = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 2,
    ).format(transaction.amount);

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
          // Amount with currency flag and date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Green icon for deposits (money coming in)
                  if (CategoryType.fromString(transaction.categoryType) ==
                      CategoryType.deposits) ...[
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
                  // Red icon for expenses (money going out)
                  if (CategoryType.fromString(transaction.categoryType) ==
                      CategoryType.expenses) ...[
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
                    CurrencyHelper.getFlag(transaction.currencyCode),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formattedAmount,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          CategoryType.fromString(transaction.categoryType) ==
                                  CategoryType.deposits
                              ? Colors.green.shade700
                              : CategoryType.fromString(
                                    transaction.categoryType,
                                  ) ==
                                  CategoryType.expenses
                              ? Colors.red.shade700
                              : colorScheme.primary,
                    ),
                  ),
                ],
              ),
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
}
