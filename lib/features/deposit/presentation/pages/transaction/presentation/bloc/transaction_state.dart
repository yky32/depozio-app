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
  final CategoryModel? selectedCategory;
  final String currencyCode;

  const TransactionFormState({
    this.amount = '',
    this.selectedCategory,
    this.currencyCode = 'USD',
  });

  TransactionFormState copyWith({
    String? amount,
    CategoryModel? selectedCategory,
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

