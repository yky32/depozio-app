import 'package:flutter/material.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';

/// Shows a confirmation dialog for deleting a category
/// Returns true if the user confirmed the deletion, false otherwise
Future<bool> showDeleteCategoryDialog(
  BuildContext context,
  CategoryModel category,
) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(l10n.delete_category_dialog_title),
          content: Text(l10n.delete_category_dialog_message(category.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.action_cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.delete_category_action),
            ),
          ],
        ),
  );

  return confirmed ?? false;
}

/// Shows an undo SnackBar after category deletion
void showUndoSnackBar(
  BuildContext context,
  CategoryModel deletedCategory, {
  required VoidCallback onCategoryRestored,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  final l10n = context.l10n;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(l10n.delete_category_snackbar(deletedCategory.name)),
      duration: const Duration(seconds: 4),
      backgroundColor: colorScheme.surfaceContainerHighest,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      action: SnackBarAction(
        label: l10n.delete_category_undo,
        textColor: colorScheme.primary,
        onPressed: () {
          // Trigger callback to restore via BLoC
          onCategoryRestored();
        },
      ),
    ),
  );
}
