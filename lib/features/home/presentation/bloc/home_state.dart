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

  HomeLoaded({
    DateTime? refreshTimestamp,
    List<TransactionWithCategory>? recentTransactions,
    this.scrollOffset = 0.0,
  }) : refreshTimestamp = refreshTimestamp ?? DateTime.now(),
       recentTransactions = recentTransactions ?? const [];

  @override
  List<Object?> get props => [
    refreshTimestamp,
    recentTransactions,
    scrollOffset,
  ];

  HomeLoaded copyWith({
    DateTime? refreshTimestamp,
    List<TransactionWithCategory>? recentTransactions,
    double? scrollOffset,
  }) {
    return HomeLoaded(
      refreshTimestamp: refreshTimestamp ?? this.refreshTimestamp,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      scrollOffset: scrollOffset ?? this.scrollOffset,
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
  final DateTime createdAt;
  final String? notes;

  const TransactionWithCategory({
    required this.transactionId,
    required this.amount,
    required this.currencyCode,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
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
