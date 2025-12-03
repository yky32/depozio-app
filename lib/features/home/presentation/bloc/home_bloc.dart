import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:depozio/core/network/logger.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/services/transaction_service.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';

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

      // Preserve scroll offset from previous state
      final previousScrollOffset =
          (state is HomeLoaded) ? (state as HomeLoaded).scrollOffset : 0.0;

      emit(
        HomeLoaded(
          refreshTimestamp: DateTime.now(),
          recentTransactions: recentTransactions,
          scrollOffset: previousScrollOffset,
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
          createdAt: transaction.createdAt,
          notes: transaction.notes,
        );
      }).toList();
    } catch (e) {
      LoggerUtil.e('❌ Error loading recent transactions', error: e);
      return [];
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

        // Preserve scroll offset from before refresh
        emit(
          HomeLoaded(
            refreshTimestamp: DateTime.now(),
            recentTransactions: recentTransactions,
            scrollOffset: preservedScrollOffset,
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

        // Use 0.0 as default - scroll offset should be updated via UpdateScrollOffset
        emit(
          HomeLoaded(
            refreshTimestamp: DateTime.now(),
            recentTransactions: recentTransactions,
            scrollOffset: 0.0,
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
