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

    // Recent activities count events
    on<LoadRecentActivitiesCount>(_handleLoadRecentActivitiesCount);
    on<ChangeRecentActivitiesCount>(_handleChangeRecentActivitiesCount);
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
      final recentActivitiesCount =
          AppSettingService.getRecentActivitiesCount();
      emit(
        AppCoreSettingsLoaded(
          locale: locale,
          currencyCode: currencyCode,
          startDate: startDate,
          recentActivitiesCount: recentActivitiesCount,
        ),
      );
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
      // Preserve currency, start date, and recent activities count when changing locale
      final currencyCode = AppSettingService.getDefaultCurrency();
      final startDate = AppSettingService.getStartDate();
      final recentActivitiesCount =
          AppSettingService.getRecentActivitiesCount();
      emit(
        AppCoreSettingsLoaded(
          locale: event.locale,
          currencyCode: currencyCode,
          startDate: startDate,
          recentActivitiesCount: recentActivitiesCount,
        ),
      );
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
      // Preserve locale, start date, and recent activities count when loading currency
      final locale = AppSettingService.getSavedLocale();
      final startDate = AppSettingService.getStartDate();
      final recentActivitiesCount =
          AppSettingService.getRecentActivitiesCount();
      emit(
        AppCoreSettingsLoaded(
          locale: locale,
          currencyCode: currencyCode,
          startDate: startDate,
          recentActivitiesCount: recentActivitiesCount,
        ),
      );
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
      // Preserve locale, start date, and recent activities count when changing currency
      final locale = AppSettingService.getSavedLocale();
      final startDate = AppSettingService.getStartDate();
      final recentActivitiesCount =
          AppSettingService.getRecentActivitiesCount();
      emit(
        AppCoreSettingsLoaded(
          locale: locale,
          currencyCode: event.currencyCode,
          startDate: startDate,
          recentActivitiesCount: recentActivitiesCount,
        ),
      );
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
      // Preserve locale, currency, and recent activities count when loading start date
      final locale = AppSettingService.getSavedLocale();
      final currencyCode = AppSettingService.getDefaultCurrency();
      final recentActivitiesCount =
          AppSettingService.getRecentActivitiesCount();
      emit(
        AppCoreSettingsLoaded(
          locale: locale,
          currencyCode: currencyCode,
          startDate: startDate,
          recentActivitiesCount: recentActivitiesCount,
        ),
      );
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
      // Preserve locale, currency, and recent activities count when changing start date
      final locale = AppSettingService.getSavedLocale();
      final currencyCode = AppSettingService.getDefaultCurrency();
      final recentActivitiesCount =
          AppSettingService.getRecentActivitiesCount();
      emit(
        AppCoreSettingsLoaded(
          locale: locale,
          currencyCode: currencyCode,
          startDate: event.dayOfMonth,
          recentActivitiesCount: recentActivitiesCount,
        ),
      );
      LoggerUtil.d('📅 Start date changed to: ${event.dayOfMonth}');
    } catch (e) {
      LoggerUtil.e('❌ Error changing start date: $e');
    }
  }

  // ==================== Recent Activities Count Handlers ====================

  Future<void> _handleLoadRecentActivitiesCount(
    LoadRecentActivitiesCount event,
    Emitter<AppCoreState> emit,
  ) async {
    try {
      final recentActivitiesCount =
          AppSettingService.getRecentActivitiesCount();
      // Preserve locale, currency, and start date when loading recent activities count
      final locale = AppSettingService.getSavedLocale();
      final currencyCode = AppSettingService.getDefaultCurrency();
      final startDate = AppSettingService.getStartDate();
      emit(
        AppCoreSettingsLoaded(
          locale: locale,
          currencyCode: currencyCode,
          startDate: startDate,
          recentActivitiesCount: recentActivitiesCount,
        ),
      );
      LoggerUtil.d('📊 Recent activities count loaded: $recentActivitiesCount');
    } catch (e) {
      LoggerUtil.e('❌ Error loading recent activities count: $e');
    }
  }

  Future<void> _handleChangeRecentActivitiesCount(
    ChangeRecentActivitiesCount event,
    Emitter<AppCoreState> emit,
  ) async {
    try {
      await AppSettingService.saveRecentActivitiesCount(event.count);
      // Preserve locale, currency, and start date when changing recent activities count
      final locale = AppSettingService.getSavedLocale();
      final currencyCode = AppSettingService.getDefaultCurrency();
      final startDate = AppSettingService.getStartDate();
      emit(
        AppCoreSettingsLoaded(
          locale: locale,
          currencyCode: currencyCode,
          startDate: startDate,
          recentActivitiesCount: event.count,
        ),
      );
      LoggerUtil.d('📊 Recent activities count changed to: ${event.count}');
    } catch (e) {
      LoggerUtil.e('❌ Error changing recent activities count: $e');
    }
  }
}
