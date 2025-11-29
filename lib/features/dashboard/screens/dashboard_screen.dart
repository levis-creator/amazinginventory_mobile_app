import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../widgets/metric_card.dart';
import '../widgets/stock_flow_chart.dart';
import '../../../shared/utils/greeting_util.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Metric Cards Grid
                    _buildMetricCards(),
                    const SizedBox(height: 24),
                    
                    // Stock Flow Chart
                    const StockFlowChart(),
                    const SizedBox(height: 20),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      color: Colors.white,
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 56,
            height: 56,
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
                    size: 32,
                  ),
                ),
                // Cap representation
                Positioned(
                  top: 4,
                  child: Container(
                    width: 40,
                    height: 20,
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
          const SizedBox(width: 14),
          
          // Greeting and Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  GreetingUtil.getGreeting(),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      AppConstants.defaultUserName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '👋',
                      style: TextStyle(fontSize: 20),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.buttonBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  FeatherIcons.messageCircle,
                  color: AppColors.buttonIcon,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.buttonBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      FeatherIcons.bell,
                      color: AppColors.buttonIcon,
                      size: 22,
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
            const SizedBox(width: 14),
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
        const SizedBox(height: 14),
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
            const SizedBox(width: 14),
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

