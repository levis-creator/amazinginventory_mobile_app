import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/category_repository.dart';
import '../models/category_model.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/services/api_service.dart';
import 'category_state.dart';

/// Cubit for managing category state.
/// 
/// Handles loading, creating, updating, and deleting categories.
class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryCubit({CategoryRepository? categoryRepository})
      : _categoryRepository = categoryRepository ??
            CategoryRepository(
              getIt<ApiService>(),
            ),
        super(const CategoryInitial());

  /// Load categories from the API.
  /// 
  /// [search] Optional search query
  /// [isActive] Optional active status filter
  /// [perPage] Number of items per page
  /// [sortBy] Field to sort by
  /// [sortOrder] Sort order
  Future<void> loadCategories({
    String? search,
    bool? isActive,
    int perPage = 100,
    String sortBy = 'name',
    String sortOrder = 'asc',
  }) async {
    if (isClosed) return;

    emit(const CategoryLoading());

    try {
      final result = await _categoryRepository.getCategories(
        search: search,
        isActive: isActive,
        perPage: perPage,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      if (isClosed) return;

      emit(CategoryLoaded(
        categories: result['categories'] as List<CategoryModel>,
        paginationMeta: result['meta'] as Map<String, dynamic>?,
        paginationLinks: result['links'] as Map<String, dynamic>?,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(CategoryError(e.toString()));
    }
  }

  /// Create a new category.
  /// Returns the created category.
  Future<CategoryModel> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final category = await _categoryRepository.createCategory(categoryData);
      
      // If we have loaded categories, add the new one to the list
      final currentState = state;
      if (currentState is CategoryLoaded) {
        final updatedCategories = List<CategoryModel>.from(currentState.categories)
          ..add(category);
        emit(currentState.copyWith(categories: updatedCategories));
      } else {
        // Reload categories after creation
        await loadCategories();
      }
      
      return category;
    } catch (e) {
      if (isClosed) {
        rethrow;
      }
      emit(CategoryError(e.toString()));
      rethrow;
    }
  }

  /// Update an existing category.
  Future<void> updateCategory(int id, Map<String, dynamic> categoryData) async {
    try {
      final updatedCategory = await _categoryRepository.updateCategory(id, categoryData);
      
      // Update the category in the list if we have loaded categories
      final currentState = state;
      if (currentState is CategoryLoaded) {
        final updatedCategories = currentState.categories.map((cat) {
          return cat.id == id ? updatedCategory : cat;
        }).toList();
        emit(currentState.copyWith(categories: updatedCategories));
      } else {
        // Reload categories after update
        await loadCategories();
      }
    } catch (e) {
      if (isClosed) return;
      emit(CategoryError(e.toString()));
    }
  }

  /// Delete a category.
  Future<void> deleteCategory(int id) async {
    try {
      await _categoryRepository.deleteCategory(id);
      
      // Remove the category from the list if we have loaded categories
      final currentState = state;
      if (currentState is CategoryLoaded) {
        final updatedCategories = currentState.categories.where((cat) => cat.id != id).toList();
        emit(currentState.copyWith(categories: updatedCategories));
      } else {
        // Reload categories after deletion
        await loadCategories();
      }
    } catch (e) {
      if (isClosed) return;
      emit(CategoryError(e.toString()));
    }
  }

  /// Refresh categories (reload with current filters).
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is CategoryLoaded) {
      // Reload with same parameters (we'll need to store them)
      await loadCategories();
    } else {
      await loadCategories();
    }
  }
}

