import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart' as hive;

/// Centralized service for managing app settings (locale, currency, etc.)
class AppSettingService {
  static const String _boxName = 'app_settings';
  static const String _localeKey = 'locale';
  static const String _defaultCurrencyKey = 'default_currency';
  static const String _currencyOrderKey = 'currency_order';
  static const String _usernameKey = 'username';
  static const String _startDateKey = 'start_date';
  static const String _lastDescriptionsKey = 'last_descriptions';
  static const String _lastAmountsKey = 'last_amounts';
  static const String _defaultCurrency =
      'HKD'; // Default fallback (Hong Kong Dollar)
  static const int _defaultStartDate = 1; // Default to 1st of the month
  static const int _maxLastDescriptions =
      5; // Maximum number of last descriptions to store
  static const int _maxLastAmounts =
      5; // Maximum number of last amounts to store

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

  /// Get saved currency order (list of currency codes)
  /// Returns null if no custom order is saved
  static List<String>? getCurrencyOrder() {
    if (_box == null) return null;
    final order = _box!.get(_currencyOrderKey);
    if (order is List) {
      return order.cast<String>();
    }
    return null;
  }

  /// Save currency order (list of currency codes)
  static Future<void> saveCurrencyOrder(List<String> currencyOrder) async {
    if (_box == null) {
      await init();
    }
    await _box!.put(_currencyOrderKey, currencyOrder);
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

  // ==================== Start Date Methods ====================

  /// Get saved start date (day of month, 1-31)
  static int getStartDate() {
    if (_box == null) return _defaultStartDate;
    final startDate = _box!.get(_startDateKey) as int?;
    return startDate ?? _defaultStartDate;
  }

  /// Save start date preference (day of month, 1-31)
  static Future<void> saveStartDate(int dayOfMonth) async {
    if (_box == null) {
      await init();
    }
    // Validate day is between 1 and 31
    final validDay = dayOfMonth.clamp(1, 31);
    await _box!.put(_startDateKey, validDay);
  }

  // ==================== Last Descriptions Methods ====================

  /// Get last descriptions (up to 5)
  static List<String> getLastDescriptions() {
    if (_box == null) return [];
    final descriptions = _box!.get(_lastDescriptionsKey);
    if (descriptions is List) {
      return descriptions.cast<String>();
    }
    return [];
  }

  /// Save a description to the last descriptions list
  /// Keeps only the last 5 unique descriptions
  static Future<void> saveLastDescription(String description) async {
    if (_box == null) {
      await init();
    }

    // Trim and validate description
    final trimmedDescription = description.trim();
    if (trimmedDescription.isEmpty) return;

    // Get current list
    final currentList = getLastDescriptions();

    // Remove if already exists (to move to front)
    final updatedList =
        currentList.where((d) => d != trimmedDescription).toList();

    // Add to front
    updatedList.insert(0, trimmedDescription);

    // Keep only last 5
    final finalList = updatedList.take(_maxLastDescriptions).toList();

    await _box!.put(_lastDescriptionsKey, finalList);
  }

  // ==================== Last Amounts Methods ====================

  /// Get last amounts with currency (up to 5)
  /// Returns list of maps with 'amount' and 'currencyCode' keys
  static List<Map<String, String>> getLastAmounts() {
    if (_box == null) return [];
    final amounts = _box!.get(_lastAmountsKey);
    if (amounts is List) {
      return amounts
          .whereType<Map>()
          .map((map) => Map<String, String>.from(map))
          .where(
            (map) =>
                map.containsKey('amount') && map.containsKey('currencyCode'),
          )
          .toList();
    }
    return [];
  }

  /// Save an amount-currency pair to the last amounts list
  /// Keeps only the last 5 unique pairs
  static Future<void> saveLastAmount(String amount, String currencyCode) async {
    if (_box == null) {
      await init();
    }

    // Trim and validate amount
    final trimmedAmount = amount.trim();
    if (trimmedAmount.isEmpty) return;

    // Get current list
    final currentList = getLastAmounts();

    // Remove if same pair already exists (to move to front)
    final updatedList =
        currentList
            .where(
              (pair) =>
                  pair['amount'] != trimmedAmount ||
                  pair['currencyCode'] != currencyCode,
            )
            .toList();

    // Add to front
    updatedList.insert(0, {
      'amount': trimmedAmount,
      'currencyCode': currencyCode,
    });

    // Keep only last 5
    final finalList = updatedList.take(_maxLastAmounts).toList();

    await _box!.put(_lastAmountsKey, finalList);
  }
}
