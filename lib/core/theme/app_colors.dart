import 'package:flutter/material.dart';

/// Centralized color system for the application
/// All colors can be easily adjusted from this single location
/// Follows DRY principle - single source of truth for colors
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ==================== Background Colors ====================
  static const Color scaffoldBackground = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color topSectionBackground = Colors.white;

  // ==================== Primary Colors ====================
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color primaryBlueLight = Color(0xFF64B5F6);
  static const Color primaryBlueLighter = Color(0xFFE3F2FD);
  static const Color primaryBlueBorder = Color(0xFF90CAF9);

  // ==================== Metric Card Icon Colors ====================
  static const Color metricPurple = Color(0xFF9C27B0);
  static const Color metricGreen = Color(0xFF81C784);
  static const Color metricRed = Color(0xFFE53935);
  static const Color metricYellow = Color(0xFFFFB300);
  static const Color metricAmber = Color(0xFFFFB300);

  // ==================== Chart Colors ====================
  static const Color chartPurple = Color(0xFF9C27B0);
  static const Color chartBlue = Color(0xFF64B5F6);
  static const Color chartGreen = Color(0xFF81C784);
  static const Color chartYellow = Color(0xFFFFD54F);
  static const Color chartOrange = Color(0xFFFFB74D);

  // ==================== Text Colors ====================
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF616161);
  static const Color textDisabled = Color(0xFF9E9E9E);

  // ==================== Success/Positive Colors ====================
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color successText = Color(0xFF4CAF50);

  // ==================== Error/Danger Colors ====================
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);

  // ==================== Warning Colors ====================
  static const Color warning = Color(0xFFFFB300);
  static const Color warningLight = Color(0xFFFFF8E1);

  // ==================== Neutral/Gray Colors ====================
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);
  static const Color borderLight = Color(0xFFE5E5E5);

  // ==================== Navigation Colors ====================
  static const Color navSelected = Color(0xFF1976D2);
  static const Color navUnselected = Color(0xFF9E9E9E);

  // ==================== Notification Badge ====================
  static const Color notificationBadge = Color(0xFFE53935);

  // ==================== Button/Interactive Colors ====================
  static const Color buttonBackground = Color(0xFFF5F5F5);
  static const Color buttonIcon = Color(0xFF616161);

  // ==================== Shadow Colors ====================
  static Color shadowLight = Colors.black.withOpacity(0.04);
  static Color shadowMedium = Colors.black.withOpacity(0.08);
  static Color shadowDark = Colors.black.withOpacity(0.12);

  // ==================== Profile Colors ====================
  static const Color profileBackground = Color(0xFFE3F2FD);
  static const Color profileBorder = Color(0xFF90CAF9);
  static const Color profileIcon = Color(0xFF1976D2);

  // ==================== Helper Methods ====================
  /// Get metric card color by index
  static Color getMetricColor(int index) {
    switch (index) {
      case 0:
        return metricPurple;
      case 1:
        return metricGreen;
      case 2:
        return metricRed;
      case 3:
        return metricYellow;
      default:
        return primaryBlue;
    }
  }

  /// Get chart segment color by index
  static Color getChartColor(int index) {
    switch (index) {
      case 0:
        return chartPurple;
      case 1:
        return chartBlue;
      case 2:
        return chartGreen;
      case 3:
        return chartYellow;
      case 4:
        return chartOrange;
      default:
        return primaryBlue;
    }
  }
}

