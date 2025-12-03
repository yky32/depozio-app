import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';
import 'package:depozio/features/deposit/presentation/widgets/bottom_sheets/select_category_bottom_sheet.dart';
import 'package:depozio/features/deposit/presentation/widgets/bottom_sheets/add_category_bottom_sheet.dart';
import 'package:depozio/features/deposit/presentation/bloc/deposit_bloc.dart';
import 'package:depozio/widgets/bottom_sheets/select_currency_bottom_sheet.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/currency_helper.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/services/transaction_service.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/models/transaction_entity.dart';
import 'package:depozio/core/services/app_setting_service.dart';

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

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: Container(
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
      ),
    );
  }
}

/// Internal widget that maintains transaction form state using BLoC
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
  late final TextEditingController _descriptionController;
  late final FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _amountFocusNode = FocusNode();
    _descriptionController = TextEditingController();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _showCurrencySelector(BuildContext context, String currentCurrency) {
    final bloc = context.read<TransactionBloc>();
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SelectCurrencyBottomSheet(currentCurrency: currentCurrency);
      },
    ).then((selectedCurrency) {
      if (selectedCurrency != null) {
        bloc.add(SelectCurrency(currencyCode: selectedCurrency));
      }
    });
  }

  Future<void> _showCategorySelection(BuildContext context) async {
    final bloc = context.read<TransactionBloc>();
    // Ensure Hive is initialized
    await CategoryService.init();

    // Get all categories
    var categories = CategoryService().getAllCategories();

    if (categories.isEmpty) {
      // No categories found - show add category bottom sheet
      if (!context.mounted) return;
      await _showAddCategoryBottomSheet(context);

      // Wait a bit for the category to be saved to Hive
      await Future.delayed(const Duration(milliseconds: 500));

      // Get updated categories after category creation
      categories = CategoryService().getAllCategories();

      // If still no categories, user dismissed without creating
      if (categories.isEmpty) {
        return;
      }
    }

    // Show category selection bottom sheet
    if (!context.mounted) return;
    final selectedCategory = await _showCategorySelectionBottomSheet(
      context,
      categories,
    );

    if (selectedCategory != null && context.mounted) {
      bloc.add(SelectCategory(category: selectedCategory));
    }
  }

  Future<CategoryEntity?> _showCategorySelectionBottomSheet(
    BuildContext context,
    List<CategoryEntity> categories,
  ) async {
    while (true) {
      final initialCategoryCount = categories.length;

      final result = await showModalBottomSheet<CategoryEntity>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: true,
        builder: (BuildContext bottomSheetContext) {
          return SelectCategoryBottomSheet(
            categories: categories,
            onAddCategory: () async {
              // Close the category selection bottom sheet first
              Navigator.of(bottomSheetContext).pop();

              // Show add category bottom sheet
              await _showAddCategoryBottomSheet(context);

              // Wait a bit for the category to be saved to Hive
              await Future.delayed(const Duration(milliseconds: 500));

              // Get updated categories after category creation
              final updatedCategories = CategoryService().getAllCategories();

              // Update categories for next iteration
              if (updatedCategories.isNotEmpty) {
                categories = updatedCategories;
              }
            },
          );
        },
      );

      // If a category was selected, return it
      if (result != null) {
        return result;
      }

      // If dismissed, check if new categories were added
      if (!context.mounted) {
        return null;
      }

      final updatedCategories = CategoryService().getAllCategories();

      // Only re-show if categories were actually added (count increased)
      if (updatedCategories.length > initialCategoryCount) {
        categories = updatedCategories;
        continue; // Show selector again with new categories
      }

      // No new categories added, exit
      return null;
    }
  }

  Future<void> _showAddCategoryBottomSheet(BuildContext context) async {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;
    final hasKeyboard = keyboardHeight > 0;

    // When keyboard is visible, reduce max height to leave space at top for dismissal
    // Reserve about 10% of screen height at the top when keyboard is up
    final maxHeightPercentage = hasKeyboard ? 0.85 : 0.95;
    final topMargin = hasKeyboard ? screenHeight * 0.1 : 0.0;

    // Create a DepositBloc for the add category bottom sheet
    final depositBloc = DepositBloc()..add(LoadDeposits());

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: depositBloc,
          child: Stack(
            children: [
              // Backdrop to cover navigation bar - tappable to dismiss
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.of(bottomSheetContext).pop(),
                  child: Container(color: Colors.black.withValues(alpha: 0.5)),
                ),
              ),
              // Bottom sheet content
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: keyboardHeight,
                    top: topMargin,
                  ),
                  child: AddCategoryBottomSheet(
                    maxHeightPercentage: maxHeightPercentage,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // Clean up the bloc after the bottom sheet is closed
    depositBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final l10n = context.l10n;

    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final formState =
            state is TransactionFormState
                ? state
                : TransactionFormState(
                  currencyCode: AppSettingService.getDefaultCurrency(),
                );
        final selectedCategory = formState.selectedCategory;
        final currencyCode = formState.currencyCode;
        final currencySymbol = CurrencyHelper.getSymbol(currencyCode);
        final flag = CurrencyHelper.getFlag(currencyCode);

        // Sync controllers with state
        if (_amountController.text != formState.amount) {
          _amountController.text = formState.amount;
        }
        if (_descriptionController.text != formState.description) {
          _descriptionController.text = formState.description;
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
                    child: GestureDetector(
                      onTap: () {
                        _amountFocusNode.unfocus();
                        _showCurrencySelector(context, currencyCode);
                      },
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
                    ),
                  ),
                  // Amount input (80%)
                  Expanded(
                    flex: 8,
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: _amountController,
                        focusNode: _amountFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          // Allow only numbers and decimal point
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          // Ensure only one decimal point
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            final text = newValue.text;
                            // Count decimal points
                            final decimalCount = '.'.allMatches(text).length;
                            // If more than one decimal point, reject
                            if (decimalCount > 1) {
                              return oldValue;
                            }
                            // If decimal point is at the start, reject
                            if (text.startsWith('.')) {
                              return oldValue;
                            }
                            return newValue;
                          }),
                        ],
                        onTapOutside: (event) => _amountFocusNode.unfocus(),
                        onChanged: (value) {
                          context.read<TransactionBloc>().add(
                            UpdateAmount(amount: value),
                          );
                        },
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
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Description field
              Text(
                l10n.transaction_description,
                style: widget.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
                textInputAction: TextInputAction.next,
                maxLines: 3,
                minLines: 1,
                onTapOutside: (event) => _descriptionFocusNode.unfocus(),
                onChanged: (value) {
                  context.read<TransactionBloc>().add(
                    UpdateDescription(description: value),
                  );
                },
                style: widget.theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: l10n.transaction_description_placeholder,
                  filled: true,
                  fillColor: widget.colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: widget.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Category selection
              Text(
                l10n.transaction_category,
                style: widget.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _amountFocusNode.unfocus();
                  _showCategorySelection(context);
                },
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
                            l10n.transaction_select_category_placeholder,
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
                    l10n.transaction_please_select_category,
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
                          _amountFocusNode.requestFocus();
                          return;
                        }

                        final amount = double.tryParse(amountText);
                        if (amount == null || amount <= 0) {
                          _amountFocusNode.requestFocus();
                          return;
                        }

                        // Validate category
                        if (currentState.selectedCategory == null) {
                          return;
                        }

                        // Save transaction to Hive
                        try {
                          await TransactionService.init();
                          final transaction = TransactionEntity(
                            id:
                                DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                            amount: amount,
                            currencyCode: currentState.currencyCode,
                            categoryId: currentState.selectedCategory!.id,
                            createdAt: DateTime.now(),
                            notes:
                                currentState.description.trim().isEmpty
                                    ? null
                                    : currentState.description.trim(),
                          );
                          await TransactionService().addTransaction(
                            transaction,
                          );

                          if (context.mounted) {
                            // Transaction saved - the home page will automatically refresh
                            // via the transaction watcher in _HomePageContentState
                            // The deposit page will automatically refresh
                            // via the transaction watcher in _DepositPageContent

                            bloc.add(const ResetTransaction());
                            Navigator.of(context).pop();
                          }
                        } catch (e) {
                          // Error saving transaction - silently fail
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
