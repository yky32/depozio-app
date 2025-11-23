import 'package:flutter/material.dart';

/// A circular action button with "+" symbol, specifically for navigation bars
class NavBarActionButton extends StatelessWidget {
  const NavBarActionButton({
    super.key,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size,
  });

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Custom icon for the button
  /// Defaults to Icons.add
  final IconData? icon;

  /// Background color of the button
  /// Defaults to Pantone red/pink color
  final Color? backgroundColor;

  /// Color of the icon
  /// Defaults to white
  final Color? iconColor;

  /// Size of the button (width and height)
  /// Defaults to 56
  final double? size;

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 56;
    // Default to Pantone red/pink color with transparency, or use custom color
    final bgColor = backgroundColor ??
        const Color(0xFFE91E63)
            .withValues(alpha: 0.7); // Pantone-style red/pink with transparency
    final iconClr = iconColor ?? Colors.white;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: bgColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon ?? Icons.add,
          color: iconClr,
          size: buttonSize * 0.5, // Icon size is half of button size
        ),
      ),
    );
  }
}
