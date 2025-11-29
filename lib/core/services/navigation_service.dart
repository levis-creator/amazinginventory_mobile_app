import '../constants/app_constants.dart';

/// Navigation service for managing tab navigation.
/// 
/// Provides a decoupled way for features to request navigation without
/// directly depending on the main app state. This follows feature-based
/// architecture principles and the Dependency Inversion Principle (SOLID).
/// 
/// This is a singleton service that uses a callback pattern to communicate
/// with the main app widget for tab changes.
/// 
/// Usage:
/// ```dart
/// // Navigate to notifications from any feature
/// NavigationService.instance.navigateToNotifications();
/// 
/// // Navigate to a specific tab by index
/// NavigationService.instance.navigateToTab(AppConstants.homeIndex);
/// ```
class NavigationService {
  /// Singleton instance
  static NavigationService? _instance;
  
  /// Gets the singleton instance of NavigationService.
  /// 
  /// Creates a new instance if one doesn't exist.
  static NavigationService get instance {
    _instance ??= NavigationService._();
    return _instance!;
  }

  /// Private constructor to enforce singleton pattern
  NavigationService._();

  /// Callback function to change the current tab index.
  /// 
  /// This should be set by the main app widget in its initState:
  /// ```dart
  /// NavigationService.instance.onTabChanged = (index) {
  ///   setState(() {
  ///     _currentIndex = index;
  ///   });
  /// };
  /// ```
  void Function(int)? onTabChanged;

  /// Navigate to a specific tab by index.
  /// 
  /// [index] The tab index to navigate to (0-3)
  void navigateToTab(int index) {
    onTabChanged?.call(index);
  }

  /// Navigate to notifications tab.
  /// 
  /// Convenience method for navigating to the notifications screen.
  void navigateToNotifications() {
    navigateToTab(AppConstants.notificationsIndex);
  }

  /// Navigate to home/dashboard tab.
  /// 
  /// Convenience method for navigating to the dashboard screen.
  void navigateToHome() {
    navigateToTab(AppConstants.homeIndex);
  }

  /// Navigate to inventory/products tab.
  /// 
  /// Convenience method for navigating to the inventory screen.
  void navigateToInventory() {
    navigateToTab(AppConstants.inventoryIndex);
  }

  /// Navigate to more/modules tab.
  /// 
  /// Convenience method for navigating to the modules list screen.
  void navigateToMore() {
    navigateToTab(AppConstants.moreIndex);
  }
}

