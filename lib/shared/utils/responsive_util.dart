import 'package:flutter/material.dart';

/// Responsive utility class for handling screen size variations.
/// 
/// Provides helper methods to determine screen size categories and
/// calculate responsive values based on screen width.
/// 
/// This utility follows the KISS principle by providing simple,
/// easy-to-use methods for responsive design.
/// 
/// Example usage:
/// ```dart
/// final screenWidth = MediaQuery.of(context).size.width;
/// final padding = ResponsiveUtil.getPadding(context);
/// final fontSize = ResponsiveUtil.getFontSize(context, baseSize: 24);
/// ```
class ResponsiveUtil {
  /// Small screen breakpoint (phones in portrait)
  static const double smallScreenBreakpoint = 360.0;
  
  /// Medium screen breakpoint (phones in landscape, small tablets)
  static const double mediumScreenBreakpoint = 600.0;
  
  /// Large screen breakpoint (tablets, desktops)
  static const double largeScreenBreakpoint = 1024.0;

  /// Determines if the screen is small (width < 360px)
  /// 
  /// Returns true if the screen width is less than [smallScreenBreakpoint].
  static bool isSmallScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < smallScreenBreakpoint;
  }

  /// Determines if the screen is medium (360px <= width < 600px)
  /// 
  /// Returns true if the screen width is between [smallScreenBreakpoint] and [mediumScreenBreakpoint].
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= smallScreenBreakpoint && width < mediumScreenBreakpoint;
  }

  /// Determines if the screen is large (width >= 600px)
  /// 
  /// Returns true if the screen width is greater than or equal to [mediumScreenBreakpoint].
  static bool isLargeScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mediumScreenBreakpoint;
  }

  /// Gets responsive horizontal padding based on screen size.
  /// 
  /// - Small screens: 12px
  /// - Medium screens: 16px
  /// - Large screens: 20px
  /// 
  /// Returns the appropriate horizontal padding value.
  static double getHorizontalPadding(BuildContext context) {
    if (isSmallScreen(context)) return 12.0;
    if (isMediumScreen(context)) return 16.0;
    return 20.0;
  }

  /// Gets responsive vertical padding based on screen size.
  /// 
  /// - Small screens: 12px
  /// - Medium screens: 16px
  /// - Large screens: 20px
  /// 
  /// Returns the appropriate vertical padding value.
  static double getVerticalPadding(BuildContext context) {
    if (isSmallScreen(context)) return 12.0;
    if (isMediumScreen(context)) return 16.0;
    return 20.0;
  }

  /// Gets responsive padding for top bars.
  /// 
  /// - Small screens: 12px horizontal, 12px vertical
  /// - Medium screens: 16px horizontal, 14px vertical
  /// - Large screens: 20px horizontal, 16px vertical
  /// 
  /// Returns EdgeInsets with appropriate padding.
  static EdgeInsets getTopBarPadding(BuildContext context) {
    if (isSmallScreen(context)) {
      return const EdgeInsets.fromLTRB(12, 12, 12, 12);
    }
    if (isMediumScreen(context)) {
      return const EdgeInsets.fromLTRB(16, 14, 16, 14);
    }
    return const EdgeInsets.fromLTRB(20, 16, 20, 16);
  }

  /// Gets responsive font size based on screen size and base size.
  /// 
  /// Scales down font sizes on small screens by 15-20%.
  /// 
  /// [baseSize] The base font size to scale from
  /// 
  /// Returns the scaled font size.
  static double getFontSize(BuildContext context, {required double baseSize}) {
    if (isSmallScreen(context)) {
      return baseSize * 0.85; // 15% smaller on small screens
    }
    if (isMediumScreen(context)) {
      return baseSize * 0.92; // 8% smaller on medium screens
    }
    return baseSize;
  }

  /// Gets responsive icon size based on screen size and base size.
  /// 
  /// Scales down icon sizes on small screens.
  /// 
  /// [baseSize] The base icon size to scale from
  /// 
  /// Returns the scaled icon size.
  static double getIconSize(BuildContext context, {required double baseSize}) {
    if (isSmallScreen(context)) {
      return baseSize * 0.85;
    }
    if (isMediumScreen(context)) {
      return baseSize * 0.92;
    }
    return baseSize;
  }

  /// Gets responsive container size based on screen size and base size.
  /// 
  /// Scales down container sizes on small screens.
  /// 
  /// [baseSize] The base container size to scale from
  /// 
  /// Returns the scaled container size.
  static double getContainerSize(BuildContext context, {required double baseSize}) {
    if (isSmallScreen(context)) {
      return baseSize * 0.85;
    }
    if (isMediumScreen(context)) {
      return baseSize * 0.92;
    }
    return baseSize;
  }

  /// Gets responsive spacing between elements.
  /// 
  /// - Small screens: 8px
  /// - Medium screens: 12px
  /// - Large screens: 14px
  /// 
  /// Returns the appropriate spacing value.
  static double getSpacing(BuildContext context) {
    if (isSmallScreen(context)) return 8.0;
    if (isMediumScreen(context)) return 12.0;
    return 14.0;
  }

  /// Gets responsive spacing for large gaps.
  /// 
  /// - Small screens: 12px
  /// - Medium screens: 16px
  /// - Large screens: 20px
  /// 
  /// Returns the appropriate large spacing value.
  static double getLargeSpacing(BuildContext context) {
    if (isSmallScreen(context)) return 12.0;
    if (isMediumScreen(context)) return 16.0;
    return 20.0;
  }

  /// Gets responsive card padding.
  /// 
  /// - Small screens: 12px
  /// - Medium screens: 16px
  /// - Large screens: 18px
  /// 
  /// Returns the appropriate card padding value.
  static double getCardPadding(BuildContext context) {
    if (isSmallScreen(context)) return 12.0;
    if (isMediumScreen(context)) return 16.0;
    return 18.0;
  }

  /// Gets responsive search bar height.
  /// 
  /// - Small screens: 44px
  /// - Medium/Large screens: 48px
  /// 
  /// Returns the appropriate search bar height.
  static double getSearchBarHeight(BuildContext context) {
    if (isSmallScreen(context)) return 44.0;
    return 48.0;
  }

  /// Gets responsive chart height.
  /// 
  /// - Small screens: 180px
  /// - Medium screens: 200px
  /// - Large screens: 220px
  /// 
  /// Returns the appropriate chart height.
  static double getChartHeight(BuildContext context) {
    if (isSmallScreen(context)) return 180.0;
    if (isMediumScreen(context)) return 200.0;
    return 220.0;
  }
}

