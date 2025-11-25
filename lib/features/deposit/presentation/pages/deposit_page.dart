import 'package:flutter/material.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/widgets/bottom_sheets/add_category_bottom_sheet.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        isDismissible: true,
                        enableDrag: true,
                        useRootNavigator: true,
                        builder: (context) => const AddCategoryBottomSheet(
                          maxHeightPercentage: 0.9,
                        ),
                      );
                    },
                    tooltip: l10n.deposit_page_add_category,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
