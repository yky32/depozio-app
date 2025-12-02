part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();

  @override
  List<Object?> get props => [];
}

class TransactionFormState extends TransactionState {
  final String amount;
  final CategoryEntity? selectedCategory;
  final String currencyCode;

  TransactionFormState({
    this.amount = '',
    this.selectedCategory,
    required this.currencyCode,
  });

  TransactionFormState copyWith({
    String? amount,
    CategoryEntity? selectedCategory,
    String? currencyCode,
  }) {
    return TransactionFormState(
      amount: amount ?? this.amount,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }

  @override
  List<Object?> get props => [amount, selectedCategory, currencyCode];
}

