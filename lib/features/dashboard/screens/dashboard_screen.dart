import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../widgets/metric_card.dart';
import '../widgets/stock_flow_chart.dart';
import '../../../shared/utils/greeting_util.dart';
import '../../../shared/utils/responsive_util.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/navigation_service.dart';

/// Main dashboard screen displaying inventory overview
/// Implements clean architecture with separation of concerns
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Status Bar Spacer
            Container(
              height: MediaQuery.of(context).padding.top,
              color: Colors.transparent,
            ),
            // Top Section with Profile and Notifications
            _buildTopSection(),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtil.getHorizontalPadding(context),
                  vertical: ResponsiveUtil.getVerticalPadding(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Metric Cards Grid
                    _buildMetricCards(),
                    SizedBox(height: ResponsiveUtil.getLargeSpacing(context)),
                    
                    // Stock Flow Chart
                    const StockFlowChart(),
                    SizedBox(height: ResponsiveUtil.getLargeSpacing(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom navigation is handled by main app
    );
  }

  Widget _buildTopSection() {
    final profileSize = ResponsiveUtil.getContainerSize(context, baseSize: 56);
    final iconSize = ResponsiveUtil.getIconSize(context, baseSize: 32);
    final greetingFontSize = ResponsiveUtil.getFontSize(context, baseSize: 11);
    final nameFontSize = ResponsiveUtil.getFontSize(context, baseSize: 20);
    final buttonIconSize = ResponsiveUtil.getIconSize(context, baseSize: 22);
    
    return Container(
      padding: ResponsiveUtil.getTopBarPadding(context),
      color: Colors.white,
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: profileSize,
            height: profileSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.profileBackground,
              border: Border.all(color: AppColors.profileBorder, width: 2.5),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Person icon
                Positioned(
                  bottom: 8,
                  child: Icon(
                    FeatherIcons.user,
                    color: AppColors.profileIcon,
                    size: iconSize,
                  ),
                ),
                // Cap representation
                Positioned(
                  top: 4,
                  child: Container(
                    width: ResponsiveUtil.getContainerSize(context, baseSize: 40),
                    height: ResponsiveUtil.getContainerSize(context, baseSize: 20),
                    decoration: BoxDecoration(
                      color: AppColors.profileIcon,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: ResponsiveUtil.getSpacing(context)),
          
          // Greeting and Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  GreetingUtil.getGreeting(),
                  style: TextStyle(
                    fontSize: greetingFontSize,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: ResponsiveUtil.isSmallScreen(context) ? 2 : 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        AppConstants.defaultUserName,
                        style: TextStyle(
                          fontSize: nameFontSize,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: ResponsiveUtil.isSmallScreen(context) ? 4 : 6),
                    Text(
                      '👋',
                      style: TextStyle(fontSize: nameFontSize),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Chat Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.all(ResponsiveUtil.isSmallScreen(context) ? 8 : 10),
                decoration: BoxDecoration(
                  color: AppColors.buttonBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  FeatherIcons.messageCircle,
                  color: AppColors.buttonIcon,
                  size: buttonIconSize,
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveUtil.getSpacing(context)),
          
          // Notifications with Badge
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                NavigationService.instance.navigateToNotifications();
              },
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtil.isSmallScreen(context) ? 8 : 10),
                    decoration: BoxDecoration(
                      color: AppColors.buttonBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      FeatherIcons.bell,
                      color: AppColors.buttonIcon,
                      size: buttonIconSize,
                    ),
                  ),
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppColors.notificationBadge,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        '${AppConstants.notificationCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCards() {
    final spacing = ResponsiveUtil.getSpacing(context);
    
    return Column(
      children: [
        // First Row
        Row(
          children: [
            Expanded(
              child: MetricCard(
                value: '\$45,210',
                label: 'Total Stock Value',
                iconColor: AppColors.metricPurple,
                icon: FeatherIcons.shoppingCart,
                isCircularIcon: true,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: MetricCard(
                value: '1,284',
                label: 'Total Stock',
                iconColor: AppColors.metricGreen,
                icon: FeatherIcons.package,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        // Second Row
        Row(
          children: [
            Expanded(
              child: MetricCard(
                value: '08',
                label: 'Out of Stock',
                iconColor: AppColors.metricRed,
                icon: FeatherIcons.package,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: MetricCard(
                value: '23',
                label: 'Low Stock',
                iconColor: AppColors.metricYellow,
                icon: FeatherIcons.zap,
                isCircularIcon: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

