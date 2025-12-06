import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:depozio/core/network/logger.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/services/transaction_service.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';
import 'package:depozio/core/enum/category_type.dart';
import 'package:depozio/core/services/app_setting_service.dart';
import 'package:depozio/core/services/exchange_rate_service.dart';

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

      // Calculate total deposits and expenses (with currency conversion)
      final totalDeposits = await _calculateTotalDeposits();
      final totalExpenses = await _calculateTotalExpenses();

      // Calculate total savings: totalDeposits - totalExpenses
      final totalSavings = totalDeposits - totalExpenses;
      LoggerUtil.d(
        '💰 Total savings calculated: $totalSavings (deposits: $totalDeposits - expenses: $totalExpenses)',
      );

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
          totalSavings: totalSavings,
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

      // Get the count limit from settings (default: 20)
      final countLimit = AppSettingService.getRecentActivitiesCount();
      final recentTransactions = allTransactions.take(countLimit).toList();

      // Map to TransactionWithCategory
      return recentTransactions.map((transaction) {
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

  /// Get the current period start date based on startDay
  DateTime _getCurrentPeriodStart(DateTime now, int startDay) {
    // If current day is >= startDay, period started on startDay of current month
    // Otherwise, period started on startDay of previous month
    if (now.day >= startDay) {
      return DateTime(now.year, now.month, startDay);
    } else {
      // Previous month
      final prevMonth = now.month == 1 ? 12 : now.month - 1;
      final prevYear = now.month == 1 ? now.year - 1 : now.year;
      // Handle months with fewer days (e.g., Feb 29th -> Feb 28th)
      final daysInMonth = DateTime(prevYear, prevMonth + 1, 0).day;
      final adjustedDay = startDay > daysInMonth ? daysInMonth : startDay;
      return DateTime(prevYear, prevMonth, adjustedDay);
    }
  }

  /// Get the next period start date based on startDay
  DateTime _getNextPeriodStart(DateTime now, int startDay) {
    // Get the current period start date first
    final currentPeriodStart = _getCurrentPeriodStart(now, startDay);
    // Next period starts on startDay of the month after the current period's month
    final nextMonth =
        currentPeriodStart.month == 12 ? 1 : currentPeriodStart.month + 1;
    final nextYear =
        currentPeriodStart.month == 12
            ? currentPeriodStart.year + 1
            : currentPeriodStart.year;
    // Handle months with fewer days
    final daysInMonth = DateTime(nextYear, nextMonth + 1, 0).day;
    final adjustedDay = startDay > daysInMonth ? daysInMonth : startDay;
    return DateTime(nextYear, nextMonth, adjustedDay);
  }

  /// Check if a transaction is within the current period based on startDay
  bool _isTransactionInCurrentPeriod(DateTime transactionDate, int startDay) {
    final now = DateTime.now();
    final periodStart = _getCurrentPeriodStart(now, startDay);
    final nextPeriodStart = _getNextPeriodStart(now, startDay);

    // Normalize all dates to day boundaries for comparison (ignore time components)
    final periodStartDay = DateTime(
      periodStart.year,
      periodStart.month,
      periodStart.day,
    );

    // periodEndDay: current day if today is before nextPeriodStart,
    // otherwise the day before nextPeriodStart (exclusive)
    final periodEndDay =
        now.isBefore(nextPeriodStart)
            ? DateTime(now.year, now.month, now.day)
            : DateTime(
              nextPeriodStart.year,
              nextPeriodStart.month,
              nextPeriodStart.day,
            );

    // Normalize transaction date to start of day for comparison
    final transactionDay = DateTime(
      transactionDate.year,
      transactionDate.month,
      transactionDate.day,
    );

    // Filter: periodStartDay <= transactionDay <= periodEndDay (inclusive of end day)
    final isInPeriod =
        !transactionDay.isBefore(periodStartDay) &&
        !transactionDay.isAfter(periodEndDay);

    LoggerUtil.d(
      '📅 Transaction date check: ${transactionDay.toString().substring(0, 10)} '
      '(startDay: $startDay, period: ${periodStartDay.toString().substring(0, 10)} to ${periodEndDay.toString().substring(0, 10)}, included: $isInPeriod)',
    );

    return isInPeriod;
  }

  Future<double> _calculateTotalDeposits() async {
    try {
      // Ensure AppSettingService is initialized before reading startDate
      AppSettingService.init();

      final transactionService = TransactionService();
      final categoryService = CategoryService();
      final exchangeRateService = ExchangeRateService();

      // Get startDay and selected currency from settings
      final startDay = AppSettingService.getStartDate();
      final selectedCurrency = AppSettingService.getDefaultCurrency();
      LoggerUtil.d(
        '💰 Calculating deposits with startDay: $startDay, selected currency: $selectedCurrency',
      );

      // Get all transactions
      final allTransactions = transactionService.getAllTransactions();

      // Calculate sum of deposit transactions within the current period
      double total = 0.0;
      int includedCount = 0;
      for (final transaction in allTransactions) {
        // Filter by date range: startDay <= transaction.createdAt < Next StartDay (or Now)
        if (!_isTransactionInCurrentPeriod(transaction.createdAt, startDay)) {
          continue;
        }

        final category = categoryService.getCategoryById(
          transaction.categoryId,
        );
        if (category?.categoryType == CategoryType.deposits) {
          // Convert amount to selected currency if needed
          double amountToAdd = transaction.amount;
          if (transaction.currencyCode.toUpperCase() !=
              selectedCurrency.toUpperCase()) {
            try {
              final converted = await exchangeRateService.convert(
                from: transaction.currencyCode,
                to: selectedCurrency,
                amount: transaction.amount,
                useCache: true,
              );
              amountToAdd = converted.converted;
              LoggerUtil.d(
                '💰 Converted deposit: ${transaction.amount} ${transaction.currencyCode} -> $amountToAdd $selectedCurrency',
              );
            } catch (e) {
              LoggerUtil.w(
                '⚠️ Failed to convert deposit amount, using original: $e',
              );
              // On conversion error, use original amount
              amountToAdd = transaction.amount;
            }
          }
          total += amountToAdd;
          includedCount++;
          LoggerUtil.d(
            '💰 Including deposit: $amountToAdd $selectedCurrency (original: ${transaction.amount} ${transaction.currencyCode}) on ${transaction.createdAt}',
          );
        }
      }

      LoggerUtil.d(
        '💰 Total deposits: $total $selectedCurrency (from $includedCount transactions)',
      );
      return total;
    } catch (e) {
      LoggerUtil.e('❌ Error calculating total deposits', error: e);
      return 0.0;
    }
  }

  Future<double> _calculateTotalExpenses() async {
    try {
      // Ensure AppSettingService is initialized before reading startDate
      AppSettingService.init();

      final transactionService = TransactionService();
      final categoryService = CategoryService();
      final exchangeRateService = ExchangeRateService();

      // Get startDay and selected currency from settings
      final startDay = AppSettingService.getStartDate();
      final selectedCurrency = AppSettingService.getDefaultCurrency();
      LoggerUtil.d(
        '💸 Calculating expenses with startDay: $startDay, selected currency: $selectedCurrency',
      );

      // Get all transactions
      final allTransactions = transactionService.getAllTransactions();

      // Calculate sum of expense transactions within the current period
      double total = 0.0;
      int includedCount = 0;
      for (final transaction in allTransactions) {
        // Filter by date range: startDay <= transaction.createdAt < Next StartDay (or Now)
        if (!_isTransactionInCurrentPeriod(transaction.createdAt, startDay)) {
          continue;
        }

        final category = categoryService.getCategoryById(
          transaction.categoryId,
        );
        if (category?.categoryType == CategoryType.expenses) {
          // Convert amount to selected currency if needed
          double amountToAdd = transaction.amount;
          if (transaction.currencyCode.toUpperCase() !=
              selectedCurrency.toUpperCase()) {
            try {
              final converted = await exchangeRateService.convert(
                from: transaction.currencyCode,
                to: selectedCurrency,
                amount: transaction.amount,
                useCache: true,
              );
              amountToAdd = converted.converted;
              LoggerUtil.d(
                '💸 Converted expense: ${transaction.amount} ${transaction.currencyCode} -> $amountToAdd $selectedCurrency',
              );
            } catch (e) {
              LoggerUtil.w(
                '⚠️ Failed to convert expense amount, using original: $e',
              );
              // On conversion error, use original amount
              amountToAdd = transaction.amount;
            }
          }
          total += amountToAdd;
          includedCount++;
          LoggerUtil.d(
            '💸 Including expense: $amountToAdd $selectedCurrency (original: ${transaction.amount} ${transaction.currencyCode}) on ${transaction.createdAt}',
          );
        }
      }

      LoggerUtil.d(
        '💸 Total expenses: $total $selectedCurrency (from $includedCount transactions)',
      );
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

        // Calculate total deposits and expenses (with currency conversion)
        final totalDeposits = await _calculateTotalDeposits();
        final totalExpenses = await _calculateTotalExpenses();

        // Calculate total savings: totalDeposits - totalExpenses
        final totalSavings = totalDeposits - totalExpenses;

        // Preserve scroll offset from before refresh
        emit(
          HomeLoaded(
            refreshTimestamp: DateTime.now(),
            recentTransactions: recentTransactions,
            scrollOffset: preservedScrollOffset,
            totalDeposits: totalDeposits,
            totalExpenses: totalExpenses,
            totalSavings: totalSavings,
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

        // Calculate total deposits and expenses (with currency conversion)
        final totalDeposits = await _calculateTotalDeposits();
        final totalExpenses = await _calculateTotalExpenses();

        // Calculate total savings: totalDeposits - totalExpenses
        final totalSavings = totalDeposits - totalExpenses;

        // Use 0.0 as default - scroll offset should be updated via UpdateScrollOffset
        emit(
          HomeLoaded(
            refreshTimestamp: DateTime.now(),
            recentTransactions: recentTransactions,
            scrollOffset: 0.0,
            totalDeposits: totalDeposits,
            totalExpenses: totalExpenses,
            totalSavings: totalSavings,
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
