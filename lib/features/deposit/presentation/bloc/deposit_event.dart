part of 'deposit_bloc.dart';

abstract class DepositEvent {}

class LoadDeposits extends DepositEvent {}

class RefreshDeposits extends DepositEvent {}

class AddCategory extends DepositEvent {
  final CategoryModel category;

  AddCategory({required this.category});
}

class DeleteCategory extends DepositEvent {
  final String categoryId;

  DeleteCategory({required this.categoryId});
}

class UpdateCategory extends DepositEvent {
  final CategoryModel category;

  UpdateCategory({required this.category});
}

class RestoreCategory extends DepositEvent {
  final CategoryModel category;

  RestoreCategory({required this.category});
}

