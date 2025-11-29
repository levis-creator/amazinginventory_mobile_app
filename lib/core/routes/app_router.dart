import 'package:flutter/material.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/inventory/screens/inventory_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/modules/screens/modules_list_screen.dart';
import '../constants/app_constants.dart';

/// App router for managing navigation between screens.
/// 
/// Follows clean architecture principles with centralized routing.
/// This class provides a single source of truth for screen navigation
/// based on tab indices.
/// 
/// Usage:
/// ```dart
/// Widget screen = AppRouter.getScreenByIndex(AppConstants.homeIndex);
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
}

