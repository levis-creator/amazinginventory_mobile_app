import 'product_api_model.dart';

/// Product model representing inventory items.
/// 
/// This data class follows clean architecture principles and represents
/// a single product in the inventory system. It includes all product
/// information including stock levels, pricing, and status.
/// 
/// Example:
/// ```dart
/// final product = ProductModel(
///   id: '1',
///   name: 'Smart Watch Series 5',
///   sku: 'SWT-2024-087',
///   stock: 8,
///   imageUrl: 'assets/images/smartwatch.png',
///   stockChangePercent: -12.0,
///   status: StockStatus.lowStock,
///   category: 'Electronics',
///   sellingPrice: 299.99,
///   purchasePrice: 180.00,
///   rating: 4.3,
/// );
/// ```
class ProductModel {
  /// Unique identifier for the product
  final String id;
  
  /// Product name
  final String name;
  
  /// Stock Keeping Unit (SKU) identifier
  final String sku;
  
  /// Current stock quantity
  final int stock;
  
  /// URL or path to the product image
  final String imageUrl;
  
  /// Percentage change in stock (positive or negative)
  final double stockChangePercent;
  
  /// Current stock status (in stock, low stock, or out of stock)
  final StockStatus status;
  
  /// Optional product category
  final String? category;
  
  /// Optional selling price
  final double? sellingPrice;
  
  /// Optional purchase/cost price
  final double? purchasePrice;
  
  /// Optional product rating (typically 0-5)
  final double? rating;

  /// Creates a new [ProductModel] instance.
  /// 
  /// [id], [name], [sku], [stock], [imageUrl], [stockChangePercent], and [status]
  /// are required. All other fields are optional.
  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.stock,
    required this.imageUrl,
    required this.stockChangePercent,
    required this.status,
    this.category,
    this.sellingPrice,
    this.purchasePrice,
    this.rating,
  });

  /// Creates a [ProductModel] from a [ProductApiModel].
  /// 
  /// Converts the API model to the UI model format.
  factory ProductModel.fromApiModel(ProductApiModel apiModel) {
    // Determine stock status
    StockStatus status;
    if (apiModel.stock == 0) {
      status = StockStatus.outOfStock;
    } else if (apiModel.stock < 10) {
      status = StockStatus.lowStock;
    } else {
      status = StockStatus.inStock;
    }

    // Get first photo or use placeholder
    final imageUrl = apiModel.photos?.isNotEmpty == true
        ? apiModel.photos!.first
        : 'assets/images/placeholder.png';

    // Calculate stock change percent (mock for now, could be calculated from history)
    final stockChangePercent = 0.0;

    return ProductModel(
      id: apiModel.id.toString(),
      name: apiModel.name,
      sku: apiModel.sku,
      stock: apiModel.stock,
      imageUrl: imageUrl,
      stockChangePercent: stockChangePercent,
      status: status,
      category: apiModel.category?.name,
      sellingPrice: apiModel.sellingPrice,
      purchasePrice: apiModel.costPrice,
    );
  }

  /// Returns a list of sample products for demonstration purposes.
  /// 
  /// This method provides mock data for development and testing.
  /// In production, products should be fetched from the API.
  /// 
  /// Returns a list of 5 sample [ProductModel] instances.
  static List<ProductModel> getSampleProducts() {
    return [
      ProductModel(
        id: '1',
        name: 'Smart Watch Series 5',
        sku: 'SWT-2024-087',
        stock: 8,
        imageUrl: 'assets/images/smartwatch.png',
        stockChangePercent: -12.0,
        status: StockStatus.lowStock,
        category: 'Electronics',
        sellingPrice: 299.99,
        purchasePrice: 180.00,
        rating: 4.3,
      ),
      ProductModel(
        id: '2',
        name: 'USB-C Charging Cable',
        sku: 'ACC-2024-234',
        stock: 0,
        imageUrl: 'assets/images/usb_cable.png',
        stockChangePercent: -100.0,
        status: StockStatus.outOfStock,
        category: 'Accessories',
        sellingPrice: 19.99,
        purchasePrice: 8.00,
        rating: 4.0,
      ),
      ProductModel(
        id: '3',
        name: 'Laptop Stand Aluminium',
        sku: 'LTS-2024-056',
        stock: 89,
        imageUrl: 'assets/images/laptop_stand.png',
        stockChangePercent: -6.0,
        status: StockStatus.inStock,
        category: 'Accessories',
        sellingPrice: 49.99,
        purchasePrice: 25.00,
        rating: 4.7,
      ),
      ProductModel(
        id: '4',
        name: 'Mechanical Keyboard RGB',
        sku: 'KEY-2024-112',
        stock: 120,
        imageUrl: 'assets/images/keyboard.png',
        stockChangePercent: -8.0,
        status: StockStatus.inStock,
        category: 'Electronics',
        sellingPrice: 129.99,
        purchasePrice: 75.00,
        rating: 4.5,
      ),
      ProductModel(
        id: '5',
        name: 'Wireless Bluetooth Headphone',
        sku: 'WBH-2024-001',
        stock: 15,
        imageUrl: 'assets/images/headphone.png',
        stockChangePercent: 6.0,
        status: StockStatus.inStock,
        category: 'Electronics',
        sellingPrice: 80.00,
        purchasePrice: 45.00,
        rating: 4.5,
      ),
    ];
  }
}

/// Stock status enumeration for products.
/// 
/// Used to categorize products based on their current stock levels:
/// - [inStock]: Product has sufficient stock
/// - [lowStock]: Product stock is below threshold
/// - [outOfStock]: Product has no stock available
enum StockStatus {
  /// Product has sufficient stock available
  inStock,
  
  /// Product stock is below the low stock threshold
  lowStock,
  
  /// Product has no stock available (stock = 0)
  outOfStock,
}

