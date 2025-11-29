import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/theme/app_colors.dart';

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
    return Container(
      padding: const EdgeInsets.all(18),
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
              _buildIconContainer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                        fontSize: 11,
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      FeatherIcons.chevronDown,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  FeatherIcons.arrowUp,
                  size: 16,
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
  Widget _buildIconContainer() {
    // Special handling for "Out of Stock" icon with X overlay
    if (label == 'Out of Stock') {
      return Container(
        width: 52,
        height: 52,
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
              size: 26,
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FeatherIcons.x,
                  size: 10,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: iconColor,
        shape: isCircularIcon ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircularIcon ? null : BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 26,
      ),
    );
  }
}

