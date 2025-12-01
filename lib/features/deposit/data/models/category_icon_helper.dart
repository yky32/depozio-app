import 'package:flutter/material.dart';

/// Helper class to map icon indices to IconData constants
/// This ensures tree-shaking works properly in release builds
class CategoryIconHelper {
  // List of available icons (must match the order in add_category_bottom_sheet.dart)
  static const List<IconData> availableIcons = [
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

  /// Get icon by index
  static IconData getIconByIndex(int index) {
    if (index >= 0 && index < availableIcons.length) {
      return availableIcons[index];
    }
    // Default icon if index is out of range
    return Icons.category;
  }

  /// Get index of an icon
  static int getIconIndex(IconData icon) {
    return availableIcons.indexOf(icon);
  }

  /// Check if icon is available
  static bool isValidIcon(IconData icon) {
    return availableIcons.contains(icon);
  }
}
