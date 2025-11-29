import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:amazinginventory/core/theme/app_colors.dart';

/// Reusable search bar widget for filtering lists.
/// 
/// This widget provides a consistent search bar design across all module screens.
/// It can be used with either a controller or an onChanged callback.
/// 
/// Features:
/// - Consistent styling with app theme
/// - Search icon prefix
/// - Customizable hint text
/// - Controller or callback support
/// 
/// Example usage:
/// ```dart
/// // With controller
/// final controller = TextEditingController();
/// AppSearchBar(
///   controller: controller,
///   hintText: 'Search products...',
/// )
/// 
/// // With callback
/// AppSearchBar(
///   onChanged: (query) {
///     // Filter list based on query
///   },
///   hintText: 'Search...',
/// )
/// ```
class AppSearchBar extends StatelessWidget {
  /// Hint text displayed when the search field is empty
  final String hintText;
  
  /// Callback called when the search text changes
  final ValueChanged<String>? onChanged;
  
  /// Controller for managing the search text field
  final TextEditingController? controller;

  /// Creates a new [AppSearchBar] widget.
  /// 
  /// Either [controller] or [onChanged] should be provided, but not both.
  /// If both are provided, [controller] takes precedence.
  /// 
  /// [hintText] Defaults to 'Search...' if not provided.
  const AppSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gray300,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            FeatherIcons.search,
            color: AppColors.textTertiary,
            size: 22,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

