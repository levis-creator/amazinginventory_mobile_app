/// Sale model representing sales transactions.
/// 
/// This data class represents a sale transaction with items.
class SaleModel {
  /// Unique identifier for the sale
  final int id;
  
  /// Customer name
  final String customerName;
  
  /// Total sale amount
  final double totalAmount;
  
  /// User ID who created this sale
  final int? createdBy;
  
  /// Creator information (when loaded)
  final CreatorInfo? creator;
  
  /// Sale items
  final List<SaleItem>? items;
  
  /// Items count (when available)
  final int? itemsCount;
  
  /// Creation timestamp
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;

  /// Creates a new [SaleModel] instance.
  SaleModel({
    required this.id,
    required this.customerName,
    required this.totalAmount,
    this.createdBy,
    this.creator,
    this.items,
    this.itemsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a [SaleModel] from JSON data (API response).
  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] as int,
      customerName: json['customer_name'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      createdBy: json['created_by'] as int?,
      creator: json['creator'] != null
          ? CreatorInfo.fromJson(json['creator'] as Map<String, dynamic>)
          : null,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => SaleItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      itemsCount: json['items_count'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the model to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'total_amount': totalAmount,
      'created_by': createdBy,
      'creator': creator?.toJson(),
      'items': items?.map((item) => item.toJson()).toList(),
      'items_count': itemsCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Sale item information.
class SaleItem {
  final int id;
  final int productId;
  final ProductInfo? product;
  final int quantity;
  final double sellingPrice;
  final double subtotal;

  SaleItem({
    required this.id,
    required this.productId,
    this.product,
    required this.quantity,
    required this.sellingPrice,
    required this.subtotal,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      product: json['product'] != null
          ? ProductInfo.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      quantity: json['quantity'] as int,
      sellingPrice: (json['selling_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product': product?.toJson(),
      'quantity': quantity,
      'selling_price': sellingPrice,
      'subtotal': subtotal,
    };
  }
}

/// Product information included in sale items.
class ProductInfo {
  final int id;
  final String name;
  final String sku;

  ProductInfo({
    required this.id,
    required this.name,
    required this.sku,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      sku: json['sku'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
    };
  }
}

/// Creator information included in sale.
class CreatorInfo {
  final int id;
  final String name;
  final String email;

  CreatorInfo({
    required this.id,
    required this.name,
    required this.email,
  });

  factory CreatorInfo.fromJson(Map<String, dynamic> json) {
    return CreatorInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

