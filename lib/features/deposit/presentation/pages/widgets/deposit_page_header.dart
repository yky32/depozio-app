import 'package:flutter/material.dart';

class DepositPageHeader extends StatelessWidget {
  const DepositPageHeader({
    super.key,
    required this.theme,
    required this.colorScheme,
    required this.l10n,
    required this.onAddCategory,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n;
  final VoidCallback onAddCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            icon: Icon(Icons.add_circle_outline, color: colorScheme.primary),
            onPressed: onAddCategory,
            tooltip: l10n.deposit_page_add_category,
          ),
        ],
      ),
    );
  }
}
