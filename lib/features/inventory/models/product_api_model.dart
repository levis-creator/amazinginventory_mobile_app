/// Product API model matching Laravel API structure.
/// 
/// This data class represents a product as returned by the Laravel API.
/// It matches the ProductResource structure from the backend.
class ProductApiModel {
  /// Unique identifier for the product
  final int id;
  
  /// Product name
  final String name;
  
  /// Stock Keeping Unit (SKU) identifier
  final String sku;
  
  /// Category ID
  final int? categoryId;
  
  /// Category information (when loaded)
  final CategoryInfo? category;
  
  /// Cost price per unit
  final double costPrice;
  
  /// Selling price per unit
  final double sellingPrice;
  
  /// Current stock quantity
  final int stock;
  
  /// Whether the product is active
  final bool isActive;
  
  /// Product photos URLs
  final List<String>? photos;
  
  /// Creation timestamp
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;

  /// Creates a new [ProductApiModel] instance.
  ProductApiModel({
    required this.id,
    required this.name,
    required this.sku,
    this.categoryId,
    this.category,
    required this.costPrice,
    required this.sellingPrice,
    required this.stock,
    required this.isActive,
    this.photos,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a [ProductApiModel] from JSON data (API response).
  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    return ProductApiModel(
      id: json['id'] as int,
      name: json['name'] as String,
      sku: json['sku'] as String,
      categoryId: json['category_id'] as int?,
      category: json['category'] != null
          ? CategoryInfo.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      costPrice: (json['cost_price'] as num).toDouble(),
      sellingPrice: (json['selling_price'] as num).toDouble(),
      stock: json['stock'] as int,
      isActive: json['is_active'] as bool? ?? true,
      photos: json['photos'] != null
          ? (json['photos'] as List).map((photo) => photo as String).toList()
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the model to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'category_id': categoryId,
      'category': category?.toJson(),
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'stock': stock,
      'is_active': isActive,
      'photos': photos,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a copy of this model with updated fields.
  ProductApiModel copyWith({
    int? id,
    String? name,
    String? sku,
    int? categoryId,
    CategoryInfo? category,
    double? costPrice,
    double? sellingPrice,
    int? stock,
    bool? isActive,
    List<String>? photos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductApiModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Category information included in product.
class CategoryInfo {
  final int id;
  final String name;

  CategoryInfo({
    required this.id,
    required this.name,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
