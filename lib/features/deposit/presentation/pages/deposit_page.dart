import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/core/localization/app_localizations.dart';
import 'package:depozio/features/deposit/presentation/widgets/bottom_sheets/add_category_bottom_sheet.dart';
import 'package:depozio/features/deposit/presentation/bloc/deposit_bloc.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/services/transaction_service.dart';
import 'package:depozio/core/network/logger.dart';
import 'package:depozio/features/deposit/presentation/pages/widgets/deposit_page_header.dart';
import 'package:depozio/features/deposit/presentation/pages/widgets/deposit_error_state.dart';
import 'package:depozio/features/deposit/presentation/pages/widgets/deposit_empty_state.dart';
import 'package:depozio/features/deposit/presentation/pages/widgets/skeleton_categories_list.dart';
import 'package:depozio/features/deposit/presentation/pages/widgets/categories_list.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({super.key});

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
      child: _DepositPageContent(
        theme: theme,
        colorScheme: colorScheme,
        l10n: l10n,
      ),
    );
  }
}

class _DepositPageContent extends StatefulWidget {
  const _DepositPageContent({
    required this.theme,
    required this.colorScheme,
    required this.l10n,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final AppLocalizations l10n;

  @override
  State<_DepositPageContent> createState() => _DepositPageContentState();
}

class _DepositPageContentState extends State<_DepositPageContent> {
  StreamSubscription? _transactionSubscription;

  // Helper method to compare lists by IDs (order-independent)
  bool _listsEqual(List<CategoryEntity> list1, List<CategoryEntity> list2) {
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
  void initState() {
    super.initState();
    // Listen to transaction changes and refresh DepositBloc
    _startTransactionWatcher();
  }

  void _startTransactionWatcher() {
    TransactionService.init().then((_) {
      final transactionService = TransactionService();
      _transactionSubscription = transactionService.watchTransactions().listen((
        _,
      ) {
        // Transaction changed, refresh DepositBloc to update counts
        if (mounted) {
          context.read<DepositBloc>().add(RefreshDeposits());
        }
      });
    });
  }

  @override
  void dispose() {
    _transactionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DepositBloc, DepositState>(
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
          LoggerUtil.e('❌ Deposit error: ${state.error}');
        }
      },
      child: Builder(
        builder:
            (blocContext) => Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    // Header
                    DepositPageHeader(
                      theme: widget.theme,
                      colorScheme: widget.colorScheme,
                      l10n: widget.l10n,
                      onAddCategory:
                          () => _showAddCategoryBottomSheet(blocContext),
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
                          // Rebuild when transitioning to/from refreshing state
                          if (previous is DepositRefreshing ||
                              current is DepositRefreshing) {
                            return true;
                          }
                          // For DepositLoaded states, rebuild when list changes OR refresh timestamp changes
                          // This ensures transaction counts are recalculated even when categories are the same
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
                            final refreshChanged =
                                previous.refreshTimestamp !=
                                current.refreshTimestamp;
                            if (lengthChanged ||
                                contentChanged ||
                                refreshChanged) {
                              LoggerUtil.d(
                                '🔄 List or refresh changed: ${previous.categories.length} -> ${current.categories.length} items, refresh: $refreshChanged',
                              );
                            }
                            return lengthChanged ||
                                contentChanged ||
                                refreshChanged;
                          }
                          return false;
                        },
                        builder: (context, state) {
                          LoggerUtil.d(
                            '🎨 BlocBuilder building with state: ${state.runtimeType}',
                          );

                          // Show loading state with skeleton
                          if (state is DepositLoading) {
                            LoggerUtil.d('⏳ Showing skeleton loading state');
                            return SkeletonCategoriesList(
                              theme: widget.theme,
                              colorScheme: widget.colorScheme,
                              l10n: widget.l10n,
                            );
                          }

                          // Show refreshing state with skeleton overlay
                          if (state is DepositRefreshing) {
                            LoggerUtil.d(
                              '🔄 Showing skeleton refreshing state',
                            );
                            return CategoriesList(
                              theme: widget.theme,
                              colorScheme: widget.colorScheme,
                              l10n: widget.l10n,
                              categories: state.categories,
                              isLoading: true,
                            );
                          }

                          // Show error state
                          if (state is DepositError) {
                            LoggerUtil.w(
                              '⚠️ Showing error state: ${state.error}',
                            );
                            return DepositErrorState(
                              theme: widget.theme,
                              colorScheme: widget.colorScheme,
                              l10n: widget.l10n,
                              error: state.error,
                            );
                          }

                          if (state is DepositLoaded) {
                            final categories = state.categories;
                            LoggerUtil.d(
                              '📋 Rendering ${categories.length} categories',
                            );

                            if (categories.isEmpty) {
                              LoggerUtil.d('📭 Showing empty state');
                              return DepositEmptyState(
                                theme: widget.theme,
                                colorScheme: widget.colorScheme,
                                l10n: widget.l10n,
                              );
                            }

                            return CategoriesList(
                              theme: widget.theme,
                              colorScheme: widget.colorScheme,
                              l10n: widget.l10n,
                              categories: categories,
                              isLoading: false,
                            );
                          }

                          // Default fallback
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
