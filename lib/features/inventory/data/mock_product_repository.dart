import '../models/product_api_model.dart';

/// Mock repository for product data.
/// 
/// Provides sample product data matching the Laravel API structure.
/// This is used for development and testing when the API is not available.
class MockProductRepository {
  /// Returns a list of sample products.
  /// 
  /// This method provides mock data that matches the API response format.
  /// In production, this should be replaced with actual API calls.
  static Future<List<ProductApiModel>> getProducts({
    String? search,
    int? categoryId,
    bool? isActive,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var products = _mockProducts;

    // Apply filters
    if (search != null && search.isNotEmpty) {
      final searchLower = search.toLowerCase();
      products = products.where((product) {
        return product.name.toLowerCase().contains(searchLower) ||
            product.sku.toLowerCase().contains(searchLower);
      }).toList();
    }

    if (categoryId != null) {
      products = products.where((product) => product.categoryId == categoryId).toList();
    }

    if (isActive != null) {
      products = products.where((product) => product.isActive == isActive).toList();
    }

    return products;
  }

  /// Returns a single product by ID.
  static Future<ProductApiModel?> getProductById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mock products data matching API structure.
  static final List<ProductApiModel> _mockProducts = [
    ProductApiModel(
      id: 1,
      name: 'Smart Watch Series 5',
      sku: 'SWT-2024-087',
      categoryId: 1,
      category: CategoryInfo(id: 1, name: 'Electronics'),
      costPrice: 180.00,
      sellingPrice: 299.99,
      stock: 8,
      isActive: true,
      photos: ['assets/images/smartwatch.png'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ProductApiModel(
      id: 2,
      name: 'USB-C Charging Cable',
      sku: 'ACC-2024-234',
      categoryId: 2,
      category: CategoryInfo(id: 2, name: 'Accessories'),
      costPrice: 8.00,
      sellingPrice: 19.99,
      stock: 0,
      isActive: true,
      photos: ['assets/images/usb_cable.png'],
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ProductApiModel(
      id: 3,
      name: 'Laptop Stand Aluminium',
      sku: 'LTS-2024-056',
      categoryId: 2,
      category: CategoryInfo(id: 2, name: 'Accessories'),
      costPrice: 25.00,
      sellingPrice: 49.99,
      stock: 89,
      isActive: true,
      photos: ['assets/images/laptop_stand.png'],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ProductApiModel(
      id: 4,
      name: 'Mechanical Keyboard RGB',
      sku: 'KEY-2024-112',
      categoryId: 1,
      category: CategoryInfo(id: 1, name: 'Electronics'),
      costPrice: 75.00,
      sellingPrice: 129.99,
      stock: 120,
      isActive: true,
      photos: ['assets/images/keyboard.png'],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ProductApiModel(
      id: 5,
      name: 'Wireless Bluetooth Headphone',
      sku: 'WBH-2024-001',
      categoryId: 1,
      category: CategoryInfo(id: 1, name: 'Electronics'),
      costPrice: 45.00,
      sellingPrice: 80.00,
      stock: 15,
      isActive: true,
      photos: ['assets/images/headphone.png'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
    ProductApiModel(
      id: 6,
      name: 'Wireless Mouse',
      sku: 'WMS-2024-045',
      categoryId: 2,
      category: CategoryInfo(id: 2, name: 'Accessories'),
      costPrice: 12.00,
      sellingPrice: 24.99,
      stock: 50,
      isActive: true,
      photos: [],
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ProductApiModel(
      id: 7,
      name: 'USB Hub 4-Port',
      sku: 'USB-2024-078',
      categoryId: 2,
      category: CategoryInfo(id: 2, name: 'Accessories'),
      costPrice: 15.00,
      sellingPrice: 29.99,
      stock: 0,
      isActive: false,
      photos: [],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}

