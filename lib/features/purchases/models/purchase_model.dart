/// Purchase model representing purchase orders.
/// 
/// This data class represents a purchase order with items and expenses.
class PurchaseModel {
  /// Unique identifier for the purchase
  final int id;
  
  /// Supplier ID
  final int supplierId;
  
  /// Supplier information (when loaded)
  final SupplierInfo? supplier;
  
  /// Total purchase amount
  final double totalAmount;
  
  /// User ID who created this purchase
  final int? createdBy;
  
  /// Creator information (when loaded)
  final CreatorInfo? creator;
  
  /// Purchase items
  final List<PurchaseItem>? items;
  
  /// Items count (when available)
  final int? itemsCount;
  
  /// Expenses linked to this purchase
  final List<PurchaseExpense>? expenses;
  
  /// Expenses count (when available)
  final int? expensesCount;
  
  /// Total expenses amount (when available)
  final String? expensesTotal;
  
  /// Creation timestamp
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;

  /// Creates a new [PurchaseModel] instance.
  PurchaseModel({
    required this.id,
    required this.supplierId,
    this.supplier,
    required this.totalAmount,
    this.createdBy,
    this.creator,
    this.items,
    this.itemsCount,
    this.expenses,
    this.expensesCount,
    this.expensesTotal,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a [PurchaseModel] from JSON data (API response).
  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'] as int,
      supplierId: json['supplier_id'] as int,
      supplier: json['supplier'] != null
          ? SupplierInfo.fromJson(json['supplier'] as Map<String, dynamic>)
          : null,
      totalAmount: (json['total_amount'] as num).toDouble(),
      createdBy: json['created_by'] as int?,
      creator: json['creator'] != null
          ? CreatorInfo.fromJson(json['creator'] as Map<String, dynamic>)
          : null,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => PurchaseItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      itemsCount: json['items_count'] as int?,
      expenses: json['expenses'] != null
          ? (json['expenses'] as List)
              .map((expense) => PurchaseExpense.fromJson(expense as Map<String, dynamic>))
              .toList()
          : null,
      expensesCount: json['expenses_count'] as int?,
      expensesTotal: json['expenses_total'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the model to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplier_id': supplierId,
      'supplier': supplier?.toJson(),
      'total_amount': totalAmount,
      'created_by': createdBy,
      'creator': creator?.toJson(),
      'items': items?.map((item) => item.toJson()).toList(),
      'items_count': itemsCount,
      'expenses': expenses?.map((expense) => expense.toJson()).toList(),
      'expenses_count': expensesCount,
      'expenses_total': expensesTotal,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Purchase item information.
class PurchaseItem {
  final int id;
  final int productId;
  final ProductInfo? product;
  final int quantity;
  final double costPrice;
  final double subtotal;

  PurchaseItem({
    required this.id,
    required this.productId,
    this.product,
    required this.quantity,
    required this.costPrice,
    required this.subtotal,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      product: json['product'] != null
          ? ProductInfo.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      quantity: json['quantity'] as int,
      costPrice: (json['cost_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product': product?.toJson(),
      'quantity': quantity,
      'cost_price': costPrice,
      'subtotal': subtotal,
    };
  }
}

/// Purchase expense information.
class PurchaseExpense {
  final int id;
  final int expenseCategoryId;
  final ExpenseCategoryInfo? expenseCategory;
  final String amount;
  final String? notes;
  final String date;
  final DateTime createdAt;

  PurchaseExpense({
    required this.id,
    required this.expenseCategoryId,
    this.expenseCategory,
    required this.amount,
    this.notes,
    required this.date,
    required this.createdAt,
  });

  factory PurchaseExpense.fromJson(Map<String, dynamic> json) {
    return PurchaseExpense(
      id: json['id'] as int,
      expenseCategoryId: json['expense_category_id'] as int,
      expenseCategory: json['expense_category'] != null
          ? ExpenseCategoryInfo.fromJson(json['expense_category'] as Map<String, dynamic>)
          : null,
      amount: json['amount'] as String,
      notes: json['notes'] as String?,
      date: json['date'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expense_category_id': expenseCategoryId,
      'expense_category': expenseCategory?.toJson(),
      'amount': amount,
      'notes': notes,
      'date': date,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Supplier information included in purchase.
class SupplierInfo {
  final int id;
  final String name;
  final String? contact;
  final String? email;

  SupplierInfo({
    required this.id,
    required this.name,
    this.contact,
    this.email,
  });

  factory SupplierInfo.fromJson(Map<String, dynamic> json) {
    return SupplierInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      contact: json['contact'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'email': email,
    };
  }
}

/// Product information included in purchase items.
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

/// Expense category information included in purchase expenses.
class ExpenseCategoryInfo {
  final int id;
  final String name;

  ExpenseCategoryInfo({
    required this.id,
    required this.name,
  });

  factory ExpenseCategoryInfo.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryInfo(
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

/// Creator information included in purchase.
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

