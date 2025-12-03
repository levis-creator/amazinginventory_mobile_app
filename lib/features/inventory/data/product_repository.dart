import '../../../core/services/api_interface.dart';
import '../../../core/services/api_service.dart';
import '../models/product_api_model.dart';

/// Repository for product data operations.
/// 
/// Handles fetching products from the API.
/// Follows the same pattern as [DashboardRepository].
class ProductRepository {
  final ApiInterface apiService;

  ProductRepository(this.apiService);

  /// Fetches a list of products from the API.
  /// 
  /// [search] Optional search query to filter by name or SKU
  /// [categoryId] Optional category ID to filter by category
  /// [isActive] Optional filter by active status
  /// [perPage] Number of items per page (default: 15)
  /// [sortBy] Field to sort by (default: 'name')
  /// [sortOrder] Sort order: 'asc' or 'desc' (default: 'asc')
  /// 
  /// Returns a list of [ProductApiModel] and pagination info.
  /// Throws [ApiException] if the request fails.
  Future<Map<String, dynamic>> getProducts({
    String? search,
    int? categoryId,
    bool? isActive,
    int perPage = 15,
    String sortBy = 'name',
    String sortOrder = 'asc',
  }) async {
    try {
      final endpoint = '/products';
      final queryParams = <String, dynamic>{
        'per_page': perPage,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (categoryId != null) {
        queryParams['category_id'] = categoryId;
      }
      if (isActive != null) {
        queryParams['is_active'] = isActive;
      }

      final response = await apiService.get(endpoint, queryParams: queryParams);
      
      // Parse paginated response
      final data = response['data'] as List;
      final products = data.map((json) => ProductApiModel.fromJson(json as Map<String, dynamic>)).toList();
      
      return {
        'products': products,
        'links': response['links'],
        'meta': response['meta'],
      };
    } catch (e) {
      print('❌ Product Repository Error: $e');
      rethrow;
    }
  }

  /// Fetches a single product by ID from the API.
  /// 
  /// [id] The product ID
  /// Returns [ProductApiModel] for the product.
  /// Throws [ApiException] if the request fails.
  Future<ProductApiModel> getProductById(int id) async {
    try {
      final endpoint = '/products/$id';
      final response = await apiService.get(endpoint);
      
      // The API returns { success: true, product: {...} }
      final productData = response['product'] as Map<String, dynamic>;
      return ProductApiModel.fromJson(productData);
    } catch (e) {
      print('❌ Product Repository Error (getProductById): $e');
      rethrow;
    }
  }

  /// Creates a new product.
  /// 
  /// [productData] Map containing product fields
  /// Returns the created [ProductApiModel].
  /// Throws [ApiException] if the request fails.
  Future<ProductApiModel> createProduct(Map<String, dynamic> productData) async {
    try {
      final endpoint = '/products';
      final response = await apiService.post(endpoint, productData);
      
      final productDataResponse = response['product'] as Map<String, dynamic>;
      return ProductApiModel.fromJson(productDataResponse);
    } catch (e) {
      print('❌ Product Repository Error (createProduct): $e');
      rethrow;
    }
  }

  /// Updates an existing product.
  /// 
  /// [id] The product ID
  /// [productData] Map containing updated product fields
  /// Returns the updated [ProductApiModel].
  /// Throws [ApiException] if the request fails.
  Future<ProductApiModel> updateProduct(int id, Map<String, dynamic> productData) async {
    try {
      final endpoint = '/products/$id';
      final response = await apiService.put(endpoint, productData);
      
      final productDataResponse = response['product'] as Map<String, dynamic>;
      return ProductApiModel.fromJson(productDataResponse);
    } catch (e) {
      print('❌ Product Repository Error (updateProduct): $e');
      rethrow;
    }
  }

  /// Deletes a product.
  /// 
  /// [id] The product ID
  /// Throws [ApiException] if the request fails.
  Future<void> deleteProduct(int id) async {
    try {
      final endpoint = '/products/$id';
      await apiService.delete(endpoint);
    } catch (e) {
      print('❌ Product Repository Error (deleteProduct): $e');
      rethrow;
    }
  }
}

