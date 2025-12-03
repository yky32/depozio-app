import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  const StatisticCard({
    super.key,
    required this.theme,
    required this.colorScheme,
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor,
    this.topRightIcon,
    this.topRightIconColor,
    this.topRightIconBackgroundColor,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final String title;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final IconData? topRightIcon;
  final Color? topRightIconColor;
  final Color? topRightIconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.all(14),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          // Top right corner icon
          if (topRightIcon != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: topRightIconBackgroundColor ?? Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  topRightIcon,
                  size: 14,
                  color: topRightIconColor ?? colorScheme.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
