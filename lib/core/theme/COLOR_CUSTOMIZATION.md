# Color Customization Guide

This guide explains how to easily customize colors throughout the application.

## Overview

All colors in the application are centralized in the `AppColors` class located at:
```
lib/core/theme/app_colors.dart
```

This ensures that colors can be adjusted from a single location, making it easy to:
- Change the entire app's color scheme
- Maintain consistency across all screens
- Update colors without searching through multiple files

## Quick Start

To change any color in the app, simply edit the corresponding constant in `AppColors`:

```dart
// Before
static const Color metricPurple = Color(0xFF9C27B0);

// After - Change to your desired color
static const Color metricPurple = Color(0xFF6A1B9A);
```

## Color Categories

### Background Colors
- `scaffoldBackground` - Main app background
- `cardBackground` - Card and container backgrounds
- `topSectionBackground` - Top section background

### Primary Colors
- `primaryBlue` - Main primary color
- `primaryBlueLight` - Lighter blue variant
- `primaryBlueLighter` - Lightest blue variant
- `primaryBlueBorder` - Blue border color

### Metric Card Colors
- `metricPurple` - Total Stock Value card icon
- `metricGreen` - Total Stock card icon
- `metricRed` - Out of Stock card icon
- `metricYellow` - Low Stock card icon

### Chart Colors
- `chartPurple` - First chart segment
- `chartBlue` - Second chart segment
- `chartGreen` - Third chart segment
- `chartYellow` - Fourth chart segment
- `chartOrange` - Fifth chart segment

### Text Colors
- `textPrimary` - Main text color
- `textSecondary` - Secondary text color
- `textTertiary` - Tertiary text color
- `textDisabled` - Disabled text color

### Status Colors
- `success` - Success/positive actions
- `successLight` - Light success background
- `successText` - Success text color
- `error` - Error/danger actions
- `errorLight` - Light error background
- `warning` - Warning actions
- `warningLight` - Light warning background

### Navigation Colors
- `navSelected` - Selected navigation item
- `navUnselected` - Unselected navigation items

## Examples

### Example 1: Change Primary Blue Color

```dart
// In app_colors.dart
static const Color primaryBlue = Color(0xFF1976D2); // Original
static const Color primaryBlue = Color(0xFF1565C0); // Darker blue
```

This will automatically update:
- Profile icon color
- Navigation selected color
- Primary theme color

### Example 2: Change Metric Card Colors

```dart
// In app_colors.dart
static const Color metricPurple = Color(0xFF9C27B0); // Original purple
static const Color metricPurple = Color(0xFF7B1FA2); // Darker purple

static const Color metricGreen = Color(0xFF81C784); // Original green
static const Color metricGreen = Color(0xFF66BB6A); // Brighter green
```

### Example 3: Change Chart Colors

```dart
// In app_colors.dart
static const Color chartPurple = Color(0xFF9C27B0);
static const Color chartBlue = Color(0xFF64B5F6);
static const Color chartGreen = Color(0xFF81C784);
static const Color chartYellow = Color(0xFFFFD54F);
static const Color chartOrange = Color(0xFFFFB74D);

// Change to a different color scheme
static const Color chartPurple = Color(0xFF6A1B9A);
static const Color chartBlue = Color(0xFF42A5F5);
static const Color chartGreen = Color(0xFF66BB6A);
static const Color chartYellow = Color(0xFFFFCA28);
static const Color chartOrange = Color(0xFFFF9800);
```

### Example 4: Change Background Colors

```dart
// In app_colors.dart
static const Color scaffoldBackground = Color(0xFFF5F5F5); // Light gray
static const Color scaffoldBackground = Color(0xFFFAFAFA); // Lighter gray
static const Color scaffoldBackground = Color(0xFFEEEEEE); // Slightly darker
```

## Helper Methods

The `AppColors` class includes helper methods for dynamic color selection:

```dart
// Get metric color by index
Color color = AppColors.getMetricColor(0); // Returns metricPurple

// Get chart color by index
Color color = AppColors.getChartColor(2); // Returns chartGreen
```

## Best Practices

1. **Always use AppColors**: Never hardcode colors in widgets
2. **Use semantic names**: Choose color names that describe their purpose
3. **Maintain contrast**: Ensure text remains readable on backgrounds
4. **Test changes**: Verify color changes across all screens
5. **Document custom colors**: Add comments for non-standard colors

## Color Format

Colors are defined using hex values:
```dart
static const Color exampleColor = Color(0xFFRRGGBB);
```

Where:
- `0xFF` - Alpha channel (fully opaque)
- `RR` - Red component (00-FF)
- `GG` - Green component (00-FF)
- `BB` - Blue component (00-FF)

## Theme Integration

Colors are integrated with Flutter's theme system through `AppTheme`:
```dart
// In app_theme.dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryBlue,
    // ...
  ),
)
```

## Migration from Hardcoded Colors

If you find hardcoded colors in the codebase, replace them:

```dart
// ❌ Bad - Hardcoded color
Container(color: Color(0xFF9C27B0))

// ✅ Good - Using AppColors
Container(color: AppColors.metricPurple)
```

## Need Help?

If you need to add new colors:
1. Add the color constant to `AppColors`
2. Use it in your widgets
3. Document its purpose in this file

For questions or suggestions, refer to the main README.md file.

