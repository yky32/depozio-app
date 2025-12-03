import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:depozio/features/deposit/data/models/category_icon_helper.dart';
import 'package:depozio/core/enum/category_type.dart';

part 'category_entity.g.dart';

@HiveType(typeId: 0)
class CategoryEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int iconIndex; // Changed from iconCodePoint to iconIndex

  @HiveField(3)
  final String type; // 'deposits' or 'expenses' (stored as String for Hive compatibility)

  @HiveField(4)
  final DateTime createdAt;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.iconIndex,
    required this.type,
    required this.createdAt,
  });

  // Getter for IconData (uses constant IconData for tree-shaking compatibility)
  IconData get icon => CategoryIconHelper.getIconByIndex(iconIndex);

  // Getter for CategoryType enum
  CategoryType get categoryType => CategoryType.fromString(type);

  // Create a copy with updated fields
  CategoryEntity copyWith({
    String? id,
    String? name,
    int? iconIndex,
    String? type,
    DateTime? createdAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconIndex: iconIndex ?? this.iconIndex,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
