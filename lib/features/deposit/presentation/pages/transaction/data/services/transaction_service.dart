import 'package:hive_ce_flutter/hive_flutter.dart' as hive;
import '../models/transaction_entity.dart';

class TransactionService {
  static const String _boxName = 'transactions';
  static hive.Box<TransactionEntity>? _box;
  static bool _initialized = false;

  /// Initialize the Hive box for transactions (singleton pattern)
  static Future<void> init() async {
    if (_initialized && _box != null) {
      return;
    }
    if (!hive.Hive.isAdapterRegistered(1)) {
      hive.Hive.registerAdapter(TransactionEntityAdapter());
    }
    _box = await hive.Hive.openBox<TransactionEntity>(_boxName);
    _initialized = true;
  }

  /// Get the box instance
  hive.Box<TransactionEntity>? get box => _box;

  /// Get all transactions
  List<TransactionEntity> getAllTransactions() {
    if (_box == null) {
      return [];
    }
    return _box!.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get transactions by category ID
  List<TransactionEntity> getTransactionsByCategoryId(String categoryId) {
    if (_box == null) {
      return [];
    }
    return _box!.values
        .where((transaction) => transaction.categoryId == categoryId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get transaction count by category ID
  int getTransactionCountByCategoryId(String categoryId) {
    if (_box == null) {
      return 0;
    }
    return _box!.values
        .where((transaction) => transaction.categoryId == categoryId)
        .length;
  }

  /// Add a new transaction
  Future<void> addTransaction(TransactionEntity transaction) async {
    if (_box == null) {
      await init();
    }
    await _box!.put(transaction.id, transaction);
  }

  /// Delete a transaction by ID
  Future<void> deleteTransaction(String transactionId) async {
    if (_box == null) {
      return;
    }
    await _box!.delete(transactionId);
  }

  /// Clear all transactions
  Future<void> clearAllTransactions() async {
    if (_box == null) {
      return;
    }
    await _box!.clear();
  }

  /// Get a transaction by ID
  TransactionEntity? getTransactionById(String transactionId) {
    if (_box == null) {
      return null;
    }
    return _box!.get(transactionId);
  }

  /// Watch transactions (for reactive updates)
  Stream<hive.BoxEvent> watchTransactions() {
    if (_box == null) {
      return const Stream.empty();
    }
    return _box!.watch();
  }

  /// Get a stream of all transactions (reactive)
  Stream<List<TransactionEntity>> watchAllTransactions() {
    if (_box == null) {
      return Stream.value([]);
    }
    return _box!.watch().map((event) => getAllTransactions());
  }

  /// Get a stream of transactions by category (reactive)
  Stream<List<TransactionEntity>> watchTransactionsByCategoryId(String categoryId) {
    if (_box == null) {
      return Stream.value([]);
    }
    return _box!.watch().map((event) => getTransactionsByCategoryId(categoryId));
  }
}

