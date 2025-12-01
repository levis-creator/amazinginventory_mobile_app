import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../models/module_item.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/utils/responsive_util.dart';

/// Module list item widget displaying a single module in the modules list.
/// 
/// This widget displays a module card with:
/// - Colored icon container with module icon
/// - Module title and subtitle
/// - Optional count badge
/// - Chevron right arrow indicating navigation
/// 
/// The widget uses Material InkWell for tap feedback and follows
/// the consistent design pattern used across all module screens.
/// 
/// Example:
/// ```dart
/// ModuleListItem(
///   module: salesModule,
///   onTap: () => Navigator.push(...),
/// )
/// ```
class ModuleListItem extends StatelessWidget {
  /// The module item to display
  final ModuleItem module;
  
  /// Callback when the module card is tapped
  final VoidCallback onTap;

  /// Creates a new [ModuleListItem] widget.
  /// 
  /// Both [module] and [onTap] are required.
  const ModuleListItem({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveUtil.getCardPadding(context);
    final iconSize = ResponsiveUtil.getContainerSize(context, baseSize: 48);
    final iconIconSize = ResponsiveUtil.getIconSize(context, baseSize: 24);
    final titleFontSize = ResponsiveUtil.getFontSize(context, baseSize: 16);
    final subtitleFontSize = ResponsiveUtil.getFontSize(context, baseSize: 13);
    final countFontSize = ResponsiveUtil.getFontSize(context, baseSize: 12);
    final arrowIconSize = ResponsiveUtil.getIconSize(context, baseSize: 20);
    final spacing = ResponsiveUtil.getSpacing(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: module.color.withValues(alpha: 0.1),
        highlightColor: module.color.withValues(alpha: 0.05),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: cardPadding,
            vertical: cardPadding,
          ),
          margin: EdgeInsets.only(bottom: spacing - 4),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.borderLight,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: module.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  module.icon,
                  color: module.color,
                  size: iconIconSize,
                ),
              ),
              SizedBox(width: spacing),
              
              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            module.title,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (module.count != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtil.isSmallScreen(context) ? 6 : 8,
                              vertical: ResponsiveUtil.isSmallScreen(context) ? 2 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: module.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${module.count}',
                              style: TextStyle(
                                fontSize: countFontSize,
                                fontWeight: FontWeight.w600,
                                color: module.color,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: ResponsiveUtil.isSmallScreen(context) ? 2 : 4),
                    Text(
                      module.subtitle,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: spacing - 4),
              
              // Arrow Icon
              Icon(
                FeatherIcons.chevronRight,
                color: AppColors.textSecondary,
                size: arrowIconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

