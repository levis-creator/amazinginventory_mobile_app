/// Expense category model representing expense categories.
/// 
/// This data class represents a category for organizing expenses.
class ExpenseCategoryModel {
  /// Unique identifier for the expense category
  final int id;
  
  /// Category name
  final String name;
  
  /// Optional category description
  final String? description;
  
  /// Whether the category is active
  final bool isActive;
  
  /// Creation timestamp
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;

  /// Creates a new [ExpenseCategoryModel] instance.
  ExpenseCategoryModel({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates an [ExpenseCategoryModel] from JSON data (API response).
  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the model to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a copy of this model with updated fields.
  ExpenseCategoryModel copyWith({
    int? id,
    String? name,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

