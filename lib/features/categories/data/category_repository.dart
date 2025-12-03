import '../../../core/services/api_interface.dart';
import '../../../core/services/api_service.dart';
import '../models/category_model.dart';

/// Repository for category data operations.
/// 
/// Handles fetching, creating, updating, and deleting categories from the API.
class CategoryRepository {
  final ApiInterface apiService;

  CategoryRepository(this.apiService);

  /// Fetches a paginated list of categories from the API.
  /// 
  /// Supports optional search and active status filters.
  /// Returns a map containing 'categories' (List<CategoryModel>),
  /// 'meta' (pagination metadata), and 'links' (pagination links).
  /// Throws [ApiException] if the request fails.
  Future<Map<String, dynamic>> getCategories({
    String? search,
    bool? isActive,
    int perPage = 50, // Reduced from 100 to avoid timeouts
    String sortBy = 'name',
    String sortOrder = 'asc',
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'per_page': perPage.toString(),
        'sort_by': sortBy,
        'sort_order': sortOrder,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (isActive != null) {
        queryParams['is_active'] = isActive.toString();
      }

      // Use longer timeout for categories (60 seconds) as it may take longer
      final response = await apiService.get(
        '/categories',
        queryParams: queryParams,
        timeout: const Duration(seconds: 60),
      );

      final List<CategoryModel> categories = (response['data'] as List)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return {
        'categories': categories,
        'meta': response['meta'] as Map<String, dynamic>?,
        'links': response['links'] as Map<String, dynamic>?,
      };
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Failed to load categories: ${e.toString()}', statusCode: 500);
    }
  }

  /// Fetches a single category by ID from the API.
  /// 
  /// [id] The ID of the category to fetch.
  /// Returns [CategoryModel] for the category.
  /// Throws [ApiException] if the request fails.
  Future<CategoryModel> getCategoryById(int id) async {
    try {
      final response = await apiService.get('/categories/$id');
      
      // The API returns { success: true, category: {...} }
      final categoryData = response['category'] as Map<String, dynamic>;
      return CategoryModel.fromJson(categoryData);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Failed to load category: ${e.toString()}', statusCode: 500);
    }
  }

  /// Creates a new category via the API.
  /// 
  /// [categoryData] Map containing category details (name, description, is_active).
  /// Returns the created [CategoryModel].
  /// Throws [ApiException] if the request fails.
  Future<CategoryModel> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final response = await apiService.post('/categories', categoryData);
      
      // The API returns { success: true, message: "...", category: {...} }
      final categoryDataResponse = response['category'] as Map<String, dynamic>;
      return CategoryModel.fromJson(categoryDataResponse);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Failed to create category: ${e.toString()}', statusCode: 500);
    }
  }

  /// Updates an existing category via the API.
  /// 
  /// [id] The ID of the category to update.
  /// [categoryData] Map containing updated category details.
  /// Returns the updated [CategoryModel].
  /// Throws [ApiException] if the request fails.
  Future<CategoryModel> updateCategory(int id, Map<String, dynamic> categoryData) async {
    try {
      final response = await apiService.put('/categories/$id', categoryData);
      
      final categoryDataResponse = response['category'] as Map<String, dynamic>;
      return CategoryModel.fromJson(categoryDataResponse);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Failed to update category: ${e.toString()}', statusCode: 500);
    }
  }

  /// Deletes a category via the API.
  /// 
  /// [id] The ID of the category to delete.
  /// Throws [ApiException] if the request fails.
  Future<void> deleteCategory(int id) async {
    try {
      await apiService.delete('/categories/$id');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Failed to delete category: ${e.toString()}', statusCode: 500);
    }
  }
}

