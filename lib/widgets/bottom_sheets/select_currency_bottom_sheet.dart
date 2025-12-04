import 'package:flutter/material.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/core/services/app_setting_service.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/currency_helper.dart';

/// Bottom sheet for selecting a currency from a list
/// Common reusable widget - used across multiple features
class SelectCurrencyBottomSheet extends StatefulWidget {
  const SelectCurrencyBottomSheet({
    super.key,
    required this.currentCurrency,
    this.title,
  });

  /// Currently selected currency code
  final String currentCurrency;

  /// Title text for the bottom sheet. If null, uses default localized text.
  final String? title;

  @override
  State<SelectCurrencyBottomSheet> createState() =>
      _SelectCurrencyBottomSheetState();
}

class _SelectCurrencyBottomSheetState
    extends State<SelectCurrencyBottomSheet> {
  bool _isReorderMode = false;
  late List<String> _currencyOrder;

  @override
  void initState() {
    super.initState();
    _loadCurrencyOrder();
  }

  void _loadCurrencyOrder() {
    AppSettingService.init();
    final savedOrder = AppSettingService.getCurrencyOrder();
    if (savedOrder != null && savedOrder.length == CurrencyHelper.currencies.length) {
      // Validate that all currencies are present
      final allCurrencies = CurrencyHelper.currencies.keys.toSet();
      final savedSet = savedOrder.toSet();
      if (allCurrencies.difference(savedSet).isEmpty) {
        _currencyOrder = List.from(savedOrder);
        return;
      }
    }
    // Default order: use the order from CurrencyHelper
    _currencyOrder = CurrencyHelper.currencies.keys.toList();
  }

  Future<void> _saveCurrencyOrder() async {
    await AppSettingService.saveCurrencyOrder(_currencyOrder);
  }

  void _toggleReorderMode() {
    setState(() {
      _isReorderMode = !_isReorderMode;
      if (!_isReorderMode) {
        // Save order when exiting reorder mode
        _saveCurrencyOrder();
      }
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _currencyOrder.removeAt(oldIndex);
      _currencyOrder.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    // Calculate dynamic height based on content
    // Header: drag handle (16*2) + title padding (16+24) + title height (~24) = ~80
    // Each item: bottom padding (12) + container padding (16*2) + content (~80) = ~124
    // Bottom padding: 24
    const headerHeight = 80.0;
    const itemHeight =
        124.0; // More accurate: 12 padding + 32 container padding + 80 content
    const bottomPadding = 24.0;
    final itemCount = _currencyOrder.length;
    final contentHeight =
        headerHeight + (itemCount * itemHeight) + bottomPadding;

    // Use 90% max, but use actual content height if smaller
    final maxScreenHeight = screenHeight * 0.9;
    final availableHeight = screenHeight - keyboardHeight;
    final dynamicHeight = contentHeight.clamp(
      0.0,
      maxScreenHeight.clamp(0.0, availableHeight),
    );

    return Container(
      height: dynamicHeight,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
            child: Text(
                    widget.title ?? l10n.transaction_select_currency,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
                  ),
                ),
                IconButton(
                  onPressed: _toggleReorderMode,
                  icon: Icon(
                    _isReorderMode ? Icons.check : Icons.drag_handle,
                    color: _isReorderMode
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                  tooltip: _isReorderMode ? 'Done' : 'Reorder',
                ),
              ],
            ),
          ),
          Expanded(
            child: _isReorderMode
                ? ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    itemCount: _currencyOrder.length,
                    onReorder: _onReorder,
              itemBuilder: (context, index) {
                      final currencyCode = _currencyOrder[index];
                      final flag = CurrencyHelper.getFlag(currencyCode);
                      final symbol = CurrencyHelper.getSymbol(currencyCode);
                      final currencyName =
                          CurrencyHelper.getName(currencyCode, l10n);

                      return _buildCurrencyItem(
                        key: ValueKey(currencyCode),
                        currencyCode: currencyCode,
                        flag: flag,
                        symbol: symbol,
                        currencyName: currencyName,
                        theme: theme,
                        colorScheme: colorScheme,
                        isReorderMode: true,
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    itemCount: _currencyOrder.length,
                    itemBuilder: (context, index) {
                      final currencyCode = _currencyOrder[index];
                final flag = CurrencyHelper.getFlag(currencyCode);
                final symbol = CurrencyHelper.getSymbol(currencyCode);
                      final currencyName =
                          CurrencyHelper.getName(currencyCode, l10n);
                      final isSelected = widget.currentCurrency == currencyCode;

                      return _buildCurrencyItem(
                        key: ValueKey(currencyCode),
                        currencyCode: currencyCode,
                        flag: flag,
                        symbol: symbol,
                        currencyName: currencyName,
                        theme: theme,
                        colorScheme: colorScheme,
                        isReorderMode: false,
                        isSelected: isSelected,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyItem({
    required Key key,
    required String currencyCode,
    required String flag,
    required String symbol,
    required String currencyName,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required bool isReorderMode,
    bool isSelected = false,
  }) {
                return Padding(
      key: key,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
        onTap: isReorderMode
            ? null
            : () => Navigator.of(context).pop(currencyCode),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
            color: isSelected
                                ? colorScheme.primary.withValues(alpha: 0.1)
                                : colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.outline.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
              if (isReorderMode)
                Icon(
                  Icons.drag_handle,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              if (isReorderMode) const SizedBox(width: 8),
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
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$currencyCode • $symbol',
                                  style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
              if (isSelected && !isReorderMode)
                            Icon(
                              Icons.check_circle,
                              color: colorScheme.primary,
                            ),
                        ],
                      ),
                    ),
      ),
    );
  }
}
