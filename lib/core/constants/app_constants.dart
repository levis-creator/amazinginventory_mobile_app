/// Application-wide constants.
/// 
/// Centralized constant management following DRY (Don't Repeat Yourself) principle.
/// All app-wide constants should be defined here for easy maintenance.
/// 
/// Note: Colors are managed in [AppColors] class.
class AppConstants {
  // ==================== App Information ====================
  
  /// Application name displayed in various places
  static const String appName = 'Amazing Inventory';
  
  /// Current application version
  static const String appVersion = '1.0.0';

  // ==================== Navigation Indices ====================
  
  /// Bottom navigation bar index for Home/Dashboard tab
  static const int homeIndex = 0;
  
  /// Bottom navigation bar index for Inventory/Products tab
  static const int inventoryIndex = 1;
  
  /// Bottom navigation bar index for Notifications tab
  static const int notificationsIndex = 2;
  
  /// Bottom navigation bar index for More/Modules tab
  static const int moreIndex = 3;

  // ==================== Module Screen Identifiers ====================
  
  /// Module screen identifier for Sales
  static const String moduleSales = 'sales';
  
  /// Module screen identifier for Purchases
  static const String modulePurchases = 'purchases';
  
  /// Module screen identifier for Capital Investments
  static const String moduleCapital = 'capital';
  
  /// Module screen identifier for Expenses
  static const String moduleExpenses = 'expenses';
  
  /// Module screen identifier for Expense Categories
  static const String moduleExpenseCategories = 'expense_categories';
  
  /// Module screen identifier for Categories
  static const String moduleCategories = 'categories';
  
  /// Module screen identifier for Suppliers
  static const String moduleSuppliers = 'suppliers';
  
  /// Module screen identifier for Stock Movements
  static const String moduleStockMovements = 'stock_movements';
  
  /// Module screen identifier for Products
  static const String moduleProducts = 'products';

  // ==================== Dashboard Constants ====================
  
  /// Default notification count for dashboard badge (placeholder)
  static const int notificationCount = 2;
  
  /// Default user name for dashboard greeting (placeholder)
  static const String defaultUserName = 'Mark';
}

