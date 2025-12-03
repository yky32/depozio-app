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
  final String description;

  const TransactionFormState({
    this.amount = '',
    this.selectedCategory,
    required this.currencyCode,
    this.description = '',
  });

  TransactionFormState copyWith({
    String? amount,
    CategoryEntity? selectedCategory,
    String? currencyCode,
    String? description,
  }) {
    return TransactionFormState(
      amount: amount ?? this.amount,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currencyCode: currencyCode ?? this.currencyCode,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
    amount,
    selectedCategory,
    currencyCode,
    description,
  ];
}
