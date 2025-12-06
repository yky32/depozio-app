import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:depozio/core/models/exchange_rate_response.dart';
import 'package:depozio/core/network/logger.dart';

/// Service for fetching currency exchange rates from ExConvert API
/// API Documentation: https://exconvert.com/documentation
/// Free tier: Unlimited requests per month (with API key)
///
/// Note: API key is optional but recommended for better rate limits
/// Sign up at: https://exconvert.com/signup
class ExchangeRateService {
  static const String _baseUrl = 'https://api.exconvert.com';

  late final Dio _dio;
  static ExchangeRateService? _instance;
  String? _apiKey;

  // Cache for exchange rates (currency pair -> rate)
  final Map<String, _CachedRate> _rateCache = {};
  static const Duration _cacheExpiry = Duration(hours: 1); // Cache for 1 hour

  ExchangeRateService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Load API key from environment variables
    _loadApiKeyFromEnv();
  }

  /// Load API key from environment variables
  void _loadApiKeyFromEnv() {
    try {
      final apiKey = dotenv.env['EXCONVERT_API_KEY'];
      if (apiKey != null && apiKey.isNotEmpty) {
        _apiKey = apiKey;
        LoggerUtil.d('🔑 ExConvert API key loaded from environment');
      } else {
        LoggerUtil.d('⚠️  EXCONVERT_API_KEY not found in environment');
      }
    } catch (e) {
      LoggerUtil.w('⚠️  Could not load EXCONVERT_API_KEY from environment: $e');
    }
  }

  /// Set API key manually (optional, overrides environment variable)
  /// Get your API key from: https://exconvert.com/signup
  void setApiKey(String? apiKey) {
    _apiKey = apiKey;
    LoggerUtil.d(
      '🔑 ExConvert API key ${apiKey != null ? "set manually" : "removed"}',
    );
  }

  /// Get singleton instance
  factory ExchangeRateService() {
    _instance ??= ExchangeRateService._internal();
    return _instance!;
  }

  /// Convert amount from one currency to another
  ///
  /// [from] - Source currency code (e.g., 'USD')
  /// [to] - Target currency code (e.g., 'EUR')
  /// [amount] - Amount to convert (default: 1.0)
  /// [useCache] - Whether to use cached rate if available (default: true)
  ///
  /// Returns [ExchangeRateResponse] with conversion result
  /// Throws [Exception] if conversion fails
  Future<ExchangeRateResponse> convert({
    required String from,
    required String to,
    double amount = 1.0,
    bool useCache = true,
  }) async {
    // Normalize currency codes to uppercase
    final fromUpper = from.toUpperCase();
    final toUpper = to.toUpperCase();

    // If same currency, return 1:1 rate
    if (fromUpper == toUpper) {
      return ExchangeRateResponse(
        from: fromUpper,
        to: toUpper,
        amount: amount,
        converted: amount,
        rate: 1.0,
        timestamp: DateTime.now(),
      );
    }

    // Check cache first
    final cacheKey = '${fromUpper}_$toUpper';
    if (useCache && _rateCache.containsKey(cacheKey)) {
      final cached = _rateCache[cacheKey]!;
      if (DateTime.now().difference(cached.timestamp) < _cacheExpiry) {
        LoggerUtil.d(
          '💰 Using cached exchange rate: $fromUpper -> $toUpper = ${cached.rate}',
        );
        return ExchangeRateResponse(
          from: fromUpper,
          to: toUpper,
          amount: amount,
          converted: amount * cached.rate,
          rate: cached.rate,
          timestamp: cached.timestamp,
        );
      } else {
        // Cache expired, remove it
        _rateCache.remove(cacheKey);
      }
    }

    try {
      LoggerUtil.d(
        '💰 Fetching exchange rate from ExConvert: $fromUpper -> $toUpper',
      );

      // Build query parameters
      final queryParams = <String, dynamic>{
        'from': fromUpper,
        'to': toUpper,
        'amount': amount.toStringAsFixed(2),
      };

      // Add API key if available
      if (_apiKey != null && _apiKey!.isNotEmpty) {
        queryParams['access_key'] = _apiKey;
      }

      final response = await _dio.get('/convert', queryParameters: queryParams);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;

        // Log the raw response for debugging
        LoggerUtil.d('📦 Raw API response: $data');

        // ExConvert API response format: {base: USD, amount: 100.00, result: {EUR: 85.8, rate: 0.858}, ms: 1}
        // The 'result' field is a Map where:
        // - The target currency is a key (e.g., "EUR") with the converted amount as value
        // - There's also a "rate" key with the exchange rate
        double? rate;
        double? converted;

        // Extract from 'result' field (nested structure)
        // ExConvert format: result: {EUR: 85.8, rate: 0.858}
        if (data.containsKey('result')) {
          final resultValue = data['result'];

          if (resultValue is Map) {
            final resultMap = resultValue;

            // Extract rate from result map
            if (resultMap.containsKey('rate')) {
              final rateValue = resultMap['rate'];
              if (rateValue is num) {
                rate = rateValue.toDouble();
              } else if (rateValue is String) {
                rate = double.tryParse(rateValue);
              }
            }

            // Extract converted amount - the target currency code is a key in the result map
            // Look for the target currency code (e.g., "EUR") as a key
            if (resultMap.containsKey(toUpper)) {
              final convertedValue = resultMap[toUpper];
              if (convertedValue is num) {
                converted = convertedValue.toDouble();
              } else if (convertedValue is String) {
                converted = double.tryParse(convertedValue);
              }
            } else {
              // Fallback: find any 3-letter currency code key (skip 'rate')
              for (final entry in resultMap.entries) {
                final key = entry.key.toString();
                final value = entry.value;

                // Skip the 'rate' key, look for currency codes (3 uppercase letters)
                if (key != 'rate' &&
                    key.length == 3 &&
                    key == key.toUpperCase()) {
                  if (value is num) {
                    converted = value.toDouble();
                  } else if (value is String) {
                    converted = double.tryParse(value);
                  }
                  break; // Found the converted amount
                }
              }
            }
          } else if (resultValue is num) {
            // Fallback: result might be a direct number
            converted = resultValue.toDouble();
          } else if (resultValue is String) {
            converted = double.tryParse(resultValue);
          }
        }

        // Fallback: Try direct 'rate' field at root level
        if (rate == null && data.containsKey('rate')) {
          final rateValue = data['rate'];
          if (rateValue is num) {
            rate = rateValue.toDouble();
          } else if (rateValue is String) {
            rate = double.tryParse(rateValue);
          }
        }

        // Fallback: Try direct 'converted' field at root level
        if (converted == null && data.containsKey('converted')) {
          final convertedValue = data['converted'];
          if (convertedValue is num) {
            converted = convertedValue.toDouble();
          } else if (convertedValue is String) {
            converted = double.tryParse(convertedValue);
          }
        }

        // If we have converted amount but no rate, calculate it
        if (converted != null && rate == null) {
          rate = converted / amount;
        }

        // If we have rate but no converted amount, calculate it
        if (rate != null && converted == null) {
          converted = amount * rate;
        }

        if (rate == null || converted == null) {
          LoggerUtil.e(
            '❌ Invalid response format from ExConvert API',
            error: 'Could not extract rate or converted value. Response: $data',
          );
          throw Exception(
            'Invalid response format from ExConvert API. Response: $data',
          );
        }

        // Cache the rate
        _rateCache[cacheKey] = _CachedRate(
          rate: rate,
          timestamp: DateTime.now(),
        );

        final result = ExchangeRateResponse(
          from: fromUpper,
          to: toUpper,
          amount: amount,
          converted: converted,
          rate: rate,
          timestamp: DateTime.now(),
        );

        LoggerUtil.d(
          '✅ Exchange rate fetched: $amount $fromUpper = $converted $toUpper (rate: $rate)',
        );

        return result;
      } else {
        throw Exception(
          'Failed to fetch exchange rate: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      LoggerUtil.e('❌ Error fetching exchange rate from ExConvert', error: e);

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception('Invalid response from exchange rate service.');
      } else {
        throw Exception('Failed to fetch exchange rate: ${e.message}');
      }
    } catch (e) {
      LoggerUtil.e('❌ Unexpected error fetching exchange rate', error: e);
      throw Exception('Failed to fetch exchange rate: $e');
    }
  }

  /// Get exchange rate between two currencies (without converting amount)
  ///
  /// Returns the rate (e.g., 1 USD = 0.85 EUR would return 0.85)
  Future<double> getRate({
    required String from,
    required String to,
    bool useCache = true,
  }) async {
    final result = await convert(
      from: from,
      to: to,
      amount: 1.0,
      useCache: useCache,
    );
    return result.rate;
  }

  /// Clear the exchange rate cache
  void clearCache() {
    _rateCache.clear();
    LoggerUtil.d('🗑️ Exchange rate cache cleared');
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'cachedPairs': _rateCache.length,
      'pairs': _rateCache.keys.toList(),
    };
  }
}

/// Internal class for caching exchange rates
class _CachedRate {
  final double rate;
  final DateTime timestamp;

  _CachedRate({required this.rate, required this.timestamp});
}
