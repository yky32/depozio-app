part of 'app_core_bloc.dart';

/// Base class for all app core events
abstract class AppCoreEvent extends Equatable {
  const AppCoreEvent();

  @override
  List<Object?> get props => [];
}

// ==================== Locale Events ====================

/// Load the saved locale from storage
class LoadLocale extends AppCoreEvent {
  const LoadLocale();
}

/// Change the app locale
class ChangeLocale extends AppCoreEvent {
  final Locale locale;
  const ChangeLocale({required this.locale});

  @override
  List<Object?> get props => [locale];
}

// ==================== Currency Events ====================

/// Load the saved default currency from storage
class LoadCurrency extends AppCoreEvent {
  const LoadCurrency();
}

/// Change the default currency
class ChangeCurrency extends AppCoreEvent {
  final String currencyCode;
  const ChangeCurrency({required this.currencyCode});

  @override
  List<Object?> get props => [currencyCode];
}

// ==================== Start Date Events ====================

/// Load the saved start date from storage
class LoadStartDate extends AppCoreEvent {
  const LoadStartDate();
}

/// Change the start date (day of month, 1-31)
class ChangeStartDate extends AppCoreEvent {
  final int dayOfMonth;
  const ChangeStartDate({required this.dayOfMonth});

  @override
  List<Object?> get props => [dayOfMonth];
}

// ==================== Recent Activities Count Events ====================

/// Load the saved recent activities count from storage
class LoadRecentActivitiesCount extends AppCoreEvent {
  const LoadRecentActivitiesCount();
}

/// Change the recent activities count (1-100)
class ChangeRecentActivitiesCount extends AppCoreEvent {
  final int count;
  const ChangeRecentActivitiesCount({required this.count});

  @override
  List<Object?> get props => [count];
}

// ==================== Future Events (Examples) ====================
// Uncomment and implement as needed:
//
// /// Change theme mode (light/dark)
// class ChangeThemeMode extends AppCoreEvent {
//   final ThemeMode themeMode;
//   const ChangeThemeMode({required this.themeMode});
//   @override
//   List<Object?> get props => [themeMode];
// }
//
// /// Load app settings
// class LoadAppSettings extends AppCoreEvent {
//   const LoadAppSettings();
// }
