import 'package:flutter/material.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/inventory/screens/inventory_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/modules/screens/modules_list_screen.dart';
import '../../features/sales/screens/sales_list_screen.dart';
import '../../features/purchases/screens/purchases_list_screen.dart';
import '../../features/capital/screens/capital_list_screen.dart';
import '../../features/expenses/screens/expenses_list_screen.dart';
import '../../features/expense_categories/screens/expense_categories_list_screen.dart';
import '../../features/categories/screens/categories_list_screen.dart';
import '../../features/suppliers/screens/suppliers_list_screen.dart';
import '../../features/stock_movements/screens/stock_movements_list_screen.dart';
import '../constants/app_constants.dart';

/// App router for managing navigation between screens.
///
/// Follows clean architecture principles with centralized routing.
/// This class provides a single source of truth for screen navigation
/// based on tab indices and module identifiers.
///
/// Usage:
/// ```dart
/// Widget screen = AppRouter.getScreenByIndex(AppConstants.homeIndex);
/// Widget moduleScreen = AppRouter.getModuleScreen(AppConstants.moduleSales);
/// ```
class AppRouter {
  /// Returns the appropriate screen widget based on the tab index.
  ///
  /// Maps navigation indices to their corresponding screens:
  /// - [AppConstants.homeIndex] (0) -> [DashboardScreen]
  /// - [AppConstants.inventoryIndex] (1) -> [InventoryScreen]
  /// - [AppConstants.notificationsIndex] (2) -> [NotificationsScreen]
  /// - [AppConstants.moreIndex] (3) -> [ModulesListScreen]
  ///
  /// Returns [DashboardScreen] as default if index is invalid.
  ///
  /// [index] The navigation tab index
  /// Returns the corresponding screen widget
  static Widget getScreenByIndex(int index) {
    switch (index) {
      case AppConstants.homeIndex:
        return const DashboardScreen();
      case AppConstants.inventoryIndex:
        return const InventoryScreen();
      case AppConstants.notificationsIndex:
        return const NotificationsScreen();
      case AppConstants.moreIndex:
        return const ModulesListScreen();
      default:
        return const DashboardScreen();
    }
  }

  /// Returns the appropriate module screen widget based on module identifier.
  ///
  /// Maps module identifiers to their corresponding screens:
  /// - [AppConstants.moduleSales] -> [SalesListScreen]
  /// - [AppConstants.modulePurchases] -> [PurchasesListScreen]
  /// - [AppConstants.moduleCapital] -> [CapitalListScreen]
  /// - [AppConstants.moduleExpenses] -> [ExpensesListScreen]
  /// - [AppConstants.moduleExpenseCategories] -> [ExpenseCategoriesListScreen]
  /// - [AppConstants.moduleCategories] -> [CategoriesListScreen]
  /// - [AppConstants.moduleSuppliers] -> [SuppliersListScreen]
  /// - [AppConstants.moduleStockMovements] -> [StockMovementsListScreen]
  /// - [AppConstants.moduleProducts] -> [InventoryScreen]
  ///
  /// Returns null if module identifier is invalid.
  ///
  /// [moduleId] The module identifier
  /// Returns the corresponding module screen widget or null
  static Widget? getModuleScreen(String? moduleId) {
    if (moduleId == null) return null;

    switch (moduleId) {
      case AppConstants.moduleSales:
        return const SalesListScreen();
      case AppConstants.modulePurchases:
        return const PurchasesListScreen();
      case AppConstants.moduleCapital:
        return const CapitalListScreen();
      case AppConstants.moduleExpenses:
        return const ExpensesListScreen();
      case AppConstants.moduleExpenseCategories:
        return const ExpenseCategoriesListScreen();
      case AppConstants.moduleCategories:
        return const CategoriesListScreen();
      case AppConstants.moduleSuppliers:
        return const SuppliersListScreen();
      case AppConstants.moduleStockMovements:
        return const StockMovementsListScreen();
      case AppConstants.moduleProducts:
        return const InventoryScreen();
      default:
        return null;
    }
  }
}
