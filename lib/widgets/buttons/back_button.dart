import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A reusable back button widget
class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
    this.onPressed,
    this.icon,
    this.color,
    this.size,
  });

  /// Custom callback when button is pressed
  /// If null, will use default navigation back behavior
  final VoidCallback? onPressed;

  /// Custom icon for the back button
  /// Defaults to Icons.chevron_left
  final IconData? icon;

  /// Color of the back button icon
  final Color? color;

  /// Size of the back button icon
  final double? size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return IconButton(
      icon: Icon(
        icon ?? Icons.chevron_left,
        color: color ?? colorScheme.onSurface,
        size: size ?? 28,
      ),
      onPressed: onPressed ?? () => context.pop(),
      tooltip: 'Back',
    );
  }
}
