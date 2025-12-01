import 'package:flutter/material.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';

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

/// Handles the deletion of a category with confirmation dialog
/// Shows a snackbar on successful deletion
Future<void> deleteCategoryWithConfirmation(
  BuildContext context,
  CategoryModel category,
  CategoryService categoryService,
) async {
  final confirmed = await showDeleteCategoryDialog(context, category);

  if (confirmed && context.mounted) {
    await categoryService.deleteCategory(category.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category "${category.name}" deleted'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

