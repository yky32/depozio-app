import 'package:hive_ce_flutter/hive_flutter.dart' as hive;
import '../models/category_model.dart';

class CategoryService {
  static const String _boxName = 'categories';
  static hive.Box<CategoryModel>? _box;
  static bool _initialized = false;

  /// Initialize the Hive box for categories (singleton pattern)
  static Future<void> init() async {
    if (_initialized && _box != null) {
      return;
    }
    if (!hive.Hive.isAdapterRegistered(0)) {
      hive.Hive.registerAdapter(CategoryModelAdapter());
    }
    _box = await hive.Hive.openBox<CategoryModel>(_boxName);
    _initialized = true;
  }

  /// Get the box instance
  hive.Box<CategoryModel>? get box => _box;

  /// Get all categories
  List<CategoryModel> getAllCategories() {
    if (_box == null) {
      return [];
    }
    return _box!.values.toList();
  }

  /// Get categories by type
  List<CategoryModel> getCategoriesByType(String type) {
    if (_box == null) {
      return [];
    }
    return _box!.values.where((category) => category.type == type).toList();
  }

  /// Add a new category
  Future<void> addCategory(CategoryModel category) async {
    if (_box == null) {
      await init();
    }
    await _box!.put(category.id, category);
  }

  /// Delete a category by ID
  Future<void> deleteCategory(String categoryId) async {
    if (_box == null) {
      return;
    }
    await _box!.delete(categoryId);
  }

  /// Clear all categories
  Future<void> clearAllCategories() async {
    if (_box == null) {
      return;
    }
    await _box!.clear();
  }

  /// Get a category by ID
  CategoryModel? getCategoryById(String categoryId) {
    if (_box == null) {
      return null;
    }
    return _box!.get(categoryId);
  }

  /// Watch categories (for reactive updates)
  Stream<hive.BoxEvent> watchCategories() {
    if (_box == null) {
      return const Stream.empty();
    }
    return _box!.watch();
  }

  /// Get a stream of all categories (reactive)
  Stream<List<CategoryModel>> watchAllCategories() {
    if (_box == null) {
      return Stream.value([]);
    }
    return _box!.watch().map((event) => getAllCategories());
  }
}
