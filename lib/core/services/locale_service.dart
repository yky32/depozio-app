import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart' as hive;

class LocaleService {
  static const String _boxName = 'app_settings';
  static const String _localeKey = 'locale';
  static hive.Box? _box;
  static bool _initialized = false;
  static final List<VoidCallback> _listeners = [];

  /// Initialize the Hive box for app settings
  static Future<void> init() async {
    if (_initialized && _box != null) {
      return;
    }
    _box = await hive.Hive.openBox(_boxName);
    _initialized = true;
  }

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
    debugPrint('🔔 Notifying ${_listeners.length} listeners of locale change');
    for (final listener in _listeners) {
      listener();
    }
  }

  /// Add a listener for locale changes
  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Remove a listener
  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
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
}
