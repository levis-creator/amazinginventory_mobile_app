/// Stock movement model representing inventory stock changes.
/// 
/// This data class represents a stock movement entry that tracks
/// when stock is added (in) or removed (out) from inventory.
class StockMovementModel {
  /// Unique identifier for the stock movement
  final int id;
  
  /// Product ID associated with this movement
  final int productId;
  
  /// Product information (when loaded)
  final ProductInfo? product;
  
  /// Movement type: 'in' or 'out'
  final String type;
  
  /// Quantity changed
  final int quantity;
  
  /// Reason for movement: 'purchase', 'sale', or 'adjustment'
  final String reason;
  
  /// Optional notes about the movement
  final String? notes;
  
  /// User ID who created this movement
  final int? createdBy;
  
  /// Creator information (when loaded)
  final CreatorInfo? creator;
  
  /// Creation timestamp
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;

  /// Creates a new [StockMovementModel] instance.
  StockMovementModel({
    required this.id,
    required this.productId,
    this.product,
    required this.type,
    required this.quantity,
    required this.reason,
    this.notes,
    this.createdBy,
    this.creator,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a [StockMovementModel] from JSON data (API response).
  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    return StockMovementModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      product: json['product'] != null
          ? ProductInfo.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      type: json['type'] as String,
      quantity: json['quantity'] as int,
      reason: json['reason'] as String,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as int?,
      creator: json['creator'] != null
          ? CreatorInfo.fromJson(json['creator'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the model to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product': product?.toJson(),
      'type': type,
      'quantity': quantity,
      'reason': reason,
      'notes': notes,
      'created_by': createdBy,
      'creator': creator?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a copy of this model with updated fields.
  StockMovementModel copyWith({
    int? id,
    int? productId,
    ProductInfo? product,
    String? type,
    int? quantity,
    String? reason,
    String? notes,
    int? createdBy,
    CreatorInfo? creator,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StockMovementModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      creator: creator ?? this.creator,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Product information included in stock movement.
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

/// Creator information included in stock movement.
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

