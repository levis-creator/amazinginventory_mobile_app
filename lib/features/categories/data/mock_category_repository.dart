import '../models/category_model.dart';

/// Mock repository for category data.
/// 
/// Provides sample category data matching the Laravel API structure.
/// This is used for development and testing when the API is not available.
class MockCategoryRepository {
  /// Returns a list of sample categories.
  /// 
  /// This method provides mock data that matches the API response format.
  /// In production, this should be replaced with actual API calls.
  static Future<List<CategoryModel>> getCategories({
    String? search,
    bool? isActive,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var categories = _mockCategories;

    // Apply filters
    if (search != null && search.isNotEmpty) {
      categories = categories.where((cat) {
        final searchLower = search.toLowerCase();
        return cat.name.toLowerCase().contains(searchLower) ||
            (cat.description?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }

    if (isActive != null) {
      categories = categories.where((cat) => cat.isActive == isActive).toList();
    }

    return categories;
  }

  /// Returns a single category by ID.
  static Future<CategoryModel?> getCategoryById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockCategories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mock categories data matching API structure.
  static final List<CategoryModel> _mockCategories = [
    CategoryModel(
      id: 1,
      name: 'Electronics',
      description: 'Electronic devices and accessories',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    CategoryModel(
      id: 2,
      name: 'Accessories',
      description: 'Product accessories and add-ons',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    CategoryModel(
      id: 3,
      name: 'Clothing',
      description: 'Apparel and clothing items',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    CategoryModel(
      id: 4,
      name: 'Home & Garden',
      description: 'Home improvement and garden supplies',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    CategoryModel(
      id: 5,
      name: 'Sports & Outdoors',
      description: 'Sports equipment and outdoor gear',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
    CategoryModel(
      id: 6,
      name: 'Books',
      description: 'Books and reading materials',
      isActive: false,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    CategoryModel(
      id: 7,
      name: 'Toys & Games',
      description: 'Toys, games, and entertainment items',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
  ];
}

