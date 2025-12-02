part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class UpdateAmount extends TransactionEvent {
  final String amount;

  const UpdateAmount({required this.amount});

  @override
  List<Object?> get props => [amount];
}

class SelectCategory extends TransactionEvent {
  final CategoryEntity category;

  const SelectCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

class SelectCurrency extends TransactionEvent {
  final String currencyCode;

  const SelectCurrency({required this.currencyCode});

  @override
  List<Object?> get props => [currencyCode];
}

class ResetTransaction extends TransactionEvent {
  const ResetTransaction();
}

