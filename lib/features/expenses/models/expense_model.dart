/// Expense model representing business expenses.
/// 
/// This data class represents an expense entry that can be linked
/// to purchases or stock movements, or be standalone.
class ExpenseModel {
  /// Unique identifier for the expense
  final int id;
  
  /// Expense category ID
  final int expenseCategoryId;
  
  /// Expense category information (when loaded)
  final ExpenseCategoryInfo? expenseCategory;
  
  /// Expense amount (as string to match API)
  final String amount;
  
  /// Optional notes about the expense
  final String? notes;
  
  /// Expense date (YYYY-MM-DD format)
  final String date;
  
  /// User ID who created this expense
  final int? createdBy;
  
  /// Creator information (when loaded)
  final CreatorInfo? creator;
  
  /// Purchase ID if linked to a purchase
  final int? purchaseId;
  
  /// Purchase information (when loaded)
  final PurchaseInfo? purchase;
  
  /// Stock movement ID if linked to a stock movement
  final int? stockMovementId;
  
  /// Stock movement information (when loaded)
  final dynamic stockMovement;
  
  /// Creation timestamp
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;

  /// Creates a new [ExpenseModel] instance.
  ExpenseModel({
    required this.id,
    required this.expenseCategoryId,
    this.expenseCategory,
    required this.amount,
    this.notes,
    required this.date,
    this.createdBy,
    this.creator,
    this.purchaseId,
    this.purchase,
    this.stockMovementId,
    this.stockMovement,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates an [ExpenseModel] from JSON data (API response).
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as int,
      expenseCategoryId: json['expense_category_id'] as int,
      expenseCategory: json['expense_category'] != null
          ? ExpenseCategoryInfo.fromJson(json['expense_category'] as Map<String, dynamic>)
          : null,
      amount: json['amount'] as String,
      notes: json['notes'] as String?,
      date: json['date'] as String,
      createdBy: json['created_by'] as int?,
      creator: json['creator'] != null
          ? CreatorInfo.fromJson(json['creator'] as Map<String, dynamic>)
          : null,
      purchaseId: json['purchase_id'] as int?,
      purchase: json['purchase'] != null
          ? PurchaseInfo.fromJson(json['purchase'] as Map<String, dynamic>)
          : null,
      stockMovementId: json['stock_movement_id'] as int?,
      stockMovement: json['stock_movement'],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the model to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expense_category_id': expenseCategoryId,
      'expense_category': expenseCategory?.toJson(),
      'amount': amount,
      'notes': notes,
      'date': date,
      'created_by': createdBy,
      'creator': creator?.toJson(),
      'purchase_id': purchaseId,
      'purchase': purchase?.toJson(),
      'stock_movement_id': stockMovementId,
      'stock_movement': stockMovement,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Gets the amount as a double value.
  double get amountValue => double.tryParse(amount) ?? 0.0;
}

/// Expense category information included in expense.
class ExpenseCategoryInfo {
  final int id;
  final String name;
  final String? description;

  ExpenseCategoryInfo({
    required this.id,
    required this.name,
    this.description,
  });

  factory ExpenseCategoryInfo.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

/// Creator information included in expense.
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

/// Purchase information included in expense.
class PurchaseInfo {
  final int id;
  final double totalAmount;

  PurchaseInfo({
    required this.id,
    required this.totalAmount,
  });

  factory PurchaseInfo.fromJson(Map<String, dynamic> json) {
    return PurchaseInfo(
      id: json['id'] as int,
      totalAmount: (json['total_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_amount': totalAmount,
    };
  }
}

