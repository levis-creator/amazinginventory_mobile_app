import '../models/stock_movement_model.dart';

/// Mock repository for stock movement data.
/// 
/// Provides sample stock movement data matching the Laravel API structure.
/// This is used for development and testing when the API is not available.
class MockStockMovementRepository {
  /// Returns a list of sample stock movements.
  /// 
  /// This method provides mock data that matches the API response format.
  /// In production, this should be replaced with actual API calls.
  static Future<List<StockMovementModel>> getStockMovements({
    int? productId,
    String? type,
    String? reason,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var movements = _mockStockMovements;

    // Apply filters
    if (productId != null) {
      movements = movements.where((movement) => movement.productId == productId).toList();
    }

    if (type != null) {
      movements = movements.where((movement) => movement.type == type).toList();
    }

    if (reason != null) {
      movements = movements.where((movement) => movement.reason == reason).toList();
    }

    return movements;
  }

  /// Returns a single stock movement by ID.
  static Future<StockMovementModel?> getStockMovementById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockStockMovements.firstWhere((movement) => movement.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mock stock movements data matching API structure.
  static final List<StockMovementModel> _mockStockMovements = [
    StockMovementModel(
      id: 1,
      productId: 1,
      product: ProductInfo(id: 1, name: 'Smart Watch Series 5', sku: 'SWT-2024-087'),
      type: 'in',
      quantity: 50,
      reason: 'purchase',
      notes: 'Initial stock from supplier',
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    StockMovementModel(
      id: 2,
      productId: 1,
      product: ProductInfo(id: 1, name: 'Smart Watch Series 5', sku: 'SWT-2024-087'),
      type: 'out',
      quantity: 2,
      reason: 'sale',
      notes: 'Sold to customer',
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      updatedAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    StockMovementModel(
      id: 3,
      productId: 2,
      product: ProductInfo(id: 2, name: 'USB-C Charging Cable', sku: 'ACC-2024-234'),
      type: 'in',
      quantity: 100,
      reason: 'purchase',
      notes: 'Bulk purchase order',
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    StockMovementModel(
      id: 4,
      productId: 2,
      product: ProductInfo(id: 2, name: 'USB-C Charging Cable', sku: 'ACC-2024-234'),
      type: 'out',
      quantity: 100,
      reason: 'sale',
      notes: 'Sold out completely',
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    StockMovementModel(
      id: 5,
      productId: 3,
      product: ProductInfo(id: 3, name: 'Laptop Stand Aluminium', sku: 'LTS-2024-056'),
      type: 'in',
      quantity: 100,
      reason: 'purchase',
      notes: 'New stock arrival',
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    StockMovementModel(
      id: 6,
      productId: 3,
      product: ProductInfo(id: 3, name: 'Laptop Stand Aluminium', sku: 'LTS-2024-056'),
      type: 'out',
      quantity: 11,
      reason: 'sale',
      notes: null,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    StockMovementModel(
      id: 7,
      productId: 4,
      product: ProductInfo(id: 4, name: 'Mechanical Keyboard RGB', sku: 'KEY-2024-112'),
      type: 'in',
      quantity: 150,
      reason: 'purchase',
      notes: 'Premium keyboard stock',
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    StockMovementModel(
      id: 8,
      productId: 4,
      product: ProductInfo(id: 4, name: 'Mechanical Keyboard RGB', sku: 'KEY-2024-112'),
      type: 'out',
      quantity: 30,
      reason: 'sale',
      notes: null,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    StockMovementModel(
      id: 9,
      productId: 1,
      product: ProductInfo(id: 1, name: 'Smart Watch Series 5', sku: 'SWT-2024-087'),
      type: 'out',
      quantity: 40,
      reason: 'adjustment',
      notes: 'Stock correction - damaged items',
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    StockMovementModel(
      id: 10,
      productId: 5,
      product: ProductInfo(id: 5, name: 'Wireless Bluetooth Headphone', sku: 'WBH-2024-001'),
      type: 'in',
      quantity: 20,
      reason: 'purchase',
      notes: 'Restocking headphones',
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];
}

