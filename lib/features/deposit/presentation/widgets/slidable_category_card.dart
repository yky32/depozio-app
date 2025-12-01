import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';
import 'package:depozio/features/deposit/presentation/widgets/delete_category_dialogs.dart';

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
    required this.categoryService,
    this.onCategoryDeleted,
  });

  final CategoryModel category;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n; // AppLocalizations
  final CategoryService categoryService;
  final Function(CategoryModel)? onCategoryDeleted;

  Future<void> _handleDelete(BuildContext context) async {
    final deletedCategory = category;
    final deleted = await deleteCategoryWithConfirmation(
      context,
      category,
      categoryService,
    );
    // Show undo SnackBar if deletion was successful
    if (deleted && context.mounted) {
      showUndoSnackBar(context, deletedCategory, categoryService);
    }
  }

  Future<void> _handleEdit(BuildContext context) async {
    // TODO: Implement edit functionality
    // For now, show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit "${category.name}" - Coming soon'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleArchive(BuildContext context) async {
    // TODO: Implement archive functionality
    // For now, show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Archive "${category.name}" - Coming soon'),
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
                  category.type == 'deposits' ? 'Deposit' : 'Expense',
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
    );
  }
}
