import 'package:flutter/material.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';

/// Shows a confirmation dialog for deleting a category
/// Returns true if the user confirmed the deletion, false otherwise
Future<bool> showDeleteCategoryDialog(
  BuildContext context,
  CategoryEntity category,
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

/// Shows an undo Flash toast after category deletion
/// Note: Flash toast removed - category deletion happens silently
void showUndoSnackBar(
  BuildContext context,
  CategoryEntity deletedCategory, {
  required VoidCallback onCategoryRestored,
}) {
  // Flash toast removed - category deletion happens silently
  // The undo functionality can be restored if needed in the future
}
