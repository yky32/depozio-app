import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int iconCodePoint;

  @HiveField(3)
  final String type; // 'deposits' or 'expenses'

  @HiveField(4)
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.type,
    required this.createdAt,
  });

  // Getter for IconData (not stored directly, reconstructed from codePoint)
  IconData get icon => IconData(
        iconCodePoint,
        fontFamily: 'MaterialIcons',
      );

  // Create a copy with updated fields
  CategoryModel copyWith({
    String? id,
    String? name,
    int? iconCodePoint,
    String? type,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

