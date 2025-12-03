import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart' as hive;

/// Centralized service for managing app settings (locale, currency, etc.)
class AppSettingService {
  static const String _boxName = 'app_settings';
  static const String _localeKey = 'locale';
  static const String _defaultCurrencyKey = 'default_currency';
  static const String _usernameKey = 'username';
  static const String _defaultCurrency =
      'HKD'; // Default fallback (Hong Kong Dollar)

  static hive.Box? _box;
  static bool _initialized = false;
  static final List<VoidCallback> _localeListeners = [];

  /// Initialize the Hive box for app settings
  static Future<void> init() async {
    if (_initialized && _box != null) {
      return;
    }
    _box = await hive.Hive.openBox(_boxName);
    _initialized = true;
  }

  // ==================== Locale Methods ====================

  /// Get saved locale
  static Locale? getSavedLocale() {
    if (_box == null) return null;
    final localeString = _box!.get(_localeKey) as String?;
    if (localeString == null) return null;

    // Parse locale string (e.g., "en", "zh", "zh_TW")
    if (localeString == 'zh_TW' || localeString == 'zh-TW') {
      return const Locale('zh', 'TW');
    } else if (localeString == 'zh' ||
        localeString == 'zh_CN' ||
        localeString == 'zh-CN') {
      return const Locale('zh');
    } else {
      return const Locale('en');
    }
  }

  /// Save locale preference
  static Future<void> saveLocale(Locale locale) async {
    if (_box == null) {
      await init();
    }
    String localeString;
    if (locale.countryCode == 'TW') {
      localeString = 'zh_TW';
    } else if (locale.languageCode == 'zh') {
      localeString = 'zh';
    } else {
      localeString = 'en';
    }
    await _box!.put(_localeKey, localeString);
  }

  /// Notify listeners of locale change
  static void notifyLocaleChanged() {
    debugPrint(
      '🔔 Notifying ${_localeListeners.length} listeners of locale change',
    );
    for (final listener in _localeListeners) {
      listener();
    }
  }

  /// Add a listener for locale changes
  static void addLocaleListener(VoidCallback listener) {
    _localeListeners.add(listener);
  }

  /// Remove a locale listener
  static void removeLocaleListener(VoidCallback listener) {
    _localeListeners.remove(listener);
  }

  /// Get locale display name
  static String getLocaleDisplayName(Locale locale) {
    if (locale.countryCode == 'TW') {
      return 'Chinese (Traditional)';
    } else if (locale.languageCode == 'zh') {
      return 'Chinese (Simplified)';
    } else {
      return 'English';
    }
  }

  /// Get all supported locales
  static List<Locale> getSupportedLocales() {
    return [const Locale('en'), const Locale('zh'), const Locale('zh', 'TW')];
  }

  // ==================== Currency Methods ====================

  /// Get saved default currency
  static String getDefaultCurrency() {
    if (_box == null) return _defaultCurrency;
    final currencyCode = _box!.get(_defaultCurrencyKey) as String?;
    return currencyCode ?? _defaultCurrency;
  }

  /// Save default currency preference
  static Future<void> saveDefaultCurrency(String currencyCode) async {
    if (_box == null) {
      await init();
    }
    await _box!.put(_defaultCurrencyKey, currencyCode);
  }

  // ==================== Username Methods ====================

  /// Get saved username
  static String? getUsername() {
    if (_box == null) return null;
    return _box!.get(_usernameKey) as String?;
  }

  /// Save username
  static Future<void> saveUsername(String username) async {
    if (_box == null) {
      await init();
    }
    await _box!.put(_usernameKey, username);
  }
}
