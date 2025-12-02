import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/features/deposit/presentation/widgets/bottom_sheets/add_category_bottom_sheet.dart';
import 'package:depozio/features/deposit/presentation/widgets/slidable_category_card.dart';
import 'package:depozio/features/deposit/presentation/bloc/deposit_bloc.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/services/transaction_service.dart';
import 'package:depozio/core/network/logger.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({super.key});

  // Helper method to compare lists by IDs (order-independent)
  bool _listsEqual(List<CategoryModel> list1, List<CategoryModel> list2) {
    if (list1.length != list2.length) return false;
    final ids1 = list1.map((c) => c.id).toSet();
    final ids2 = list2.map((c) => c.id).toSet();
    return ids1.length == ids2.length && ids1.containsAll(ids2);
  }

  void _showAddCategoryBottomSheet(BuildContext context) {
    LoggerUtil.d('📝 Opening add category bottom sheet');
    // Get the BLoC instance from the current context
    final depositBloc = context.read<DepositBloc>();
    LoggerUtil.d('✅ BLoC obtained for bottom sheet');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      useRootNavigator: true, // Use root navigator to show above navigation bar
      useSafeArea: false, // Don't use safe area to cover navigation bar
      builder: (bottomSheetContext) {
        final mediaQuery = MediaQuery.of(bottomSheetContext);
        final keyboardHeight = mediaQuery.viewInsets.bottom;
        final screenHeight = mediaQuery.size.height;
        final hasKeyboard = keyboardHeight > 0;

        // When keyboard is visible, reduce max height to leave space at top for dismissal
        // Reserve about 10% of screen height at the top when keyboard is up
        final maxHeightPercentage = hasKeyboard ? 0.85 : 0.95;
        final topMargin = hasKeyboard ? screenHeight * 0.1 : 0.0;

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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    LoggerUtil.i('🏗️ Building DepositPage');

    return BlocProvider(
      create: (context) {
        LoggerUtil.d('🔧 Creating DepositBloc instance');
        return DepositBloc()..add(LoadDeposits());
      },
      child: BlocListener<DepositBloc, DepositState>(
        listenWhen: (previous, current) {
          // Only listen to errors that occur after initial load
          // This prevents showing snackbar for initial load errors
          if (current is DepositError && previous is! DepositInitial) {
            LoggerUtil.w('⚠️ Error state detected: ${current.error}');
            return true;
          }
          return false;
        },
        listener: (context, state) {
          if (state is DepositError) {
            LoggerUtil.e('❌ Showing error snackbar: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.deposit_page_error_message(state.error)),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Builder(
          builder:
              (blocContext) => Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.deposit_page_title,
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: colorScheme.primary,
                              ),
                              onPressed:
                                  () =>
                                      _showAddCategoryBottomSheet(blocContext),
                              tooltip: l10n.deposit_page_add_category,
                            ),
                          ],
                        ),
                      ),
                      // Categories list with BlocBuilder
                      Expanded(
                        child: BlocBuilder<DepositBloc, DepositState>(
                          buildWhen: (previous, current) {
                            // Always rebuild on state type changes
                            if (previous.runtimeType != current.runtimeType) {
                              LoggerUtil.d(
                                '🔄 State type changed: ${previous.runtimeType} -> ${current.runtimeType}',
                              );
                              return true;
                            }
                            // For DepositLoaded states, rebuild when list changes
                            if (previous is DepositLoaded &&
                                current is DepositLoaded) {
                              final lengthChanged =
                                  previous.categories.length !=
                                  current.categories.length;
                              final contentChanged =
                                  !_listsEqual(
                                    previous.categories,
                                    current.categories,
                                  );
                              if (lengthChanged || contentChanged) {
                                LoggerUtil.d(
                                  '🔄 List changed: ${previous.categories.length} -> ${current.categories.length} items',
                                );
                              }
                              return lengthChanged || contentChanged;
                            }
                            return false;
                          },
                          builder: (context, state) {
                            LoggerUtil.d(
                              '🎨 BlocBuilder building with state: ${state.runtimeType}',
                            );

                            // Show loading indicator
                            if (state is DepositLoading) {
                              LoggerUtil.d('⏳ Showing loading indicator');
                              return Center(
                                child: CircularProgressIndicator(
                                  color: colorScheme.primary,
                                ),
                              );
                            }

                            // Show error state
                            if (state is DepositError) {
                              LoggerUtil.w(
                                '⚠️ Showing error state: ${state.error}',
                              );
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 64,
                                      color: Colors.red.withValues(alpha: 0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      l10n.deposit_page_error_loading,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      state.error,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.5),
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<DepositBloc>().add(
                                          LoadDeposits(),
                                        );
                                      },
                                      child: Text(l10n.deposit_page_retry),
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (state is DepositLoaded) {
                              final categories = state.categories;
                              LoggerUtil.d(
                                '📋 Rendering ${categories.length} categories',
                              );

                              if (categories.isEmpty) {
                                LoggerUtil.d('📭 Showing empty state');
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.category_outlined,
                                        size: 64,
                                        color: colorScheme.onSurface.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.deposit_page_no_categories,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.deposit_page_add_category_hint,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: colorScheme.onSurface
                                                  .withValues(alpha: 0.5),
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              LoggerUtil.d(
                                '📜 Building ListView with ${categories.length} items',
                              );
                              // Initialize TransactionService to get counts
                              TransactionService.init();
                              final transactionService = TransactionService();
                              
                              return ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  final transactionCount = transactionService
                                      .getTransactionCountByCategoryId(category.id);
                                  return SlidableCategoryCard(
                                    category: category,
                                    theme: theme,
                                    colorScheme: colorScheme,
                                    l10n: l10n,
                                    transactionCount: transactionCount,
                                  );
                                },
                              );
                            }

                            // Initial state - show loading while data loads
                            return Center(
                              child: CircularProgressIndicator(
                                color: colorScheme.primary,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
