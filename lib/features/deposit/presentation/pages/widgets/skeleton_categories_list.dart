import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/presentation/widgets/slidable_category_card.dart';
import 'package:depozio/core/network/logger.dart';
import 'package:depozio/core/enum/category_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/features/deposit/presentation/bloc/deposit_bloc.dart';

class SkeletonCategoriesList extends StatelessWidget {
  const SkeletonCategoriesList({
    super.key,
    required this.theme,
    required this.colorScheme,
    required this.l10n,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: RefreshIndicator(
        onRefresh: () async {
          LoggerUtil.d('🔄 Pull to refresh triggered (skeleton)');
          context.read<DepositBloc>().add(RefreshDeposits());
          await Future.delayed(const Duration(milliseconds: 300));
        },
        color: colorScheme.primary,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 5, // Show 5 skeleton cards
          itemBuilder: (context, index) {
            // Create a dummy category for skeleton
            final dummyCategory = CategoryEntity(
              id: 'skeleton_$index',
              name: 'Loading Category Name',
              iconIndex: 0, // Default icon index
              type: CategoryType.deposits.value,
              createdAt: DateTime.now(),
            );
            return SlidableCategoryCard(
              category: dummyCategory,
              theme: theme,
              colorScheme: colorScheme,
              l10n: l10n,
              transactionCount: 0,
            );
          },
        ),
      ),
    );
  }
}
