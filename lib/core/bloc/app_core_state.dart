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
