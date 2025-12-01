import '../models/expense_category_model.dart';

/// Mock repository for expense category data.
/// 
/// Provides sample expense category data matching the Laravel API structure.
/// This is used for development and testing when the API is not available.
class MockExpenseCategoryRepository {
  /// Returns a list of sample expense categories.
  /// 
  /// This method provides mock data that matches the API response format.
  /// In production, this should be replaced with actual API calls.
  static Future<List<ExpenseCategoryModel>> getExpenseCategories({
    String? search,
    bool? isActive,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var categories = _mockExpenseCategories;

    // Apply filters
    if (search != null && search.isNotEmpty) {
      final searchLower = search.toLowerCase();
      categories = categories.where((cat) {
        return cat.name.toLowerCase().contains(searchLower) ||
            (cat.description?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }

    if (isActive != null) {
      categories = categories.where((cat) => cat.isActive == isActive).toList();
    }

    return categories;
  }

  /// Returns a single expense category by ID.
  static Future<ExpenseCategoryModel?> getExpenseCategoryById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockExpenseCategories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mock expense categories data matching API structure.
  static final List<ExpenseCategoryModel> _mockExpenseCategories = [
    ExpenseCategoryModel(
      id: 1,
      name: 'Bale Purchase',
      description: 'Auto-created expense category for purchase orders',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    ExpenseCategoryModel(
      id: 2,
      name: 'Transport',
      description: 'Transportation expenses',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 55)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ExpenseCategoryModel(
      id: 3,
      name: 'Packaging',
      description: 'Packaging materials and supplies',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ExpenseCategoryModel(
      id: 4,
      name: 'Rent',
      description: 'Rental expenses for facilities',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ExpenseCategoryModel(
      id: 5,
      name: 'Electricity',
      description: 'Electricity and utility bills',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ExpenseCategoryModel(
      id: 6,
      name: 'Salary',
      description: 'Employee salaries and wages',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 35)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ExpenseCategoryModel(
      id: 7,
      name: 'Marketing',
      description: 'Marketing and advertising expenses',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    ExpenseCategoryModel(
      id: 8,
      name: 'Repairs',
      description: 'Repair and maintenance expenses',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now(),
    ),
    ExpenseCategoryModel(
      id: 9,
      name: 'Cleaning',
      description: 'Cleaning supplies and services',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
    ),
    ExpenseCategoryModel(
      id: 10,
      name: 'Licenses',
      description: 'Business licenses and permits',
      isActive: false,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}

