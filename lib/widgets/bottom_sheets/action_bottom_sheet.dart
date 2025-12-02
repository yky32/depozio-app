import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';
import 'package:depozio/features/deposit/presentation/widgets/bottom_sheets/select_category_bottom_sheet.dart';
import 'package:depozio/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:depozio/features/transaction/data/currency_helper.dart';

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
              context.l10n.transaction_record_title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: BlocProvider(
              create: (context) => TransactionBloc(),
              child: _TransactionFormContent(
                theme: theme,
                colorScheme: colorScheme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal widget that maintains transaction form state using BLoC
class _TransactionFormContent extends StatelessWidget {
  const _TransactionFormContent({
    required this.theme,
    required this.colorScheme,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;

  void _showCurrencySelector(BuildContext context, String currentCurrency) {
    final bloc = context.read<TransactionBloc>();
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
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
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Text(
                  context.l10n.transaction_select_currency,
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
                    final currencyCode = CurrencyHelper.currencies.keys
                        .elementAt(index);
                    final flag = CurrencyHelper.getFlag(currencyCode);
                    final symbol = CurrencyHelper.getSymbol(currencyCode);
                    final currencyName = CurrencyHelper.getName(
                      currencyCode,
                      context.l10n,
                    );
                    final isSelected = currentCurrency == currencyCode;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          bloc.add(SelectCurrency(currencyCode: currencyCode));
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
                                    ? colorScheme.primary.withValues(alpha: 0.1)
                                    : colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? colorScheme.primary
                                      : colorScheme.outline.withValues(
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
                                      currencyName,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$currencyCode • $symbol',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.6),
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
      },
    );
  }

  Future<void> _showCategorySelection(BuildContext context) async {
    final bloc = context.read<TransactionBloc>();
    // Ensure Hive is initialized
    await CategoryService.init();

    // Get all categories
    final categories = CategoryService().getAllCategories();

    if (categories.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.transaction_no_categories_available),
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
      bloc.add(SelectCategory(category: selectedCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final l10n = context.l10n;
    final amountController = TextEditingController();
    final amountFocusNode = FocusNode();

    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final formState =
            state is TransactionFormState
                ? state
                : const TransactionFormState();
        final selectedCategory = formState.selectedCategory;
        final currencyCode = formState.currencyCode;
        final currencySymbol = CurrencyHelper.getSymbol(currencyCode);
        final flag = CurrencyHelper.getFlag(currencyCode);

        // Sync controller with state
        if (amountController.text != formState.amount) {
          amountController.text = formState.amount;
        }

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          padding: EdgeInsets.fromLTRB(24, 0, 24, keyboardHeight > 0 ? 16 : 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Amount title
              Text(
                l10n.transaction_amount,
                style: theme.textTheme.titleMedium?.copyWith(
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
                    child: GestureDetector(
                      onTap: () => _showCurrencySelector(context, currencyCode),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
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
                    ),
                  ),
                  // Amount input (80%)
                  Expanded(
                    flex: 8,
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: amountController,
                        focusNode: amountFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        textInputAction: TextInputAction.next,
                        onTapOutside: (event) => amountFocusNode.unfocus(),
                        onChanged: (value) {
                          context.read<TransactionBloc>().add(
                            UpdateAmount(amount: value),
                          );
                        },
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: '0.00',
                          prefixText: '$currencySymbol ',
                          filled: true,
                          fillColor: colorScheme.surface,
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
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Category selection
              Text(
                l10n.transaction_category,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _showCategorySelection(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          selectedCategory != null
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.3),
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
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            selectedCategory.icon,
                            color: colorScheme.primary,
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
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                selectedCategory.type == 'deposits'
                                    ? l10n.add_category_type_deposits
                                    : l10n.add_category_type_expenses,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else
                        Expanded(
                          child: Text(
                            l10n.transaction_select_category_placeholder,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ),
                      Icon(
                        Icons.chevron_right,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              if (selectedCategory == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.transaction_please_select_category,
                    style: theme.textTheme.bodySmall?.copyWith(
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
                      onPressed: () {
                        context.read<TransactionBloc>().add(
                          const ResetTransaction(),
                        );
                        Navigator.of(context).pop();
                      },
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
                        final bloc = context.read<TransactionBloc>();
                        final currentState = bloc.state;
                        if (currentState is! TransactionFormState) return;

                        // Validate amount
                        final amountText = currentState.amount.trim();
                        if (amountText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.transaction_please_enter_amount,
                              ),
                            ),
                          );
                          amountFocusNode.requestFocus();
                          return;
                        }

                        final amount = double.tryParse(amountText);
                        if (amount == null || amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.transaction_please_enter_valid_amount,
                              ),
                            ),
                          );
                          amountFocusNode.requestFocus();
                          return;
                        }

                        // Validate category
                        if (currentState.selectedCategory == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.transaction_please_select_category,
                              ),
                            ),
                          );
                          return;
                        }

                        // TODO: Save transaction to database
                        // For now, just show a success message
                        if (context.mounted) {
                          final currencySymbol = CurrencyHelper.getSymbol(
                            currentState.currencyCode,
                          );
                          final amountText =
                              '$currencySymbol${amount.toStringAsFixed(2)}';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.transaction_recorded(
                                  amountText,
                                  currentState.selectedCategory!.name,
                                ),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          bloc.add(const ResetTransaction());
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
          ),
        );
      },
    );
  }
}
