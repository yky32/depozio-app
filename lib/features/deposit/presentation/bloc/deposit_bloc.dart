import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:depozio/features/deposit/data/models/category_entity.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';

part 'deposit_event.dart';
part 'deposit_state.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  final CategoryService _categoryService;

  DepositBloc({CategoryService? categoryService})
    : _categoryService = categoryService ?? CategoryService(),
      super(const DepositInitial()) {
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
    emit(const DepositLoading());

    try {
      // Ensure Hive is initialized
      await CategoryService.init();

      // Read all categories from Hive
      final allCategories = _categoryService.getAllCategories();

      // Emit the loaded state with all categories
      emit(DepositLoaded(categories: [...allCategories]));
    } catch (e) {
      emit(DepositError(error: e.toString()));
    }
  }

  Future<void> _handleRefreshDeposits(
    RefreshDeposits event,
    Emitter<DepositState> emit,
  ) async {
    // If already loaded, keep the loaded state but refresh data
    if (state is DepositLoaded) {
      try {
        final categories = _categoryService.getAllCategories();
        emit(DepositLoaded(categories: [...categories]));
      } catch (e) {
        emit(DepositError(error: e.toString()));
      }
    } else {
      // If not loaded, trigger load
      add(LoadDeposits());
    }
  }

  Future<void> _handleAddCategory(
    AddCategory event,
    Emitter<DepositState> emit,
  ) async {
    try {
      // Ensure Hive is initialized
      await CategoryService.init();

      // Add category to Hive
      await _categoryService.addCategory(event.category);

      // Refresh the list after adding
      final categories = _categoryService.getAllCategories();
      emit(DepositLoaded(categories: [...categories]));
    } catch (e) {
      emit(DepositError(error: e.toString()));
    }
  }

  Future<void> _handleDeleteCategory(
    DeleteCategory event,
    Emitter<DepositState> emit,
  ) async {
    try {
      // Delete category from Hive
      await _categoryService.deleteCategory(event.categoryId);

      // Small delay to ensure Hive write is complete
      await Future.delayed(const Duration(milliseconds: 50));

      // Refresh the list after deleting
      final categories = _categoryService.getAllCategories();

      // Emit new state with updated list
      emit(DepositLoaded(categories: List.from(categories)));
    } catch (e) {
      emit(DepositError(error: e.toString()));
    }
  }

  Future<void> _handleUpdateCategory(
    UpdateCategory event,
    Emitter<DepositState> emit,
  ) async {
    try {
      // Update category in Hive
      await _categoryService.addCategory(event.category);

      // Refresh the list after updating
      final categories = _categoryService.getAllCategories();

      emit(DepositLoaded(categories: [...categories]));
    } catch (e) {
      emit(DepositError(error: e.toString()));
    }
  }

  Future<void> _handleRestoreCategory(
    RestoreCategory event,
    Emitter<DepositState> emit,
  ) async {
    try {
      // Restore category to Hive
      await _categoryService.addCategory(event.category);

      // Refresh the list after restoring
      final categories = _categoryService.getAllCategories();

      emit(DepositLoaded(categories: [...categories]));
    } catch (e) {
      emit(DepositError(error: e.toString()));
    }
  }
}
