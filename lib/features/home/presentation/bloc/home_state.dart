part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeRefreshing extends HomeState {
  const HomeRefreshing();
}

class HomeLoaded extends HomeState {
  final DateTime refreshTimestamp;
  final List<TransactionWithCategory> recentTransactions;
  final double scrollOffset;
  final double totalDeposits;
  final double totalExpenses;
  final double totalSavings; // Calculated as: totalDeposits - totalExpenses

  HomeLoaded({
    DateTime? refreshTimestamp,
    List<TransactionWithCategory>? recentTransactions,
    this.scrollOffset = 0.0,
    this.totalDeposits = 0.0,
    this.totalExpenses = 0.0,
    double? totalSavings,
  }) : refreshTimestamp = refreshTimestamp ?? DateTime.now(),
       recentTransactions = recentTransactions ?? const [],
       // Calculate totalSavings: totalDeposits - totalExpenses
       totalSavings = totalSavings ?? (totalDeposits - totalExpenses);

  @override
  List<Object?> get props => [
    refreshTimestamp,
    recentTransactions,
    scrollOffset,
    totalDeposits,
    totalExpenses,
    totalSavings,
  ];

  HomeLoaded copyWith({
    DateTime? refreshTimestamp,
    List<TransactionWithCategory>? recentTransactions,
    double? scrollOffset,
    double? totalDeposits,
    double? totalExpenses,
    double? totalSavings,
  }) {
    // Calculate totalSavings if deposits or expenses changed
    final newTotalDeposits = totalDeposits ?? this.totalDeposits;
    final newTotalExpenses = totalExpenses ?? this.totalExpenses;
    final calculatedTotalSavings =
        totalSavings ?? (newTotalDeposits - newTotalExpenses);

    return HomeLoaded(
      refreshTimestamp: refreshTimestamp ?? this.refreshTimestamp,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      totalDeposits: newTotalDeposits,
      totalExpenses: newTotalExpenses,
      totalSavings: calculatedTotalSavings,
    );
  }
}

/// Helper class to combine transaction with its category information
class TransactionWithCategory extends Equatable {
  final String transactionId;
  final double amount;
  final String currencyCode;
  final String categoryId;
  final String categoryName;
  final IconData categoryIcon;
  final String categoryType; // 'deposits' or 'expenses'
  final DateTime createdAt;
  final String? notes;

  const TransactionWithCategory({
    required this.transactionId,
    required this.amount,
    required this.currencyCode,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryType,
    required this.createdAt,
    this.notes,
  });

  @override
  List<Object?> get props => [
    transactionId,
    amount,
    currencyCode,
    categoryId,
    categoryName,
    categoryIcon,
    categoryType,
    createdAt,
    notes,
  ];
}

class HomeError extends HomeState {
  final String error;

  const HomeError({required this.error});

  @override
  List<Object?> get props => [error];
}
