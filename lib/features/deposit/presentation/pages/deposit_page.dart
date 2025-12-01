import 'package:flutter/material.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/features/deposit/presentation/widgets/add_category_bottom_sheet.dart';
import 'package:depozio/features/deposit/presentation/widgets/slidable_category_card.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({super.key});

  void _showAddCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      useRootNavigator: true, // Use root navigator to show above navigation bar
      useSafeArea: false, // Don't use safe area to cover navigation bar
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final keyboardHeight = mediaQuery.viewInsets.bottom;
        final screenHeight = mediaQuery.size.height;
        final hasKeyboard = keyboardHeight > 0;

        // When keyboard is visible, reduce max height to leave space at top for dismissal
        // Reserve about 10% of screen height at the top when keyboard is up
        final maxHeightPercentage = hasKeyboard ? 0.85 : 0.95;
        final topMargin = hasKeyboard ? screenHeight * 0.1 : 0.0;

        return Stack(
          children: [
            // Backdrop to cover navigation bar - tappable to dismiss
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.black.withValues(alpha: 0.5)),
              ),
            ),
            // Bottom sheet content
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: keyboardHeight,
                  top: topMargin,
                ),
                child: AddCategoryBottomSheet(
                  maxHeightPercentage: maxHeightPercentage,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final categoryService = CategoryService();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.deposit_page_title,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: colorScheme.primary,
                    ),
                    onPressed: () => _showAddCategoryBottomSheet(context),
                    tooltip: l10n.deposit_page_add_category,
                  ),
                ],
              ),
            ),
            // Categories list with StreamBuilder
            Expanded(
              child: StreamBuilder<List<CategoryModel>>(
                stream: categoryService.watchAllCategories(),
                initialData: categoryService.getAllCategories(),
                builder: (context, snapshot) {
                  final categories = snapshot.data ?? [];

                  if (categories.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 64,
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No categories yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add a category',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return SlidableCategoryCard(
                        category: category,
                        theme: theme,
                        colorScheme: colorScheme,
                        l10n: l10n,
                        categoryService: categoryService,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
