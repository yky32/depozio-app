/// Model for ExConvert API response
class ExchangeRateResponse {
  final String from;
  final String to;
  final double amount;
  final double converted;
  final double rate;
  final DateTime? timestamp;

  ExchangeRateResponse({
    required this.from,
    required this.to,
    required this.amount,
    required this.converted,
    required this.rate,
    this.timestamp,
  });

  /// Create from ExConvert API JSON response
  factory ExchangeRateResponse.fromMap(Map<String, dynamic> map) {
    return ExchangeRateResponse(
      from: map['from'] as String? ?? '',
      to: map['to'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      converted: (map['converted'] as num?)?.toDouble() ?? 0.0,
      rate: (map['rate'] as num?)?.toDouble() ?? 0.0,
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'amount': amount,
      'converted': converted,
      'rate': rate,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}

