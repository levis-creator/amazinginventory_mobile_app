import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/product_repository.dart';
import '../models/product_api_model.dart';
import '../../../core/services/api_service.dart';
import 'product_state.dart';

/// Cubit for managing product state.
/// 
/// Handles loading, creating, updating, and deleting products.
/// Follows the same pattern as [DashboardCubit].
class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;

  ProductCubit({ProductRepository? productRepository})
      : _productRepository = productRepository ??
            ProductRepository(
              ApiService(),
            ),
        super(const ProductInitial());

  /// Load products from the API.
  /// 
  /// [search] Optional search query
  /// [categoryId] Optional category filter
  /// [isActive] Optional active status filter
  /// [perPage] Number of items per page
  /// [sortBy] Field to sort by
  /// [sortOrder] Sort order
  Future<void> loadProducts({
    String? search,
    int? categoryId,
    bool? isActive,
    int perPage = 15,
    String sortBy = 'name',
    String sortOrder = 'asc',
  }) async {
    if (isClosed) return;

    emit(const ProductLoading());

    try {
      final result = await _productRepository.getProducts(
        search: search,
        categoryId: categoryId,
        isActive: isActive,
        perPage: perPage,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      if (isClosed) return;

      emit(ProductLoaded(
        products: result['products'] as List<ProductApiModel>,
        paginationMeta: result['meta'] as Map<String, dynamic>?,
        paginationLinks: result['links'] as Map<String, dynamic>?,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(ProductError(e.toString()));
    }
  }

  /// Refresh products (reload with current filters).
  Future<void> refresh() async {
    await loadProducts();
  }

  /// Create a new product.
  Future<void> createProduct(Map<String, dynamic> productData) async {
    try {
      await _productRepository.createProduct(productData);
      // Reload products after creation
      await refresh();
    } catch (e) {
      if (isClosed) return;
      emit(ProductError(e.toString()));
    }
  }

  /// Update an existing product.
  Future<void> updateProduct(int id, Map<String, dynamic> productData) async {
    try {
      await _productRepository.updateProduct(id, productData);
      // Reload products after update
      await refresh();
    } catch (e) {
      if (isClosed) return;
      emit(ProductError(e.toString()));
    }
  }

  /// Delete a product.
  Future<void> deleteProduct(int id) async {
    try {
      await _productRepository.deleteProduct(id);
      // Reload products after deletion
      await refresh();
    } catch (e) {
      if (isClosed) return;
      emit(ProductError(e.toString()));
    }
  }
}

