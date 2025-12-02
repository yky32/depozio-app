import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:depozio/core/services/app_setting_service.dart';
import 'package:depozio/core/network/logger.dart';

part 'app_core_event.dart';
part 'app_core_state.dart';

/// Centralized BLoC for managing app-wide core state
/// Currently manages:
/// - Locale/Language preferences
/// Can be extended for:
/// - Theme mode (light/dark)
/// - App version info
/// - User preferences
/// - etc.
class AppCoreBloc extends Bloc<AppCoreEvent, AppCoreState> {
  AppCoreBloc() : super(const AppCoreInitial()) {
    LoggerUtil.i('AppCoreBloc initialized');

    // Locale events
    on<LoadLocale>(_handleLoadLocale);
    on<ChangeLocale>(_handleChangeLocale);
  }

  // ==================== Locale Handlers ====================

  Future<void> _handleLoadLocale(
    LoadLocale event,
    Emitter<AppCoreState> emit,
  ) async {
    try {
      final locale = AppSettingService.getSavedLocale();
      emit(AppCoreLocaleLoaded(locale: locale));
    } catch (e) {
      emit(AppCoreLocaleError(error: e.toString()));
    }
  }

  Future<void> _handleChangeLocale(
    ChangeLocale event,
    Emitter<AppCoreState> emit,
  ) async {
    try {
      emit(const AppCoreLocaleLoading());
      await AppSettingService.saveLocale(event.locale);
      emit(AppCoreLocaleLoaded(locale: event.locale));
      LoggerUtil.d('🌍 Locale changed to: ${event.locale}');
    } catch (e) {
      emit(AppCoreLocaleError(error: e.toString()));
      LoggerUtil.e('❌ Error changing locale: $e');
    }
  }
}
