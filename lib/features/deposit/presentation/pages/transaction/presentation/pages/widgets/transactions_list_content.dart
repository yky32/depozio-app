import 'package:flutter/material.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/models/transaction_entity.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';
import 'package:depozio/features/home/presentation/pages/widgets/transaction_item.dart';
import 'package:depozio/features/home/presentation/bloc/home_bloc.dart';
import 'package:depozio/core/enum/category_type.dart';

class TransactionsListContent extends StatelessWidget {
  const TransactionsListContent({
    super.key,
    required this.theme,
    required this.colorScheme,
    required this.transactions,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final List<TransactionEntity> transactions;

  /// Convert TransactionEntity to TransactionWithCategory
  TransactionWithCategory _convertToTransactionWithCategory(
    TransactionEntity transaction,
  ) {
    CategoryService.init();
    final categoryService = CategoryService();
    final category = categoryService.getCategoryById(transaction.categoryId);

    return TransactionWithCategory(
      transactionId: transaction.id,
      amount: transaction.amount,
      currencyCode: transaction.currencyCode,
      categoryId: transaction.categoryId,
      categoryName: category?.name ?? 'Unknown',
      categoryIcon: category?.icon ?? Icons.category,
      categoryType: category?.categoryType.value ?? CategoryType.expenses.value,
      createdAt: transaction.createdAt,
      notes: transaction.notes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final transactionWithCategory = _convertToTransactionWithCategory(
          transaction,
        );
        return TransactionItem(
          theme: theme,
          colorScheme: colorScheme,
          transaction: transactionWithCategory,
        );
      },
    );
  }
}
