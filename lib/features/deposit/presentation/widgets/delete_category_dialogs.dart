import 'package:flutter/material.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';

/// Shows a confirmation dialog for deleting a category
/// Returns true if the user confirmed the deletion, false otherwise
Future<bool> showDeleteCategoryDialog(
  BuildContext context,
  CategoryModel category,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Category'),
      content: Text(
        'Are you sure you want to delete "${category.name}"?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
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

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Category "${deletedCategory.name}" deleted'),
      duration: const Duration(seconds: 4),
      backgroundColor: colorScheme.surfaceContainerHighest,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: colorScheme.primary,
        onPressed: () {
          // Trigger callback to restore via BLoC
          onCategoryRestored();
        },
      ),
    ),
  );
}

