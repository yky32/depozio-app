import 'package:flutter/material.dart';
import 'package:depozio/core/services/exchange_rate_service.dart';
import 'package:depozio/core/models/exchange_rate_response.dart';
import 'package:depozio/core/network/logger.dart';

/// Test page for ExConvert API
/// This page can be accessed to test the API and see responses
class ExchangeRateTestPage extends StatefulWidget {
  const ExchangeRateTestPage({super.key});

  @override
  State<ExchangeRateTestPage> createState() => _ExchangeRateTestPageState();
}

class _ExchangeRateTestPageState extends State<ExchangeRateTestPage> {
  final ExchangeRateService _service = ExchangeRateService();
  final List<String> _logs = [];
  bool _isLoading = false;
  ExchangeRateResponse? _lastResponse;
  String? _errorMessage;

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
    LoggerUtil.d(message);
  }

  Future<void> _testConversion({
    required String from,
    required String to,
    double amount = 100.0,
  }) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _lastResponse = null;
    });

    _addLog('🔄 Testing: $amount $from -> $to');

    try {
      final result = await _service.convert(
        from: from,
        to: to,
        amount: amount,
        useCache: false,
      );

      setState(() {
        _lastResponse = result;
        _isLoading = false;
      });

      _addLog('✅ SUCCESS!');
      _addLog('Rate: ${result.rate}');
      _addLog('Converted: ${result.converted} $to');
      _addLog('Full response captured below');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      _addLog('❌ ERROR: $e');
    }
  }

  Future<void> _testRateOnly() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _lastResponse = null;
    });

    _addLog('🔄 Testing rate fetch: USD -> EUR');

    try {
      final rate = await _service.getRate(
        from: 'USD',
        to: 'EUR',
        useCache: false,
      );

      setState(() {
        _isLoading = false;
      });

      _addLog('✅ Rate: $rate');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      _addLog('❌ ERROR: $e');
    }
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
      _lastResponse = null;
      _errorMessage = null;
    });
  }

  void _clearCache() {
    _service.clearCache();
    _addLog('🗑️ Cache cleared');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ExConvert API Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearLogs,
            tooltip: 'Clear logs',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Test buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Test Conversions', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () => _testConversion(
                                    from: 'USD',
                                    to: 'EUR',
                                    amount: 100.0,
                                  ),
                          child: const Text('USD → EUR'),
                        ),
                        ElevatedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () => _testConversion(
                                    from: 'USD',
                                    to: 'HKD',
                                    amount: 50.0,
                                  ),
                          child: const Text('USD → HKD'),
                        ),
                        ElevatedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () => _testConversion(
                                    from: 'EUR',
                                    to: 'GBP',
                                    amount: 200.0,
                                  ),
                          child: const Text('EUR → GBP'),
                        ),
                        ElevatedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () => _testConversion(
                                    from: 'USD',
                                    to: 'USD',
                                    amount: 100.0,
                                  ),
                          child: const Text('USD → USD'),
                        ),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _testRateOnly,
                          child: const Text('Get Rate Only'),
                        ),
                        OutlinedButton(
                          onPressed: _clearCache,
                          child: const Text('Clear Cache'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Loading indicator
            if (_isLoading)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),

            // Error message
            if (_errorMessage != null)
              Card(
                color: colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Last response
            if (_lastResponse != null) ...[
              Card(
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Response',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildResponseRow('From', _lastResponse!.from),
                      _buildResponseRow('To', _lastResponse!.to),
                      _buildResponseRow(
                        'Amount',
                        _lastResponse!.amount.toStringAsFixed(2),
                      ),
                      _buildResponseRow(
                        'Converted',
                        _lastResponse!.converted.toStringAsFixed(2),
                      ),
                      _buildResponseRow(
                        'Rate',
                        _lastResponse!.rate.toStringAsFixed(6),
                      ),
                      _buildResponseRow(
                        'Timestamp',
                        _lastResponse!.timestamp?.toString() ?? 'N/A',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Full Response (JSON):',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          _lastResponse!.toMap().toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Logs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Logs (${_logs.length})',
                          style: theme.textTheme.titleMedium,
                        ),
                        if (_logs.isNotEmpty)
                          TextButton(
                            onPressed: _clearLogs,
                            child: const Text('Clear'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_logs.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No logs yet. Run a test to see results.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      )
                    else
                      Container(
                        constraints: const BoxConstraints(maxHeight: 400),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _logs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: SelectableText(
                                _logs[index],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseRow(String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
