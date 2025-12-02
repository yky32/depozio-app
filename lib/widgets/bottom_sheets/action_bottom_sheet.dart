import 'package:flutter/material.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';
import 'package:depozio/features/deposit/presentation/widgets/select_category_bottom_sheet.dart';

/// Bottom sheet that appears when the nav bar action button is clicked
/// Used for recording transactions (amount + category)
class ActionBottomSheet extends StatelessWidget {
  const ActionBottomSheet({super.key, this.maxHeightPercentage = 0.9});

  /// Maximum height as a percentage of screen height (0.0 to 1.0)
  /// Default is 0.9 (90%)
  final double maxHeightPercentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
              'Record Transaction',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: _TransactionFormContent(
              theme: theme,
              colorScheme: colorScheme,
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal widget that maintains transaction form state
class _TransactionFormContent extends StatefulWidget {
  const _TransactionFormContent({
    required this.theme,
    required this.colorScheme,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  State<_TransactionFormContent> createState() =>
      _TransactionFormContentState();
}

class _TransactionFormContentState extends State<_TransactionFormContent> {
  late final TextEditingController _amountController;
  late final FocusNode _amountFocusNode;
  late final ValueNotifier<CategoryModel?> _selectedCategoryNotifier;
  late final ValueNotifier<String> _selectedCurrencyNotifier;

  // Supported currencies with flags
  static const Map<String, String> _currencies = {
    'USD': '🇺🇸', // US Dollar
    'EUR': '🇪🇺', // Euro
    'GBP': '🇬🇧', // British Pound
    'JPY': '🇯🇵', // Japanese Yen
    'CNY': '🇨🇳', // Chinese Yuan
    'HKD': '🇭🇰', // Hong Kong Dollar
    'SGD': '🇸🇬', // Singapore Dollar
    'THB': '🇹🇭', // Thai Baht
    'KRW': '🇰🇷', // South Korean Won
    'AUD': '🇦🇺', // Australian Dollar
    'CAD': '🇨🇦', // Canadian Dollar
  };

  static const Map<String, String> _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CNY': '¥',
    'HKD': 'HK\$',
    'SGD': 'S\$',
    'THB': '฿',
    'KRW': '₩',
    'AUD': 'A\$',
    'CAD': 'C\$',
  };

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _amountFocusNode = FocusNode();
    _selectedCategoryNotifier = ValueNotifier<CategoryModel?>(null);
    _selectedCurrencyNotifier = ValueNotifier<String>('USD');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    _selectedCategoryNotifier.dispose();
    _selectedCurrencyNotifier.dispose();
    super.dispose();
  }

  void _showCurrencySelector() {
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          decoration: BoxDecoration(
            color: widget.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  width: 80,
                  height: 4,
                  decoration: BoxDecoration(
                    color: widget.colorScheme.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Text(
                  'Select Currency',
                  style: widget.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  itemCount: _currencies.length,
                  itemBuilder: (context, index) {
                    final currencyCode = _currencies.keys.elementAt(index);
                    final flag = _currencies[currencyCode]!;
                    final symbol = _currencySymbols[currencyCode]!;
                    final isSelected =
                        _selectedCurrencyNotifier.value == currencyCode;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          _selectedCurrencyNotifier.value = currencyCode;
                          Navigator.of(context).pop(currencyCode);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? widget.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    )
                                    : widget.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? widget.colorScheme.primary
                                      : widget.colorScheme.outline.withValues(
                                        alpha: 0.2,
                                      ),
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
                                      currencyCode,
                                      style: widget.theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      symbol,
                                      style: widget.theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: widget.colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: widget.colorScheme.primary,
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
      },
    );
  }

  Future<void> _showCategorySelection() async {
    // Ensure Hive is initialized
    await CategoryService.init();

    // Get all categories
    final categories = CategoryService().getAllCategories();

    if (categories.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No categories available. Please create a category first.',
            ),
          ),
        );
      }
      return;
    }

    // Show category selection bottom sheet
    final selectedCategory = await showModalBottomSheet<CategoryModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder:
          (context) => SelectCategoryBottomSheet(
            categories: categories,
            maxHeightPercentage: 0.7,
          ),
    );

    if (selectedCategory != null) {
      _selectedCategoryNotifier.value = selectedCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final l10n = context.l10n;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      padding: EdgeInsets.fromLTRB(24, 0, 24, keyboardHeight > 0 ? 16 : 24),
      child: ValueListenableBuilder<CategoryModel?>(
        valueListenable: _selectedCategoryNotifier,
        builder: (context, selectedCategory, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Amount title
              Text(
                'Amount',
                style: widget.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              // Amount field with currency selector
              Row(
                children: [
                  // Currency selector (20%)
                  Expanded(
                    flex: 2,
                    child: ValueListenableBuilder<String>(
                      valueListenable: _selectedCurrencyNotifier,
                      builder: (context, currencyCode, _) {
                        final flag = _currencies[currencyCode] ?? '🇺🇸';
                        return GestureDetector(
                          onTap: _showCurrencySelector,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: widget.colorScheme.surface,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                flag,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Amount input (80%)
                  Expanded(
                    flex: 8,
                    child: ValueListenableBuilder<String>(
                      valueListenable: _selectedCurrencyNotifier,
                      builder: (context, currencyCode, _) {
                        final currencySymbol =
                            _currencySymbols[currencyCode] ?? '\$';
                        return TextField(
                          controller: _amountController,
                          focusNode: _amountFocusNode,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          textInputAction: TextInputAction.next,
                          onTapOutside: (event) => _amountFocusNode.unfocus(),
                          style: widget.theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            hintText: '0.00',
                            prefixText: '$currencySymbol ',
                            filled: true,
                            fillColor: widget.colorScheme.surface,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              borderSide: BorderSide(
                                color: widget.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Category selection
              Text(
                'Category',
                style: widget.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _showCategorySelection,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: widget.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          selectedCategory != null
                              ? widget.colorScheme.primary
                              : widget.colorScheme.outline.withValues(
                                alpha: 0.3,
                              ),
                      width: selectedCategory != null ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (selectedCategory != null) ...[
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: widget.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            selectedCategory.icon,
                            color: widget.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedCategory.name,
                                style: widget.theme.textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                selectedCategory.type == 'deposits'
                                    ? l10n.add_category_type_deposits
                                    : l10n.add_category_type_expenses,
                                style: widget.theme.textTheme.bodySmall
                                    ?.copyWith(
                                      color: widget.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ] else
                        Expanded(
                          child: Text(
                            'Select a category',
                            style: widget.theme.textTheme.bodyLarge?.copyWith(
                              color: widget.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ),
                      Icon(
                        Icons.chevron_right,
                        color: widget.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (selectedCategory == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Please select a category',
                    style: widget.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(l10n.action_cancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Validate amount
                        final amountText = _amountController.text.trim();
                        if (amountText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter an amount'),
                            ),
                          );
                          _amountFocusNode.requestFocus();
                          return;
                        }

                        final amount = double.tryParse(amountText);
                        if (amount == null || amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a valid amount'),
                            ),
                          );
                          _amountFocusNode.requestFocus();
                          return;
                        }

                        // Validate category
                        if (selectedCategory == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a category'),
                            ),
                          );
                          return;
                        }

                        // TODO: Save transaction to database
                        // For now, just show a success message
                        if (mounted) {
                          final currencyCode = _selectedCurrencyNotifier.value;
                          final currencySymbol =
                              _currencySymbols[currencyCode] ?? '\$';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Transaction recorded: $currencySymbol${amount.toStringAsFixed(2)} - ${selectedCategory.name}',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(l10n.action_confirm),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
