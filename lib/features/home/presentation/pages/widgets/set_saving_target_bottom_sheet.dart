import 'package:flutter/material.dart';

/// Bottom sheet for setting saving target
/// This widget is specific to the home page
class SetSavingTargetBottomSheet extends StatelessWidget {
  const SetSavingTargetBottomSheet({super.key, this.maxHeightPercentage = 0.9});

  /// Maximum height as a percentage of screen height (0.0 to 1.0)
  /// Default is 0.9 (90%)
  final double maxHeightPercentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    final availableHeight = screenHeight - keyboardHeight;
    final maxHeight = (screenHeight * maxHeightPercentage).clamp(
      0.0,
      availableHeight,
    );

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              alignment: Alignment.center,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Text(
              'Set Saving Target',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              padding: EdgeInsets.fromLTRB(24, 0, 24, keyboardHeight > 0 ? 16 : 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Blank content - to be filled later
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

