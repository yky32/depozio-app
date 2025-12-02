import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/presentation/widgets/delete_category_dialogs.dart';
import 'package:depozio/features/deposit/presentation/bloc/deposit_bloc.dart';
import 'package:depozio/features/transaction/presentation/pages/transactions_list_page.dart';
import 'package:depozio/core/network/logger.dart';

/// A professional slidable card widget for category items
/// Swipe left = Edit + Archive
/// Swipe right = Delete (with confirmation)
/// Includes undo functionality
class SlidableCategoryCard extends StatelessWidget {
  const SlidableCategoryCard({
    super.key,
    required this.category,
    required this.theme,
    required this.colorScheme,
    required this.l10n,
  });

  final CategoryModel category;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n; // AppLocalizations

  Future<void> _handleDelete(BuildContext context) async {
    LoggerUtil.d(
      '🗑️ Delete action triggered for category: ${category.name} (id: ${category.id})',
    );

    // Get BLoC reference before showing dialog to avoid context issues
    final bloc = context.read<DepositBloc>();
    LoggerUtil.d('✅ BLoC obtained for delete operation');
    final deletedCategory = category;

    // Show confirmation dialog
    LoggerUtil.d('💬 Showing delete confirmation dialog');
    final confirmed = await showDeleteCategoryDialog(context, category);

    if (!confirmed) {
      LoggerUtil.d('❌ Delete cancelled by user');
      return;
    }

    LoggerUtil.i('✅ Delete confirmed, dispatching DeleteCategory event');
    try {
      // Delete via BLoC
      bloc.add(DeleteCategory(categoryId: category.id));
      LoggerUtil.d('📤 DeleteCategory event dispatched');

      // Show undo SnackBar
      if (context.mounted) {
        LoggerUtil.d('📢 Showing undo snackbar');
        showUndoSnackBar(
          context,
          deletedCategory,
          onCategoryRestored: () {
            LoggerUtil.i(
              '↩️ Undo clicked, restoring category: ${deletedCategory.name}',
            );
            bloc.add(RestoreCategory(category: deletedCategory));
          },
        );
      } else {
        LoggerUtil.w('⚠️ Context not mounted, skipping snackbar');
      }
    } catch (e, stackTrace) {
      LoggerUtil.e(
        '❌ Error in delete handler',
        error: e,
        stackTrace: stackTrace,
      );
      if (context.mounted) {
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.delete_category_error(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleEdit(BuildContext context) async {
    // TODO: Implement edit functionality
    // For now, show a placeholder
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.slidable_category_edit_coming_soon(category.name)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleArchive(BuildContext context) async {
    // TODO: Implement archive functionality
    // For now, show a placeholder
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.slidable_category_archive_coming_soon(category.name),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Slidable(
          key: ValueKey(category.id),
          // Swipe LEFT = Edit + Archive
          startActionPane: ActionPane(
            motion: const StretchMotion(),
            extentRatio: 0.3,
            children: [
              SlidableAction(
                onPressed: _handleEdit,
                backgroundColor: Colors.transparent,
                foregroundColor: colorScheme.primary,
                icon: Icons.edit_outlined,
                flex: 1,
                spacing: 0,
                padding: EdgeInsets.zero,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                autoClose: false,
              ),
              SlidableAction(
                onPressed: _handleArchive,
                backgroundColor: Colors.transparent,
                foregroundColor: colorScheme.secondary,
                icon: Icons.archive_outlined,
                flex: 1,
                spacing: 0,
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.zero,
                autoClose: false,
              ),
            ],
          ),
          // Swipe RIGHT = Delete
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: _handleDelete,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.red,
                icon: Icons.delete_outline,
                flex: 1,
                spacing: 0,
                padding: EdgeInsets.zero,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                autoClose: true,
              ),
            ],
          ),
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TransactionsListPage(
                      category: category,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  category.icon,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              title: Text(
                category.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                category.type == 'deposits'
                    ? l10n.add_category_type_deposits
                    : l10n.add_category_type_expenses,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      category.type == 'deposits'
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category.type == 'deposits'
                      ? l10n.slidable_category_type_deposit
                      : l10n.slidable_category_type_expense,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        category.type == 'deposits' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}
