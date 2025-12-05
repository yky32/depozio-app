import 'package:depozio/core/services/exchange_rate_service.dart';
import 'package:depozio/core/network/logger.dart';

/// Test script for ExConvert API
/// Run this to test the API and see the response
Future<void> testExchangeRateAPI() async {
  LoggerUtil.d('🧪 Starting ExConvert API test...');

  final service = ExchangeRateService();

  // Test cases
  final testCases = [
    {'from': 'USD', 'to': 'EUR', 'amount': 100.0},
    {'from': 'USD', 'to': 'HKD', 'amount': 50.0},
    {'from': 'EUR', 'to': 'GBP', 'amount': 200.0},
    {'from': 'USD', 'to': 'USD', 'amount': 100.0}, // Same currency test
  ];

  LoggerUtil.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  LoggerUtil.d('Testing ${testCases.length} conversion(s)...');
  LoggerUtil.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  for (int i = 0; i < testCases.length; i++) {
    final testCase = testCases[i];
    final from = testCase['from'] as String;
    final to = testCase['to'] as String;
    final amount = testCase['amount'] as double;

    LoggerUtil.d('');
    LoggerUtil.d('Test ${i + 1}: Converting $amount $from to $to');
    LoggerUtil.d('──────────────────────────────────────────');

    try {
      final result = await service.convert(
        from: from,
        to: to,
        amount: amount,
        useCache: false, // Don't use cache for testing
      );

      LoggerUtil.d('✅ SUCCESS!');
      LoggerUtil.d('Response details:');
      LoggerUtil.d('  From: ${result.from}');
      LoggerUtil.d('  To: ${result.to}');
      LoggerUtil.d('  Amount: ${result.amount}');
      LoggerUtil.d('  Converted: ${result.converted}');
      LoggerUtil.d('  Rate: ${result.rate}');
      LoggerUtil.d('  Timestamp: ${result.timestamp}');
      LoggerUtil.d('');
      LoggerUtil.d('📊 Full Response Map:');
      LoggerUtil.d(result.toMap().toString());
    } catch (e) {
      LoggerUtil.e('❌ FAILED!', error: e);
      LoggerUtil.d('Error details: $e');
    }

    // Small delay between tests
    await Future.delayed(const Duration(milliseconds: 500));
  }

  LoggerUtil.d('');
  LoggerUtil.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  LoggerUtil.d('Testing rate-only fetch...');
  LoggerUtil.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  try {
    final rate = await service.getRate(from: 'USD', to: 'EUR', useCache: false);
    LoggerUtil.d('✅ Rate fetch SUCCESS!');
    LoggerUtil.d('USD to EUR rate: $rate');
  } catch (e) {
    LoggerUtil.e('❌ Rate fetch FAILED!', error: e);
  }

  LoggerUtil.d('');
  LoggerUtil.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  LoggerUtil.d('Testing cache...');
  LoggerUtil.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  try {
    // First call (will fetch from API)
    LoggerUtil.d('First call (should fetch from API):');
    final result1 = await service.convert(
      from: 'USD',
      to: 'EUR',
      amount: 10.0,
      useCache: true,
    );
    LoggerUtil.d('  Rate: ${result1.rate}');

    // Second call (should use cache)
    LoggerUtil.d('Second call (should use cache):');
    final result2 = await service.convert(
      from: 'USD',
      to: 'EUR',
      amount: 10.0,
      useCache: true,
    );
    LoggerUtil.d('  Rate: ${result2.rate}');

    LoggerUtil.d('✅ Cache test completed');
  } catch (e) {
    LoggerUtil.e('❌ Cache test FAILED!', error: e);
  }

  LoggerUtil.d('');
  LoggerUtil.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  LoggerUtil.d('Cache Statistics:');
  LoggerUtil.d('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  final cacheStats = service.getCacheStats();
  LoggerUtil.d('Cached pairs: ${cacheStats['cachedPairs']}');
  LoggerUtil.d('Pairs: ${cacheStats['pairs']}');

  LoggerUtil.d('');
  LoggerUtil.d('✅ All tests completed!');
}
