import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application-wide constants.
/// 
/// Centralized constant management following DRY (Don't Repeat Yourself) principle.
/// All app-wide constants should be defined here for easy maintenance.
/// 
/// Note: Colors are managed in [AppColors] class.
/// 
/// Environment variables are loaded from .env file using flutter_dotenv.
/// Make sure to call dotenv.load() in main() before using these constants.
class AppConstants {
  // ==================== App Information ====================
  
  /// Application name displayed in various places
  /// Loaded from .env file, falls back to default if not set
  static String get appName => dotenv.get('APP_NAME', fallback: 'Amazing Inventory');
  
  /// Current application version
  /// Loaded from .env file, falls back to default if not set
  static String get appVersion => dotenv.get('APP_VERSION', fallback: '1.0.0');

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

  // ==================== API Configuration ====================
  
  /// API base URL for production
  /// Loaded from .env file (API_BASE_URL_PRODUCTION)
  /// IMPORTANT: The base URL should end with '/api/v1' (not '/api/v1/api/v1')
  /// Laravel automatically adds '/api' prefix, so we only need '/v1' in routes
  static String get apiBaseUrlProduction => dotenv.get(
    'API_BASE_URL_PRODUCTION',
    fallback: 'https://amazinginventory.onrender.com/api/v1',
  );
  
  /// API base URL for development (Laravel Herd)
  /// Loaded from .env file (API_BASE_URL_DEVELOPMENT)
  /// For local development, use: http://amazinginventory.test/api/v1
  /// For Android emulator: http://10.0.2.2:8000/api/v1
  /// For iOS simulator: http://localhost:8000/api/v1
  static String get apiBaseUrlDevelopment => dotenv.get(
    'API_BASE_URL_DEVELOPMENT',
    fallback: 'http://amazinginventory.test/api/v1',
  );
  
  /// Current API base URL (switch between development and production)
  /// Determined by APP_ENV in .env file
  /// Set APP_ENV=production for production builds
  /// Set APP_ENV=development for local development
  static String get apiBaseUrl {
    final env = dotenv.get('APP_ENV', fallback: 'development');
    return env == 'production' ? apiBaseUrlProduction : apiBaseUrlDevelopment;
  }
}

