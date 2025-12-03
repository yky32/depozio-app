/// Enum for category types
enum CategoryType {
  deposits,
  expenses;

  /// Convert enum to string value (for Hive storage)
  String get value {
    switch (this) {
      case CategoryType.deposits:
        return 'deposits';
      case CategoryType.expenses:
        return 'expenses';
    }
  }

  /// Create enum from string value
  static CategoryType fromString(String value) {
    switch (value) {
      case 'deposits':
        return CategoryType.deposits;
      case 'expenses':
        return CategoryType.expenses;
      default:
        return CategoryType.expenses; // Default fallback
    }
  }
}
