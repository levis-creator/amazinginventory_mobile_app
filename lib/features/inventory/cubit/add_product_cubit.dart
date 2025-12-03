import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/di/service_locator.dart';
import '../../categories/models/category_model.dart';
import '../../categories/data/category_repository.dart';
import '../data/product_repository.dart';

/// Cubit for managing the add product form state
class AddProductCubit extends Cubit<AddProductState> {
  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;

  AddProductCubit({
    ProductRepository? productRepository,
    CategoryRepository? categoryRepository,
  })  : _productRepository = productRepository ?? getIt<ProductRepository>(),
        _categoryRepository = categoryRepository ?? getIt<CategoryRepository>(),
        super(const AddProductState.initial());

  /// Load categories from API
  Future<void> loadCategories() async {
    emit(state.copyWith(isLoadingCategories: true));

    try {
      final result = await _categoryRepository.getCategories(
        isActive: true,
        perPage: 50, // Load active categories (reduced to avoid timeouts)
        sortBy: 'name',
        sortOrder: 'asc',
      );

      final categories = result['categories'] as List<CategoryModel>;

      emit(state.copyWith(categories: categories, isLoadingCategories: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingCategories: false,
          error: 'Failed to load categories: ${e.toString()}',
        ),
      );
    }
  }

  /// Update product name
  void updateProductName(String name) {
    emit(state.copyWith(productName: name));
  }

  /// Update SKU
  void updateSku(String sku) {
    emit(state.copyWith(sku: sku));
  }

  /// Update cost price
  void updateCostPrice(String costPrice) {
    emit(state.copyWith(costPrice: costPrice));
  }

  /// Update selling price
  void updateSellingPrice(String sellingPrice) {
    emit(state.copyWith(sellingPrice: sellingPrice));
  }

  /// Update selected category
  void updateCategory(int? categoryId) {
    emit(state.copyWith(selectedCategoryId: categoryId));
  }

  /// Update stock quantity
  void updateStock(int stock) {
    emit(state.copyWith(stock: stock));
  }

  /// Increment stock
  void incrementStock() {
    emit(state.copyWith(stock: state.stock + 1));
  }

  /// Decrement stock
  void decrementStock() {
    if (state.stock > 0) {
      emit(state.copyWith(stock: state.stock - 1));
    }
  }

  /// Add category to the list (when created via modal)
  /// Also refreshes the category list from the backend to ensure consistency
  void addCategory(CategoryModel category) {
    // Add the category to the local list immediately for UI responsiveness
    final updatedCategories = List<CategoryModel>.from(state.categories)
      ..add(category);
    emit(
      state.copyWith(
        categories: updatedCategories,
        selectedCategoryId: category.id,
      ),
    );
    
    // Refresh categories from backend to ensure we have the latest data
    loadCategories();
  }

  /// Clear error message
  void clearError() {
    emit(state.copyWith(error: null));
  }

  /// Save product to API
  Future<void> saveProduct() async {
    // Validate required fields
    if (state.productName.trim().isEmpty) {
      emit(state.copyWith(error: 'Product name is required', isSaving: false));
      return;
    }

    if (state.selectedCategoryId == null) {
      emit(state.copyWith(error: 'Please select a category', isSaving: false));
      return;
    }

    if (state.costPrice.trim().isEmpty) {
      emit(state.copyWith(error: 'Cost price is required', isSaving: false));
      return;
    }

    if (state.sellingPrice.trim().isEmpty) {
      emit(state.copyWith(error: 'Selling price is required', isSaving: false));
      return;
    }

    // Parse prices
    final costPrice = double.tryParse(state.costPrice.trim());
    final sellingPrice = double.tryParse(state.sellingPrice.trim());

    if (costPrice == null || costPrice < 0) {
      emit(
        state.copyWith(
          error: 'Please enter a valid cost price',
          isSaving: false,
        ),
      );
      return;
    }

    if (sellingPrice == null || sellingPrice < 0) {
      emit(
        state.copyWith(
          error: 'Please enter a valid selling price',
          isSaving: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isSaving: true, error: null));

    try {
      // Format data to match API requirements (snake_case, proper types)
      final productData = <String, dynamic>{
        'name': state.productName.trim(),
        'category_id': state.selectedCategoryId!,
        'cost_price': costPrice,
        'selling_price': sellingPrice,
        'stock': state.stock,
        'is_active': true, // New products are active by default
      };

      // Handle optional SKU field (send only if not empty)
      final skuValue = state.sku.trim();
      if (skuValue.isNotEmpty) {
        productData['sku'] = skuValue;
      }

      // Make API call to create product using ProductRepository
      await _productRepository.createProduct(productData);

      emit(
        state.copyWith(
          isSaving: false,
          isSuccess: true,
          successMessage: 'Product created successfully!',
        ),
      );
    } on ApiException catch (e) {
      // Handle API validation errors (422) and other API errors
      String errorMessage = e.message;

      // If there are validation errors, format them nicely
      final formattedErrors = e.getFormattedErrors();
      if (formattedErrors != null) {
        errorMessage = formattedErrors;
      }

      emit(state.copyWith(isSaving: false, error: errorMessage));
    } catch (e) {
      // Handle network errors and other exceptions
      emit(
        state.copyWith(
          isSaving: false,
          error: 'Failed to save product: ${e.toString()}',
        ),
      );
    }
  }

  /// Reset state after successful save
  void reset() {
    emit(const AddProductState.initial());
  }
}

/// State class for add product form
class AddProductState extends Equatable {
  final String productName;
  final String sku;
  final String costPrice;
  final String sellingPrice;
  final int? selectedCategoryId;
  final List<CategoryModel> categories;
  final bool isLoadingCategories;
  final int stock;
  final bool isSaving;
  final bool isSuccess;
  final String? successMessage;
  final String? error;

  const AddProductState({
    this.productName = '',
    this.sku = '',
    this.costPrice = '',
    this.sellingPrice = '',
    this.selectedCategoryId,
    this.categories = const [],
    this.isLoadingCategories = false,
    this.stock = 0,
    this.isSaving = false,
    this.isSuccess = false,
    this.successMessage,
    this.error,
  });

  /// Initial state
  const AddProductState.initial()
    : productName = '',
      sku = '',
      costPrice = '',
      sellingPrice = '',
      selectedCategoryId = null,
      categories = const [],
      isLoadingCategories = false,
      stock = 0,
      isSaving = false,
      isSuccess = false,
      successMessage = null,
      error = null;

  /// Copy with method for immutable updates
  AddProductState copyWith({
    String? productName,
    String? sku,
    String? costPrice,
    String? sellingPrice,
    int? selectedCategoryId,
    List<CategoryModel>? categories,
    bool? isLoadingCategories,
    int? stock,
    bool? isSaving,
    bool? isSuccess,
    String? successMessage,
    String? error,
  }) {
    return AddProductState(
      productName: productName ?? this.productName,
      sku: sku ?? this.sku,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      categories: categories ?? this.categories,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      stock: stock ?? this.stock,
      isSaving: isSaving ?? this.isSaving,
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: successMessage ?? this.successMessage,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    productName,
    sku,
    costPrice,
    sellingPrice,
    selectedCategoryId,
    categories,
    isLoadingCategories,
    stock,
    isSaving,
    isSuccess,
    successMessage,
    error,
  ];
}
