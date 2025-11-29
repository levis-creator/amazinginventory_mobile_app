import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application theme configuration.
/// 
/// Centralized theme management following DRY (Don't Repeat Yourself) principle.
/// Uses [AppColors] for consistent color theming across the entire application.
/// 
/// This class provides both light and dark theme configurations, though
/// currently only the light theme is actively used in the app.
class AppTheme {
  /// Returns the light theme configuration.
  /// 
  /// Features:
  /// - Material 3 design system
  /// - Color scheme based on [AppColors.primaryBlue]
  /// - Consistent text theme using [AppColors] text colors
  /// - Scaffold and card background colors from [AppColors]
  /// 
  /// Returns a [ThemeData] instance configured for light mode.
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        brightness: Brightness.light,
        primary: AppColors.primaryBlue,
        secondary: AppColors.metricGreen,
        error: AppColors.error,
        surface: AppColors.cardBackground,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      cardColor: AppColors.cardBackground,
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textPrimary),
        displayMedium: TextStyle(color: AppColors.textPrimary),
        displaySmall: TextStyle(color: AppColors.textPrimary),
        headlineLarge: TextStyle(color: AppColors.textPrimary),
        headlineMedium: TextStyle(color: AppColors.textPrimary),
        headlineSmall: TextStyle(color: AppColors.textPrimary),
        titleLarge: TextStyle(color: AppColors.textPrimary),
        titleMedium: TextStyle(color: AppColors.textPrimary),
        titleSmall: TextStyle(color: AppColors.textPrimary),
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
        bodySmall: TextStyle(color: AppColors.textSecondary),
        labelLarge: TextStyle(color: AppColors.textSecondary),
        labelMedium: TextStyle(color: AppColors.textTertiary),
        labelSmall: TextStyle(color: AppColors.textTertiary),
      ),
    );
  }

  /// Returns the dark theme configuration.
  /// 
  /// Currently defined but not actively used in the app.
  /// Ready for future dark mode implementation.
  /// 
  /// Returns a [ThemeData] instance configured for dark mode.
  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        brightness: Brightness.dark,
        primary: AppColors.primaryBlue,
        secondary: AppColors.metricGreen,
        error: AppColors.error,
        surface: const Color(0xFF1E1E1E),
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
    );
  }
}

