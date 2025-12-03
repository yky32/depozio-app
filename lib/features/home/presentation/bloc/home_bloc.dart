import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:depozio/core/network/logger.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/services/transaction_service.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';
import 'package:depozio/core/enum/category_type.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  StreamSubscription? _transactionSubscription;

  HomeBloc() : super(const HomeInitial()) {
    LoggerUtil.i('HomeBloc initialized');
    on<LoadHome>(_handleLoadHome);
    on<RefreshHome>(_handleRefreshHome);
    on<UpdateScrollOffset>(_handleUpdateScrollOffset);

    // Start watching transactions for automatic refresh
    _startTransactionWatcher();
  }

  void _startTransactionWatcher() {
    TransactionService.init().then((_) {
      final transactionService = TransactionService();
      _transactionSubscription = transactionService.watchTransactions().listen((
        _,
      ) {
        // Transaction changed, automatically refresh
        LoggerUtil.d('🔄 Transaction changed, refreshing home data');
        add(const RefreshHome());
      });
    });
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }

  Future<void> _handleLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    LoggerUtil.d('📥 LoadHome event received');
    emit(const HomeLoading());

    try {
      // Initialize services
      await TransactionService.init();
      await CategoryService.init();

      LoggerUtil.d('📖 Loading home data...');

      // Load recent transactions (top 10, latest first)
      final recentTransactions = _loadRecentTransactions();

      // Calculate total deposits and expenses
      final totalDeposits = _calculateTotalDeposits();
      final totalExpenses = _calculateTotalExpenses();

      // Preserve scroll offset from previous state
      final previousScrollOffset =
          (state is HomeLoaded) ? (state as HomeLoaded).scrollOffset : 0.0;

      emit(
        HomeLoaded(
          refreshTimestamp: DateTime.now(),
          recentTransactions: recentTransactions,
          scrollOffset: previousScrollOffset,
          totalDeposits: totalDeposits,
          totalExpenses: totalExpenses,
        ),
      );
      LoggerUtil.d(
        '📤 State emitted: HomeLoaded with ${recentTransactions.length} transactions',
      );
    } catch (e, stackTrace) {
      LoggerUtil.e(
        '❌ Error loading home data',
        error: e,
        stackTrace: stackTrace,
      );
      emit(HomeError(error: e.toString()));
    }
  }

  List<TransactionWithCategory> _loadRecentTransactions() {
    try {
      final transactionService = TransactionService();
      final categoryService = CategoryService();

      // Get all transactions (already sorted by createdAt descending)
      final allTransactions = transactionService.getAllTransactions();

      // Take top 10
      final top10Transactions = allTransactions.take(10).toList();

      // Map to TransactionWithCategory
      return top10Transactions.map((transaction) {
        final category = categoryService.getCategoryById(
          transaction.categoryId,
        );
        return TransactionWithCategory(
          transactionId: transaction.id,
          amount: transaction.amount,
          currencyCode: transaction.currencyCode,
          categoryId: transaction.categoryId,
          categoryName: category?.name ?? 'Unknown',
          categoryIcon: category?.icon ?? Icons.category,
          categoryType:
              category?.categoryType.value ?? CategoryType.expenses.value,
          createdAt: transaction.createdAt,
          notes: transaction.notes,
        );
      }).toList();
    } catch (e) {
      LoggerUtil.e('❌ Error loading recent transactions', error: e);
      return [];
    }
  }

  double _calculateTotalDeposits() {
    try {
      final transactionService = TransactionService();
      final categoryService = CategoryService();

      // Get all transactions
      final allTransactions = transactionService.getAllTransactions();

      // Calculate sum of all deposit transactions
      double total = 0.0;
      for (final transaction in allTransactions) {
        final category = categoryService.getCategoryById(
          transaction.categoryId,
        );
        if (category?.categoryType == CategoryType.deposits) {
          total += transaction.amount;
        }
      }

      return total;
    } catch (e) {
      LoggerUtil.e('❌ Error calculating total deposits', error: e);
      return 0.0;
    }
  }

  double _calculateTotalExpenses() {
    try {
      final transactionService = TransactionService();
      final categoryService = CategoryService();

      // Get all transactions
      final allTransactions = transactionService.getAllTransactions();

      // Calculate sum of all expense transactions
      double total = 0.0;
      for (final transaction in allTransactions) {
        final category = categoryService.getCategoryById(
          transaction.categoryId,
        );
        if (category?.categoryType == CategoryType.expenses) {
          total += transaction.amount;
        }
      }

      return total;
    } catch (e) {
      LoggerUtil.e('❌ Error calculating total expenses', error: e);
      return 0.0;
    }
  }

  Future<void> _handleRefreshHome(
    RefreshHome event,
    Emitter<HomeState> emit,
  ) async {
    LoggerUtil.d(
      '🔄 RefreshHome event received, current state: ${state.runtimeType}',
    );

    if (state is HomeLoaded) {
      // Capture scroll offset before emitting refreshing state
      final currentState = state as HomeLoaded;
      final preservedScrollOffset = currentState.scrollOffset;

      // Emit refreshing state to show skeleton
      emit(const HomeRefreshing());

      try {
        // Small delay to show skeleton effect
        await Future.delayed(const Duration(milliseconds: 300));

        LoggerUtil.d('📖 Refreshing home data...');

        // Reload recent transactions
        final recentTransactions = _loadRecentTransactions();

        // Calculate total deposits and expenses
        final totalDeposits = _calculateTotalDeposits();
        final totalExpenses = _calculateTotalExpenses();

        // Preserve scroll offset from before refresh
        emit(
          HomeLoaded(
            refreshTimestamp: DateTime.now(),
            recentTransactions: recentTransactions,
            scrollOffset: preservedScrollOffset,
            totalDeposits: totalDeposits,
            totalExpenses: totalExpenses,
          ),
        );
        LoggerUtil.d(
          '📤 State emitted: HomeLoaded (refreshed) with ${recentTransactions.length} transactions',
        );
      } catch (e, stackTrace) {
        LoggerUtil.e(
          '❌ Error refreshing home data',
          error: e,
          stackTrace: stackTrace,
        );
        emit(HomeError(error: e.toString()));
      }
    } else if (state is HomeRefreshing) {
      // Already refreshing, just update the data
      // Note: Scroll offset should have been preserved before HomeRefreshing was emitted
      try {
        LoggerUtil.d('📖 Refreshing home data...');

        // Reload recent transactions
        final recentTransactions = _loadRecentTransactions();

        // Calculate total deposits and expenses
        final totalDeposits = _calculateTotalDeposits();
        final totalExpenses = _calculateTotalExpenses();

        // Use 0.0 as default - scroll offset should be updated via UpdateScrollOffset
        emit(
          HomeLoaded(
            refreshTimestamp: DateTime.now(),
            recentTransactions: recentTransactions,
            scrollOffset: 0.0,
            totalDeposits: totalDeposits,
            totalExpenses: totalExpenses,
          ),
        );
        LoggerUtil.d(
          '📤 State emitted: HomeLoaded (refreshed) with ${recentTransactions.length} transactions',
        );
      } catch (e, stackTrace) {
        LoggerUtil.e(
          '❌ Error refreshing home data',
          error: e,
          stackTrace: stackTrace,
        );
        emit(HomeError(error: e.toString()));
      }
    } else {
      // If not loaded, trigger load
      LoggerUtil.d('⚠️ Not loaded yet, triggering LoadHome');
      add(const LoadHome());
    }
  }

  void _handleUpdateScrollOffset(
    UpdateScrollOffset event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(scrollOffset: event.scrollOffset));
    }
  }
}
