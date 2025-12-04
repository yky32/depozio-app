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
/// - Currency preferences
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
    
    // Currency events
    on<LoadCurrency>(_handleLoadCurrency);
    on<ChangeCurrency>(_handleChangeCurrency);
    
    // Start date events
    on<LoadStartDate>(_handleLoadStartDate);
    on<ChangeStartDate>(_handleChangeStartDate);
  }

  // ==================== Locale Handlers ====================

  Future<void> _handleLoadLocale(
    LoadLocale event,
    Emitter<AppCoreState> emit,
  ) async {
    try {
      final locale = AppSettingService.getSavedLocale();
      final currencyCode = AppSettingService.getDefaultCurrency();
      final startDate = AppSettingService.getStartDate();
      emit(AppCoreSettingsLoaded(
        locale: locale,
        currencyCode: currencyCode,
        startDate: startDate,
      ));
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
      // Preserve currency and start date when changing locale
      final currencyCode = AppSettingService.getDefaultCurrency();
      final startDate = AppSettingService.getStartDate();
      emit(AppCoreSettingsLoaded(
        locale: event.locale,
        currencyCode: currencyCode,
        startDate: startDate,
      ));
      LoggerUtil.d('🌍 Locale changed to: ${event.locale}');
    } catch (e) {
      emit(AppCoreLocaleError(error: e.toString()));
      LoggerUtil.e('❌ Error changing locale: $e');
    }
  }

  // ==================== Currency Handlers ====================

  Future<void> _handleLoadCurrency(
    LoadCurrency event,
    Emitter<AppCoreState> emit,
  ) async {
    try {
      final currencyCode = AppSettingService.getDefaultCurrency();
      // Preserve locale and start date when loading currency
      final locale = AppSettingService.getSavedLocale();
      final startDate = AppSettingService.getStartDate();
      emit(AppCoreSettingsLoaded(
        locale: locale,
        currencyCode: currencyCode,
        startDate: startDate,
      ));
      LoggerUtil.d('💰 Currency loaded: $currencyCode');
    } catch (e) {
      emit(AppCoreCurrencyError(error: e.toString()));
      LoggerUtil.e('❌ Error loading currency: $e');
    }
  }

  Future<void> _handleChangeCurrency(
    ChangeCurrency event,
    Emitter<AppCoreState> emit,
  ) async {
    try {
      emit(const AppCoreCurrencyLoading());
      await AppSettingService.saveDefaultCurrency(event.currencyCode);
      // Preserve locale and start date when changing currency
      final locale = AppSettingService.getSavedLocale();
      final startDate = AppSettingService.getStartDate();
      emit(AppCoreSettingsLoaded(
        locale: locale,
        currencyCode: event.currencyCode,
        startDate: startDate,
      ));
      LoggerUtil.d('💰 Currency changed to: ${event.currencyCode}');
    } catch (e) {
      emit(AppCoreCurrencyError(error: e.toString()));
      LoggerUtil.e('❌ Error changing currency: $e');
    }
  }

  // ==================== Start Date Handlers ====================

  Future<void> _handleLoadStartDate(
    LoadStartDate event,
    Emitter<AppCoreState> emit,
  ) async {
    try {
      final startDate = AppSettingService.getStartDate();
      // Preserve locale and currency when loading start date
      final locale = AppSettingService.getSavedLocale();
      final currencyCode = AppSettingService.getDefaultCurrency();
      emit(AppCoreSettingsLoaded(
        locale: locale,
        currencyCode: currencyCode,
        startDate: startDate,
      ));
      LoggerUtil.d('📅 Start date loaded: $startDate');
    } catch (e) {
      LoggerUtil.e('❌ Error loading start date: $e');
    }
  }

  Future<void> _handleChangeStartDate(
    ChangeStartDate event,
    Emitter<AppCoreState> emit,
  ) async {
    try {
      await AppSettingService.saveStartDate(event.dayOfMonth);
      // Preserve locale and currency when changing start date
      final locale = AppSettingService.getSavedLocale();
      final currencyCode = AppSettingService.getDefaultCurrency();
      emit(AppCoreSettingsLoaded(
        locale: locale,
        currencyCode: currencyCode,
        startDate: event.dayOfMonth,
      ));
      LoggerUtil.d('📅 Start date changed to: ${event.dayOfMonth}');
    } catch (e) {
      LoggerUtil.e('❌ Error changing start date: $e');
    }
  }
}
