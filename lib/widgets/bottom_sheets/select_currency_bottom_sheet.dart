import 'package:flutter/material.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/currency_helper.dart';

/// Bottom sheet for selecting a currency from a list
/// Common reusable widget - used across multiple features
class SelectCurrencyBottomSheet extends StatelessWidget {
  const SelectCurrencyBottomSheet({
    super.key,
    required this.currentCurrency,
    this.title,
    this.maxHeightPercentage = 0.5,
  });

  /// Currently selected currency code
  final String currentCurrency;

  /// Title text for the bottom sheet. If null, uses default localized text.
  final String? title;

  /// Maximum height as a percentage of screen height (0.0 to 1.0)
  /// Default is 0.5 (50%)
  final double maxHeightPercentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    final availableHeight = screenHeight - keyboardHeight;
    final maxHeight = (screenHeight * maxHeightPercentage).clamp(
      0.0,
      availableHeight,
    );

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              alignment: Alignment.center,
              child: Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Text(
              title ?? l10n.transaction_select_currency,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              itemCount: CurrencyHelper.currencies.length,
              itemBuilder: (context, index) {
                final currencyCode = CurrencyHelper.currencies.keys.elementAt(
                  index,
                );
                final flag = CurrencyHelper.getFlag(currencyCode);
                final symbol = CurrencyHelper.getSymbol(currencyCode);
                final currencyName = CurrencyHelper.getName(currencyCode, l10n);
                final isSelected = currentCurrency == currencyCode;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(currencyCode),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? colorScheme.primary.withValues(alpha: 0.1)
                                : colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              isSelected
                                  ? colorScheme.primary
                                  : colorScheme.outline.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(flag, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currencyName,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                    color:
                                        isSelected
                                            ? colorScheme.primary
                                            : colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$currencyCode • $symbol',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: colorScheme.primary,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
