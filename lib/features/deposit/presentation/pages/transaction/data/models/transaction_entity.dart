import 'package:hive_ce/hive.dart';

part 'transaction_entity.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String currencyCode;

  @HiveField(3)
  final String categoryId;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String? notes;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.currencyCode,
    required this.categoryId,
    required this.createdAt,
    this.notes,
  });

  // Create a copy with updated fields
  TransactionModel copyWith({
    String? id,
    double? amount,
    String? currencyCode,
    String? categoryId,
    DateTime? createdAt,
    String? notes,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}

