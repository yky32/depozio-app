import 'package:flutter/material.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/models/transaction_entity.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/presentation/pages/widgets/transaction_card_item.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionCardItem(
          theme: theme,
          colorScheme: colorScheme,
          transaction: transaction,
        );
      },
    );
  }
}
