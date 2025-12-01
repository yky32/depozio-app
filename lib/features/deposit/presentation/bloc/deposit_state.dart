part of 'deposit_bloc.dart';

abstract class DepositState extends Equatable {
  const DepositState();

  @override
  List<Object?> get props => [];
}

class DepositInitial extends DepositState {
  const DepositInitial();

  @override
  List<Object?> get props => [];
}

class DepositLoading extends DepositState {
  const DepositLoading();

  @override
  List<Object?> get props => [];
}

class DepositLoaded extends DepositState {
  final List<CategoryModel> categories;

  DepositLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class DepositError extends DepositState {
  final String error;

  const DepositError({required this.error});

  @override
  List<Object?> get props => [error];
}

