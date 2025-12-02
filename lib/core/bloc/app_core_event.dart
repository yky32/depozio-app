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
