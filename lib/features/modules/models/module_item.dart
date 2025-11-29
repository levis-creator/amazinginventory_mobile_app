import 'package:flutter/material.dart';

/// Module item model representing a navigation module in the modules list.
/// 
/// This immutable data class follows clean architecture principles and
/// represents a single module that can be displayed in the modules list screen.
/// Each module has visual properties (icon, colors) and metadata (route, API endpoint).
/// 
/// Example:
/// ```dart
/// const salesModule = ModuleItem(
///   id: 'sales',
///   title: 'Sales',
///   subtitle: 'View and manage all sales transactions',
///   icon: FeatherIcons.shoppingCart,
///   color: Color(0xFF2196F3),
///   backgroundColor: Color(0xFFE3F2FD),
///   route: '/sales',
///   apiEndpoint: 'sales',
///   count: 42,
/// );
/// ```
class ModuleItem {
  /// Unique identifier for the module
  final String id;
  
  /// Display title of the module
  final String title;
  
  /// Subtitle/description of the module
  final String subtitle;
  
  /// Icon to display for the module
  final IconData icon;
  
  /// Primary color for the module (icon color)
  final Color color;
  
  /// Background color for the icon container
  final Color backgroundColor;
  
  /// Navigation route for the module (for future use)
  final String route;
  
  /// API endpoint string for fetching module data
  final String apiEndpoint;
  
  /// Optional count badge to display on the module card
  final int? count;

  /// Creates a new [ModuleItem] instance.
  /// 
  /// All parameters except [count] are required.
  const ModuleItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.route,
    required this.apiEndpoint,
    this.count,
  });
}

