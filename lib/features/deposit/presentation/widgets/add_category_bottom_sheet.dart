import 'package:flutter/material.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/features/deposit/data/models/category_model.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';

/// Bottom sheet for adding category that covers the navigation bar
/// This widget is specific to the deposit page
class AddCategoryBottomSheet extends StatelessWidget {
  const AddCategoryBottomSheet({
    super.key,
    this.maxHeightPercentage = 0.9,
  });

  /// Maximum height as a percentage of screen height (0.0 to 1.0)
  /// Default is 0.9 (90%)
  final double maxHeightPercentage;


  // Common icons for categories
  static final List<IconData> _availableIcons = [
    Icons.shopping_cart,
    Icons.restaurant,
    Icons.local_gas_station,
    Icons.movie,
    Icons.sports_soccer,
    Icons.medical_services,
    Icons.school,
    Icons.home,
    Icons.work,
    Icons.flight,
    Icons.shopping_bag,
    Icons.fastfood,
    Icons.directions_car,
    Icons.fitness_center,
    Icons.phone,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * maxHeightPercentage;
    final formKey = GlobalKey<FormState>();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle area
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 80,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Text(
                l10n.add_category_bottom_sheet_title,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Form content
            Flexible(
              child: Form(
                key: formKey,
                child: Builder(
                  builder: (context) {
                    // Use ValueNotifier for state management in StatelessWidget
                    final selectedIconNotifier = ValueNotifier<IconData?>(null);
                    final selectedTypeNotifier = ValueNotifier<String?>(null);
                    final nameController = TextEditingController();
                    final categoryService = CategoryService();

                    return ValueListenableBuilder<IconData?>(
                      valueListenable: selectedIconNotifier,
                      builder: (context, selectedIcon, _) {
                        return ValueListenableBuilder<String?>(
                          valueListenable: selectedTypeNotifier,
                          builder: (context, selectedType, _) {
                            return SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Name input
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: TextFormField(
                                      controller: nameController,
                                      style: theme.textTheme.bodyLarge,
                                      decoration: InputDecoration(
                                        labelText: l10n.add_category_name,
                                        hintText: l10n.add_category_name_hint,
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        filled: true,
                                        fillColor: colorScheme.surface,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 20,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a category name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  // Icon selection
                                  Text(
                                    l10n.add_category_icon,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      // Calculate exact dimensions for 5 columns × 3 rows
                                      final availableWidth =
                                          constraints.maxWidth -
                                              32; // 16px padding on each side
                                      final totalSpacing =
                                          4 * 12; // 4 gaps between 5 columns
                                      final itemSize =
                                          (availableWidth - totalSpacing) / 5;
                                      final totalHeight = (itemSize * 3) +
                                          (2 * 12) +
                                          32; // 3 rows + 2 gaps + padding

                                      return Container(
                                        width: double.infinity,
                                        height: totalHeight,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: colorScheme.surface,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 12,
                                            childAspectRatio: 1,
                                            mainAxisExtent: itemSize,
                                          ),
                                          itemCount: _availableIcons.length,
                                          itemBuilder: (context, index) {
                                            final icon = _availableIcons[index];
                                            final isSelected =
                                                selectedIcon == icon;
                                            return GestureDetector(
                                              onTap: () {
                                                selectedIconNotifier.value =
                                                    icon;
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? colorScheme.primary
                                                          .withValues(
                                                              alpha: 0.1)
                                                      : colorScheme
                                                          .surfaceContainerHighest,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: isSelected
                                                      ? Border.all(
                                                          color: colorScheme
                                                              .primary,
                                                          width: 2,
                                                        )
                                                      : null,
                                                ),
                                                child: Icon(
                                                  icon,
                                                  color: isSelected
                                                      ? colorScheme.primary
                                                      : colorScheme.onSurface
                                                          .withValues(
                                                              alpha: 0.7),
                                                  size: 24,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  if (selectedIcon == null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        'Please select an icon',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color:
                                              Colors.red.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 32),
                                  // Type selection
                                  Text(
                                    l10n.add_category_type,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            selectedTypeNotifier.value =
                                                'deposits';
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 20,
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: selectedType == 'deposits'
                                                  ? colorScheme.primary
                                                      .withValues(alpha: 0.1)
                                                  : colorScheme.surface,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.account_balance_wallet,
                                                  color: selectedType ==
                                                          'deposits'
                                                      ? colorScheme.primary
                                                      : colorScheme.onSurface
                                                          .withValues(
                                                              alpha: 0.7),
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  l10n.add_category_type_deposits,
                                                  style: theme
                                                      .textTheme.bodyLarge
                                                      ?.copyWith(
                                                    fontWeight: selectedType ==
                                                            'deposits'
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                    color: selectedType ==
                                                            'deposits'
                                                        ? colorScheme.primary
                                                        : colorScheme.onSurface,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            selectedTypeNotifier.value =
                                                'expenses';
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 20,
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: selectedType == 'expenses'
                                                  ? colorScheme.primary
                                                      .withValues(alpha: 0.1)
                                                  : colorScheme.surface,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.receipt_long,
                                                  color: selectedType ==
                                                          'expenses'
                                                      ? colorScheme.primary
                                                      : colorScheme.onSurface
                                                          .withValues(
                                                              alpha: 0.7),
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  l10n.add_category_type_expenses,
                                                  style: theme
                                                      .textTheme.bodyLarge
                                                      ?.copyWith(
                                                    fontWeight: selectedType ==
                                                            'expenses'
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                    color: selectedType ==
                                                            'expenses'
                                                        ? colorScheme.primary
                                                        : colorScheme.onSurface,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (selectedType == null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        'Please select a type',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color:
                                              Colors.red.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 32),
                                  // Action buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Text(l10n.action_cancel),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                    .validate() &&
                                                selectedIcon != null &&
                                                selectedType != null) {
                                              // Save category to Hive
                                              final icon = selectedIcon;
                                              final type = selectedType;
                                              final category = CategoryModel(
                                                id: DateTime.now()
                                                    .millisecondsSinceEpoch
                                                    .toString(),
                                                name: nameController.text.trim(),
                                                iconCodePoint: icon.codePoint,
                                                type: type,
                                                createdAt: DateTime.now(),
                                              );

                                              try {
                                                await categoryService
                                                    .addCategory(category);
                                                if (context.mounted) {
                                                  Navigator.of(context).pop();
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Failed to save category: $e'),
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Text(l10n.action_confirm),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
