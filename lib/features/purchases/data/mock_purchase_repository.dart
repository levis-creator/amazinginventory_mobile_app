import '../models/purchase_model.dart';

/// Mock repository for purchase data.
/// 
/// Provides sample purchase data matching the Laravel API structure.
/// This is used for development and testing when the API is not available.
class MockPurchaseRepository {
  /// Returns a list of sample purchases.
  /// 
  /// This method provides mock data that matches the API response format.
  /// In production, this should be replaced with actual API calls.
  static Future<List<PurchaseModel>> getPurchases({
    String? search,
    int? supplierId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var purchases = _mockPurchases;

    // Apply filters
    if (search != null && search.isNotEmpty) {
      final searchLower = search.toLowerCase();
      purchases = purchases.where((purchase) {
        return purchase.supplier?.name.toLowerCase().contains(searchLower) ?? false;
      }).toList();
    }

    if (supplierId != null) {
      purchases = purchases.where((purchase) => purchase.supplierId == supplierId).toList();
    }

    return purchases;
  }

  /// Returns a single purchase by ID.
  static Future<PurchaseModel?> getPurchaseById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockPurchases.firstWhere((purchase) => purchase.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mock purchases data matching API structure.
  static final List<PurchaseModel> _mockPurchases = [
    PurchaseModel(
      id: 1,
      supplierId: 1,
      supplier: SupplierInfo(
        id: 1,
        name: 'ABC Electronics Ltd.',
        contact: '+1-555-0101',
        email: 'contact@abcelectronics.com',
      ),
      totalAmount: 9000.00,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      items: [
        PurchaseItem(
          id: 1,
          productId: 1,
          product: ProductInfo(id: 1, name: 'Smart Watch Series 5', sku: 'SWT-2024-087'),
          quantity: 50,
          costPrice: 180.00,
          subtotal: 9000.00,
        ),
      ],
      itemsCount: 1,
      expenses: [
        PurchaseExpense(
          id: 1,
          expenseCategoryId: 1,
          expenseCategory: ExpenseCategoryInfo(id: 1, name: 'Bale Purchase'),
          amount: '9000.00',
          notes: 'Auto-created expense for Purchase #1',
          date: DateTime.now().subtract(const Duration(days: 10)).toIso8601String().split('T')[0],
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        PurchaseExpense(
          id: 2,
          expenseCategoryId: 2,
          expenseCategory: ExpenseCategoryInfo(id: 2, name: 'Transport'),
          amount: '300.00',
          notes: 'Transport cost for delivery',
          date: DateTime.now().subtract(const Duration(days: 10)).toIso8601String().split('T')[0],
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ],
      expensesCount: 2,
      expensesTotal: '9300.00',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    PurchaseModel(
      id: 2,
      supplierId: 2,
      supplier: SupplierInfo(
        id: 2,
        name: 'Global Supplies Inc.',
        contact: '+1-555-0202',
        email: 'info@globalsupplies.com',
      ),
      totalAmount: 800.00,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      items: [
        PurchaseItem(
          id: 2,
          productId: 2,
          product: ProductInfo(id: 2, name: 'USB-C Charging Cable', sku: 'ACC-2024-234'),
          quantity: 100,
          costPrice: 8.00,
          subtotal: 800.00,
        ),
      ],
      itemsCount: 1,
      expenses: [
        PurchaseExpense(
          id: 3,
          expenseCategoryId: 1,
          expenseCategory: ExpenseCategoryInfo(id: 1, name: 'Bale Purchase'),
          amount: '800.00',
          notes: 'Auto-created expense for Purchase #2',
          date: DateTime.now().subtract(const Duration(days: 7)).toIso8601String().split('T')[0],
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
      ],
      expensesCount: 1,
      expensesTotal: '800.00',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    PurchaseModel(
      id: 3,
      supplierId: 3,
      supplier: SupplierInfo(
        id: 3,
        name: 'Premium Accessories Co.',
        contact: '+1-555-0303',
        email: 'sales@premiumaccessories.com',
      ),
      totalAmount: 2500.00,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      items: [
        PurchaseItem(
          id: 3,
          productId: 3,
          product: ProductInfo(id: 3, name: 'Laptop Stand Aluminium', sku: 'LTS-2024-056'),
          quantity: 100,
          costPrice: 25.00,
          subtotal: 2500.00,
        ),
      ],
      itemsCount: 1,
      expenses: [
        PurchaseExpense(
          id: 4,
          expenseCategoryId: 1,
          expenseCategory: ExpenseCategoryInfo(id: 1, name: 'Bale Purchase'),
          amount: '2500.00',
          notes: 'Auto-created expense for Purchase #3',
          date: DateTime.now().subtract(const Duration(days: 4)).toIso8601String().split('T')[0],
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        PurchaseExpense(
          id: 5,
          expenseCategoryId: 3,
          expenseCategory: ExpenseCategoryInfo(id: 3, name: 'Packaging'),
          amount: '100.00',
          notes: 'Packaging materials',
          date: DateTime.now().subtract(const Duration(days: 4)).toIso8601String().split('T')[0],
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
      ],
      expensesCount: 2,
      expensesTotal: '2600.00',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    PurchaseModel(
      id: 4,
      supplierId: 4,
      supplier: SupplierInfo(
        id: 4,
        name: 'Tech Solutions Group',
        contact: '+1-555-0404',
        email: 'hello@techsolutions.com',
      ),
      totalAmount: 11250.00,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      items: [
        PurchaseItem(
          id: 4,
          productId: 4,
          product: ProductInfo(id: 4, name: 'Mechanical Keyboard RGB', sku: 'KEY-2024-112'),
          quantity: 150,
          costPrice: 75.00,
          subtotal: 11250.00,
        ),
      ],
      itemsCount: 1,
      expenses: [
        PurchaseExpense(
          id: 6,
          expenseCategoryId: 1,
          expenseCategory: ExpenseCategoryInfo(id: 1, name: 'Bale Purchase'),
          amount: '11250.00',
          notes: 'Auto-created expense for Purchase #4',
          date: DateTime.now().subtract(const Duration(days: 2)).toIso8601String().split('T')[0],
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
      expensesCount: 1,
      expensesTotal: '11250.00',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PurchaseModel(
      id: 5,
      supplierId: 5,
      supplier: SupplierInfo(
        id: 5,
        name: 'Quality Goods Distributors',
        contact: '+1-555-0505',
        email: 'orders@qualitygoods.com',
      ),
      totalAmount: 900.00,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      items: [
        PurchaseItem(
          id: 5,
          productId: 5,
          product: ProductInfo(id: 5, name: 'Wireless Bluetooth Headphone', sku: 'WBH-2024-001'),
          quantity: 20,
          costPrice: 45.00,
          subtotal: 900.00,
        ),
      ],
      itemsCount: 1,
      expenses: [
        PurchaseExpense(
          id: 7,
          expenseCategoryId: 1,
          expenseCategory: ExpenseCategoryInfo(id: 1, name: 'Bale Purchase'),
          amount: '900.00',
          notes: 'Auto-created expense for Purchase #5',
          date: DateTime.now().subtract(const Duration(hours: 6)).toIso8601String().split('T')[0],
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ],
      expensesCount: 1,
      expensesTotal: '900.00',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];
}

