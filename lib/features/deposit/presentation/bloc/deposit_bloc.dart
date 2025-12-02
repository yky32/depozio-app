import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';
import 'package:depozio/core/network/logger.dart';

part 'deposit_event.dart';
part 'deposit_state.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  final CategoryService _categoryService;

  DepositBloc({CategoryService? categoryService})
    : _categoryService = categoryService ?? CategoryService(),
      super(const DepositInitial()) {
    LoggerUtil.i('DepositBloc initialized');
    on<LoadDeposits>(_handleLoadDeposits);
    on<RefreshDeposits>(_handleRefreshDeposits);
    on<AddCategory>(_handleAddCategory);
    on<DeleteCategory>(_handleDeleteCategory);
    on<UpdateCategory>(_handleUpdateCategory);
    on<RestoreCategory>(_handleRestoreCategory);
  }

  Future<void> _handleLoadDeposits(
    LoadDeposits event,
    Emitter<DepositState> emit,
  ) async {
    LoggerUtil.d('📥 LoadDeposits event received');
    emit(const DepositLoading());
    LoggerUtil.d('📤 State emitted: DepositLoading');

    try {
      LoggerUtil.d('🔧 Initializing Hive...');
      await CategoryService.init();

      LoggerUtil.d('📖 Reading categories from Hive...');
      final allCategories = _categoryService.getAllCategories();
      LoggerUtil.i('📦 Loaded ${allCategories.length} categories from Hive');

      // Emit the loaded state with all categories
      emit(DepositLoaded(
        categories: [...allCategories],
        refreshTimestamp: DateTime.now(),
      ));
      LoggerUtil.d(
        '📤 State emitted: DepositLoaded with ${allCategories.length} categories',
      );
    } catch (e, stackTrace) {
      LoggerUtil.e(
        '❌ Error loading deposits',
        error: e,
        stackTrace: stackTrace,
      );
      emit(DepositError(error: e.toString()));
      LoggerUtil.d('📤 State emitted: DepositError');
    }
  }

  Future<void> _handleRefreshDeposits(
    RefreshDeposits event,
    Emitter<DepositState> emit,
  ) async {
    LoggerUtil.d(
      '🔄 RefreshDeposits event received, current state: ${state.runtimeType}',
    );

    if (state is DepositLoaded) {
      final currentCategories = (state as DepositLoaded).categories;
      // Emit refreshing state to show skeleton
      emit(DepositRefreshing(categories: currentCategories));
      
      try {
        // Small delay to show skeleton effect
        await Future.delayed(const Duration(milliseconds: 300));
        
        LoggerUtil.d('📖 Refreshing categories from Hive...');
        final categories = _categoryService.getAllCategories();
        LoggerUtil.i('🔄 Refreshed ${categories.length} categories');
        emit(DepositLoaded(
          categories: [...categories],
          refreshTimestamp: DateTime.now(),
        ));
        LoggerUtil.d('📤 State emitted: DepositLoaded (refreshed)');
      } catch (e, stackTrace) {
        LoggerUtil.e(
          '❌ Error refreshing deposits',
          error: e,
          stackTrace: stackTrace,
        );
        emit(DepositError(error: e.toString()));
      }
    } else if (state is DepositRefreshing) {
      // Already refreshing, just update the data
      try {
        LoggerUtil.d('📖 Refreshing categories from Hive...');
        final categories = _categoryService.getAllCategories();
        LoggerUtil.i('🔄 Refreshed ${categories.length} categories');
        emit(DepositLoaded(
          categories: [...categories],
          refreshTimestamp: DateTime.now(),
        ));
        LoggerUtil.d('📤 State emitted: DepositLoaded (refreshed)');
      } catch (e, stackTrace) {
        LoggerUtil.e(
          '❌ Error refreshing deposits',
          error: e,
          stackTrace: stackTrace,
        );
        emit(DepositError(error: e.toString()));
      }
    } else {
      // If not loaded, trigger load
      LoggerUtil.d('⚠️ Not loaded yet, triggering LoadDeposits');
      add(LoadDeposits());
    }
  }

  Future<void> _handleAddCategory(
    AddCategory event,
    Emitter<DepositState> emit,
  ) async {
    LoggerUtil.d(
      '➕ AddCategory event received: ${event.category.name} (id: ${event.category.id}, type: ${event.category.type})',
    );

    try {
      // Ensure Hive is initialized
      await CategoryService.init();

      // Add category to Hive
      LoggerUtil.d('💾 Saving category to Hive...');
      await _categoryService.addCategory(event.category);
      LoggerUtil.i('✅ Category added to Hive: ${event.category.name}');

      // Refresh the list after adding
      final categories = _categoryService.getAllCategories();
      LoggerUtil.d('📊 Total categories after add: ${categories.length}');
      emit(DepositLoaded(
        categories: [...categories],
        refreshTimestamp: DateTime.now(),
      ));
      LoggerUtil.d(
        '📤 State emitted: DepositLoaded with ${categories.length} categories',
      );
    } catch (e, stackTrace) {
      LoggerUtil.e('❌ Error adding category', error: e, stackTrace: stackTrace);
      emit(DepositError(error: e.toString()));
      LoggerUtil.d('📤 State emitted: DepositError');
    }
  }

  Future<void> _handleDeleteCategory(
    DeleteCategory event,
    Emitter<DepositState> emit,
  ) async {
    LoggerUtil.d(
      '🗑️ DeleteCategory event received: categoryId=${event.categoryId}',
    );

    try {
      // Delete category from Hive
      LoggerUtil.d('💾 Deleting category from Hive...');
      await _categoryService.deleteCategory(event.categoryId);
      LoggerUtil.i('✅ Category deleted from Hive: ${event.categoryId}');

      // Small delay to ensure Hive write is complete
      await Future.delayed(const Duration(milliseconds: 50));

      // Refresh the list after deleting
      final categories = _categoryService.getAllCategories();
      LoggerUtil.d('📊 Total categories after delete: ${categories.length}');

      // Emit new state with updated list
      emit(DepositLoaded(
        categories: List.from(categories),
        refreshTimestamp: DateTime.now(),
      ));
      LoggerUtil.d(
        '📤 State emitted: DepositLoaded with ${categories.length} categories',
      );
    } catch (e, stackTrace) {
      LoggerUtil.e(
        '❌ Error deleting category',
        error: e,
        stackTrace: stackTrace,
      );
      emit(DepositError(error: e.toString()));
      LoggerUtil.d('📤 State emitted: DepositError');
    }
  }

  Future<void> _handleUpdateCategory(
    UpdateCategory event,
    Emitter<DepositState> emit,
  ) async {
    LoggerUtil.d(
      '✏️ UpdateCategory event received: ${event.category.name} (id: ${event.category.id})',
    );

    try {
      // Update category in Hive
      LoggerUtil.d('💾 Updating category in Hive...');
      await _categoryService.addCategory(event.category);
      LoggerUtil.i('✅ Category updated in Hive: ${event.category.name}');

      // Refresh the list after updating
      final categories = _categoryService.getAllCategories();
      LoggerUtil.d('📊 Total categories after update: ${categories.length}');
      emit(DepositLoaded(
        categories: [...categories],
        refreshTimestamp: DateTime.now(),
      ));
      LoggerUtil.d('📤 State emitted: DepositLoaded');
    } catch (e, stackTrace) {
      LoggerUtil.e(
        '❌ Error updating category',
        error: e,
        stackTrace: stackTrace,
      );
      emit(DepositError(error: e.toString()));
    }
  }

  Future<void> _handleRestoreCategory(
    RestoreCategory event,
    Emitter<DepositState> emit,
  ) async {
    LoggerUtil.d(
      '↩️ RestoreCategory event received: ${event.category.name} (id: ${event.category.id})',
    );

    try {
      // Restore category to Hive
      LoggerUtil.d('💾 Restoring category to Hive...');
      await _categoryService.addCategory(event.category);
      LoggerUtil.i('✅ Category restored to Hive: ${event.category.name}');

      // Refresh the list after restoring
      final categories = _categoryService.getAllCategories();
      LoggerUtil.d('📊 Total categories after restore: ${categories.length}');
      emit(DepositLoaded(
        categories: [...categories],
        refreshTimestamp: DateTime.now(),
      ));
      LoggerUtil.d('📤 State emitted: DepositLoaded');
    } catch (e, stackTrace) {
      LoggerUtil.e(
        '❌ Error restoring category',
        error: e,
        stackTrace: stackTrace,
      );
      emit(DepositError(error: e.toString()));
    }
  }
}
