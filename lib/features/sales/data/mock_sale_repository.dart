import '../models/sale_model.dart';

/// Mock repository for sale data.
/// 
/// Provides sample sale data matching the Laravel API structure.
/// This is used for development and testing when the API is not available.
class MockSaleRepository {
  /// Returns a list of sample sales.
  /// 
  /// This method provides mock data that matches the API response format.
  /// In production, this should be replaced with actual API calls.
  static Future<List<SaleModel>> getSales({
    String? search,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var sales = _mockSales;

    // Apply search filter
    if (search != null && search.isNotEmpty) {
      final searchLower = search.toLowerCase();
      sales = sales.where((sale) {
        return sale.customerName.toLowerCase().contains(searchLower);
      }).toList();
    }

    return sales;
  }

  /// Returns a single sale by ID.
  static Future<SaleModel?> getSaleById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockSales.firstWhere((sale) => sale.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mock sales data matching API structure.
  static final List<SaleModel> _mockSales = [
    SaleModel(
      id: 1,
      customerName: 'Alice Johnson',
      totalAmount: 599.98,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      items: [
        SaleItem(
          id: 1,
          productId: 1,
          product: ProductInfo(id: 1, name: 'Smart Watch Series 5', sku: 'SWT-2024-087'),
          quantity: 2,
          sellingPrice: 299.99,
          subtotal: 599.98,
        ),
      ],
      itemsCount: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      updatedAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    SaleModel(
      id: 2,
      customerName: 'Bob Smith',
      totalAmount: 19.99,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      items: [
        SaleItem(
          id: 2,
          productId: 2,
          product: ProductInfo(id: 2, name: 'USB-C Charging Cable', sku: 'ACC-2024-234'),
          quantity: 1,
          sellingPrice: 19.99,
          subtotal: 19.99,
        ),
      ],
      itemsCount: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    SaleModel(
      id: 3,
      customerName: 'Charlie Brown',
      totalAmount: 49.99,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      items: [
        SaleItem(
          id: 3,
          productId: 3,
          product: ProductInfo(id: 3, name: 'Laptop Stand Aluminium', sku: 'LTS-2024-056'),
          quantity: 1,
          sellingPrice: 49.99,
          subtotal: 49.99,
        ),
      ],
      itemsCount: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    SaleModel(
      id: 4,
      customerName: 'Diana Prince',
      totalAmount: 389.97,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      items: [
        SaleItem(
          id: 4,
          productId: 4,
          product: ProductInfo(id: 4, name: 'Mechanical Keyboard RGB', sku: 'KEY-2024-112'),
          quantity: 3,
          sellingPrice: 129.99,
          subtotal: 389.97,
        ),
      ],
      itemsCount: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    SaleModel(
      id: 5,
      customerName: 'Edward Wilson',
      totalAmount: 160.00,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      items: [
        SaleItem(
          id: 5,
          productId: 5,
          product: ProductInfo(id: 5, name: 'Wireless Bluetooth Headphone', sku: 'WBH-2024-001'),
          quantity: 2,
          sellingPrice: 80.00,
          subtotal: 160.00,
        ),
      ],
      itemsCount: 1,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    SaleModel(
      id: 6,
      customerName: 'Fiona Green',
      totalAmount: 649.97,
      createdBy: 1,
      creator: CreatorInfo(id: 1, name: 'John Doe', email: 'john@example.com'),
      items: [
        SaleItem(
          id: 6,
          productId: 4,
          product: ProductInfo(id: 4, name: 'Mechanical Keyboard RGB', sku: 'KEY-2024-112'),
          quantity: 2,
          sellingPrice: 129.99,
          subtotal: 259.98,
        ),
        SaleItem(
          id: 7,
          productId: 3,
          product: ProductInfo(id: 3, name: 'Laptop Stand Aluminium', sku: 'LTS-2024-056'),
          quantity: 3,
          sellingPrice: 49.99,
          subtotal: 149.97,
        ),
        SaleItem(
          id: 8,
          productId: 5,
          product: ProductInfo(id: 5, name: 'Wireless Bluetooth Headphone', sku: 'WBH-2024-001'),
          quantity: 3,
          sellingPrice: 80.00,
          subtotal: 240.00,
        ),
      ],
      itemsCount: 3,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];
}

