import 'package:depozio/core/localization/app_localizations.dart';

/// Helper class for currency-related utilities
class CurrencyHelper {
  // Supported currencies with flags
  static const Map<String, String> currencies = {
    'USD': '🇺🇸', // US Dollar
    'EUR': '🇪🇺', // Euro
    'GBP': '🇬🇧', // British Pound
    'JPY': '🇯🇵', // Japanese Yen
    'CNY': '🇨🇳', // Chinese Yuan
    'HKD': '🇭🇰', // Hong Kong Dollar
    'SGD': '🇸🇬', // Singapore Dollar
    'THB': '🇹🇭', // Thai Baht
    'KRW': '🇰🇷', // South Korean Won
    'AUD': '🇦🇺', // Australian Dollar
    'CAD': '🇨🇦', // Canadian Dollar
  };

  static const Map<String, String> currencySymbols = {
    'USD': r'$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CNY': '¥',
    'HKD': r'$',
    'SGD': r'S$',
    'THB': '฿',
    'KRW': '₩',
    'AUD': r'A$',
    'CAD': r'C$',
  };

  static const Map<String, String> currencyNameKeys = {
    'USD': 'currency_usd',
    'EUR': 'currency_eur',
    'GBP': 'currency_gbp',
    'JPY': 'currency_jpy',
    'CNY': 'currency_cny',
    'HKD': 'currency_hkd',
    'SGD': 'currency_sgd',
    'THB': 'currency_thb',
    'KRW': 'currency_krw',
    'AUD': 'currency_aud',
    'CAD': 'currency_cad',
  };

  static String getFlag(String currencyCode) {
    return currencies[currencyCode] ?? '🇺🇸';
  }

  static String getSymbol(String currencyCode) {
    return currencySymbols[currencyCode] ?? '\$';
  }

  static String getNameKey(String currencyCode) {
    return currencyNameKeys[currencyCode] ?? 'currency_usd';
  }

  static String getName(String currencyCode, AppLocalizations l10n) {
    final key = getNameKey(currencyCode);
    switch (key) {
      case 'currency_usd':
        return l10n.currency_usd;
      case 'currency_eur':
        return l10n.currency_eur;
      case 'currency_gbp':
        return l10n.currency_gbp;
      case 'currency_jpy':
        return l10n.currency_jpy;
      case 'currency_cny':
        return l10n.currency_cny;
      case 'currency_hkd':
        return l10n.currency_hkd;
      case 'currency_sgd':
        return l10n.currency_sgd;
      case 'currency_thb':
        return l10n.currency_thb;
      case 'currency_krw':
        return l10n.currency_krw;
      case 'currency_aud':
        return l10n.currency_aud;
      case 'currency_cad':
        return l10n.currency_cad;
      default:
        return l10n.currency_usd;
    }
  }
}
