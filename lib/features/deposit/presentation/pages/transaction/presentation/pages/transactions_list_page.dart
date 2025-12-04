import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/models/transaction_entity.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/services/transaction_service.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/presentation/pages/widgets/transaction_loading_state.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/presentation/pages/widgets/transaction_error_state.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/presentation/pages/widgets/transaction_empty_state.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/presentation/pages/widgets/transactions_list_content.dart';

class TransactionsListPage extends StatelessWidget {
  final String categoryId;

  const TransactionsListPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    // Load category from service
    CategoryService.init();
    final categoryService = CategoryService();
    final category = categoryService.getCategoryById(categoryId);

    if (category == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.transactions_page_title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text(
            'Category not found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<List<TransactionEntity>>(
        future: Future(() {
          TransactionService.init();
          return TransactionService().getTransactionsByCategoryId(categoryId);
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return TransactionLoadingState(colorScheme: colorScheme);
          }

          if (snapshot.hasError) {
            return TransactionErrorState(
              theme: theme,
              colorScheme: colorScheme,
            );
          }

          final transactions = snapshot.data ?? [];

          if (transactions.isEmpty) {
            return TransactionEmptyState(
              theme: theme,
              colorScheme: colorScheme,
            );
          }

          return TransactionsListContent(
            theme: theme,
            colorScheme: colorScheme,
            transactions: transactions,
          );
        },
      ),
    );
  }
}
