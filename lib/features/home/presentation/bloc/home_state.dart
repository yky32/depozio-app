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

  HomeLoaded({
    DateTime? refreshTimestamp,
    List<TransactionWithCategory>? recentTransactions,
    this.scrollOffset = 0.0,
    this.totalDeposits = 0.0,
    this.totalExpenses = 0.0,
  }) : refreshTimestamp = refreshTimestamp ?? DateTime.now(),
       recentTransactions = recentTransactions ?? const [];

  @override
  List<Object?> get props => [
    refreshTimestamp,
    recentTransactions,
    scrollOffset,
    totalDeposits,
    totalExpenses,
  ];

  HomeLoaded copyWith({
    DateTime? refreshTimestamp,
    List<TransactionWithCategory>? recentTransactions,
    double? scrollOffset,
    double? totalDeposits,
    double? totalExpenses,
  }) {
    return HomeLoaded(
      refreshTimestamp: refreshTimestamp ?? this.refreshTimestamp,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      totalDeposits: totalDeposits ?? this.totalDeposits,
      totalExpenses: totalExpenses ?? this.totalExpenses,
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
