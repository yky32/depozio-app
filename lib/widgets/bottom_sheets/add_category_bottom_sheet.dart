import 'package:flutter/material.dart';
import 'package:depozio/core/extensions/localizations.dart';

/// Bottom sheet for adding category that covers the navigation bar
class AddCategoryBottomSheet extends StatefulWidget {
  const AddCategoryBottomSheet({
    super.key,
    this.maxHeightPercentage = 0.9,
  });

  /// Maximum height as a percentage of screen height (0.0 to 1.0)
  /// Default is 0.9 (90%)
  final double maxHeightPercentage;

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedIcon;
  String? _selectedType;

  // Common icons for categories
  final List<IconData> _availableIcons = [
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
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * widget.maxHeightPercentage;

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
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Text(
                l10n.add_category_bottom_sheet_title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Form content
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name input card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.add_category_name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _nameController,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                hintText: l10n.add_category_name_hint,
                                border: InputBorder.none,
                                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a category name';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Icon selection card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.add_category_icon,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: _availableIcons.map((icon) {
                                final isSelected =
                                    _selectedIcon == icon.codePoint.toString();
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIcon = icon.codePoint.toString();
                                    });
                                  },
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? colorScheme.primary
                                              .withValues(alpha: 0.1)
                                          : colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(12),
                                      border: isSelected
                                          ? Border.all(
                                              color: colorScheme.primary,
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                    child: Icon(
                                      icon,
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.onSurface
                                              .withValues(alpha: 0.7),
                                      size: 24,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            if (_selectedIcon == null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Please select an icon',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.red.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Type selection card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.add_category_type,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedType = 'deposits';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      decoration: BoxDecoration(
                                        color: _selectedType == 'deposits'
                                            ? colorScheme.primary
                                                .withValues(alpha: 0.1)
                                            : colorScheme
                                                .surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(12),
                                        border: _selectedType == 'deposits'
                                            ? Border.all(
                                                color: colorScheme.primary,
                                                width: 2,
                                              )
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.account_balance_wallet,
                                            color: _selectedType == 'deposits'
                                                ? colorScheme.primary
                                                : colorScheme.onSurface
                                                    .withValues(alpha: 0.7),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            l10n.add_category_type_deposits,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: _selectedType == 'deposits'
                                                  ? colorScheme.primary
                                                  : colorScheme.onSurface,
                                              fontWeight:
                                                  _selectedType == 'deposits'
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
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
                                      setState(() {
                                        _selectedType = 'expenses';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      decoration: BoxDecoration(
                                        color: _selectedType == 'expenses'
                                            ? colorScheme.primary
                                                .withValues(alpha: 0.1)
                                            : colorScheme
                                                .surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(12),
                                        border: _selectedType == 'expenses'
                                            ? Border.all(
                                                color: colorScheme.primary,
                                                width: 2,
                                              )
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.receipt_long,
                                            color: _selectedType == 'expenses'
                                                ? colorScheme.primary
                                                : colorScheme.onSurface
                                                    .withValues(alpha: 0.7),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            l10n.add_category_type_expenses,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: _selectedType == 'expenses'
                                                  ? colorScheme.primary
                                                  : colorScheme.onSurface,
                                              fontWeight:
                                                  _selectedType == 'expenses'
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_selectedType == null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Please select a type',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.red.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(l10n.action_cancel),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    _selectedIcon != null &&
                                    _selectedType != null) {
                                  // TODO: Save category
                                  Navigator.of(context).pop();
                                } else {
                                  setState(() {});
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
