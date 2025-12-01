import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/responsive_util.dart';

/// A reusable metric card widget displaying key inventory metrics.
/// 
/// This widget follows SOLID principles with single responsibility and
/// uses [AppColors] for consistent theming across the app.
/// 
/// The card displays:
/// - Icon with colored background (circular or rounded square)
/// - Period selector (e.g., "Weekly")
/// - Large metric value
/// - Label text
/// - Success indicator arrow
/// 
/// Special handling: If label is "Out of Stock", the icon displays
/// with an X overlay indicator.
/// 
/// Example:
/// ```dart
/// MetricCard(
///   value: '1,234',
///   label: 'Total Stock Value',
///   iconColor: AppColors.metricPurple,
///   icon: FeatherIcons.package,
///   period: 'Weekly',
/// )
/// ```
class MetricCard extends StatelessWidget {
  /// The metric value to display (e.g., "1,234" or "$5,678")
  final String value;
  
  /// The label describing the metric (e.g., "Total Stock Value")
  final String label;
  
  /// Color for the icon background
  final Color iconColor;
  
  /// Icon to display in the card
  final IconData icon;
  
  /// Period text displayed in the top-right (defaults to "Weekly")
  final String period;
  
  /// Whether the icon container should be circular (defaults to false)
  final bool isCircularIcon;

  /// Creates a new [MetricCard] widget.
  /// 
  /// [value], [label], [iconColor], and [icon] are required.
  /// [period] defaults to "Weekly" and [isCircularIcon] defaults to false.
  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    required this.iconColor,
    required this.icon,
    this.period = 'Weekly',
    this.isCircularIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveUtil.getCardPadding(context);
    final iconSize = ResponsiveUtil.getContainerSize(context, baseSize: 52);
    final valueFontSize = ResponsiveUtil.getFontSize(context, baseSize: 26);
    final labelFontSize = ResponsiveUtil.getFontSize(context, baseSize: 13);
    final periodFontSize = ResponsiveUtil.getFontSize(context, baseSize: 11);
    final spacing = ResponsiveUtil.getSpacing(context);
    
    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconContainer(context, iconSize),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtil.isSmallScreen(context) ? 8 : 10,
                  vertical: ResponsiveUtil.isSmallScreen(context) ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      period,
                      style: TextStyle(
                        fontSize: periodFontSize,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: ResponsiveUtil.isSmallScreen(context) ? 2 : 4),
                    Icon(
                      FeatherIcons.chevronDown,
                      size: ResponsiveUtil.getIconSize(context, baseSize: 18),
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing + 2),
          Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: spacing - 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: labelFontSize,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.all(ResponsiveUtil.isSmallScreen(context) ? 4 : 5),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  FeatherIcons.arrowUp,
                  size: ResponsiveUtil.getIconSize(context, baseSize: 16),
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the icon container with special handling for "Out of Stock" status.
  /// 
  /// If the label is "Out of Stock", displays the icon with an X overlay.
  /// Otherwise, displays a standard icon container (circular or rounded square).
  Widget _buildIconContainer(BuildContext context, double iconSize) {
    final iconIconSize = ResponsiveUtil.getIconSize(context, baseSize: 26);
    
    // Special handling for "Out of Stock" icon with X overlay
    if (label == 'Out of Stock') {
      return Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          color: iconColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: iconIconSize,
            ),
            Positioned(
              top: ResponsiveUtil.isSmallScreen(context) ? 6 : 8,
              right: ResponsiveUtil.isSmallScreen(context) ? 6 : 8,
              child: Container(
                width: ResponsiveUtil.getContainerSize(context, baseSize: 16),
                height: ResponsiveUtil.getContainerSize(context, baseSize: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FeatherIcons.x,
                  size: ResponsiveUtil.getIconSize(context, baseSize: 10),
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: iconColor,
        shape: isCircularIcon ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircularIcon ? null : BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: iconIconSize,
      ),
    );
  }
}

