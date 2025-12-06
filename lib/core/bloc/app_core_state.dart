part of 'app_core_bloc.dart';

/// Base class for all app core states
abstract class AppCoreState extends Equatable {
  const AppCoreState();

  @override
  List<Object?> get props => [];
}

// ==================== Initial State ====================

class AppCoreInitial extends AppCoreState {
  const AppCoreInitial();
}

// ==================== Locale States ====================

class AppCoreLocaleLoading extends AppCoreState {
  const AppCoreLocaleLoading();
}

class AppCoreLocaleLoaded extends AppCoreState {
  final Locale? locale;
  const AppCoreLocaleLoaded({required this.locale});

  @override
  List<Object?> get props => [locale];
}

class AppCoreLocaleError extends AppCoreState {
  final String error;
  const AppCoreLocaleError({required this.error});

  @override
  List<Object?> get props => [error];
}

// ==================== Currency States ====================

class AppCoreCurrencyLoading extends AppCoreState {
  const AppCoreCurrencyLoading();
}

class AppCoreCurrencyLoaded extends AppCoreState {
  final String currencyCode;
  const AppCoreCurrencyLoaded({required this.currencyCode});

  @override
  List<Object?> get props => [currencyCode];
}

class AppCoreCurrencyError extends AppCoreState {
  final String error;
  const AppCoreCurrencyError({required this.error});

  @override
  List<Object?> get props => [error];
}

// ==================== Combined Settings State ====================

/// Combined state that holds both locale and currency
/// This prevents one state from replacing the other
class AppCoreSettingsLoaded extends AppCoreState {
  final Locale? locale;
  final String currencyCode;
  final int startDate;
  final int recentActivitiesCount;
  const AppCoreSettingsLoaded({
    required this.locale,
    required this.currencyCode,
    required this.startDate,
    required this.recentActivitiesCount,
  });

  @override
  List<Object?> get props => [
    locale,
    currencyCode,
    startDate,
    recentActivitiesCount,
  ];
}

// ==================== Future States (Examples) ====================
// Uncomment and implement as needed:
//
// class AppCoreThemeLoaded extends AppCoreState {
//   final ThemeMode themeMode;
//   const AppCoreThemeLoaded({required this.themeMode});
//   @override
//   List<Object?> get props => [themeMode];
// }
//
// class AppCoreSettingsLoaded extends AppCoreState {
//   final Map<String, dynamic> settings;
//   const AppCoreSettingsLoaded({required this.settings});
//   @override
//   List<Object?> get props => [settings];
// }
