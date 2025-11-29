import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../models/module_item.dart';
import '../../../core/theme/app_colors.dart';

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: module.color.withValues(alpha: 0.1),
        highlightColor: module.color.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          margin: const EdgeInsets.only(bottom: 12),
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: module.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  module.icon,
                  color: module.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
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
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (module.count != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: module.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${module.count}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: module.color,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Arrow Icon
              Icon(
                FeatherIcons.chevronRight,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

