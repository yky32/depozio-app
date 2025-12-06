import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/presentation/widgets/slidable_category_card.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/services/transaction_service.dart';
import 'package:depozio/features/deposit/presentation/bloc/deposit_bloc.dart';
import 'package:depozio/core/network/logger.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.theme,
    required this.colorScheme,
    required this.l10n,
    required this.categories,
    this.isLoading = false,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n;
  final List<CategoryEntity> categories;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // Initialize TransactionService to get counts
    TransactionService.init();
    final transactionService = TransactionService();

    final listWidget = RefreshIndicator(
      onRefresh: () async {
        LoggerUtil.d('🔄 Pull to refresh triggered');
        context.read<DepositBloc>().add(RefreshDeposits());
        // Wait a bit for the refresh to complete
        await Future.delayed(const Duration(milliseconds: 300));
      },
      color: colorScheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final transactionCount = transactionService
              .getTransactionCountByCategoryId(category.id);
          final totalAmount = transactionService.getTotalAmountByCategoryId(
            category.id,
          );
          return SlidableCategoryCard(
            category: category,
            theme: theme,
            colorScheme: colorScheme,
            l10n: l10n,
            transactionCount: transactionCount,
            totalAmount: totalAmount,
          );
        },
      ),
    );

    if (isLoading) {
      return Skeletonizer(enabled: true, child: listWidget);
    }

    return listWidget;
  }
}
