import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feather_icons/feather_icons.dart';
import '../widgets/metric_card.dart';
import '../widgets/revenue_expenses_chart.dart';
import '../../../shared/utils/greeting_util.dart';
import '../../../shared/utils/responsive_util.dart';
import '../../../shared/utils/user_util.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/di/service_locator.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../models/dashboard_stats_model.dart';

/// Main dashboard screen displaying inventory overview
/// Implements clean architecture with separation of concerns
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> 
    with AutomaticKeepAliveClientMixin {
  bool _hasLoadedData = false;
  late final DashboardCubit _cubit;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Get cubit from service locator (singleton, preserves state)
    _cubit = getIt<DashboardCubit>();
    // Load data only once when screen is first initialized
    // Check if data is already loaded before loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasLoadedData) {
        _hasLoadedData = true;
        // Only load if state is initial (not already loaded)
        final currentState = _cubit.state;
        if (currentState is DashboardInitial) {
          _cubit.loadAll();
        } else {
          print('✅ DashboardScreen: Data already loaded, skipping initial load');
        }
      }
    });
  }

  @override
  void dispose() {
    // Don't close the cubit here - let the BlocProvider handle it
    // The cubit is managed by the service locator
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return BlocProvider<DashboardCubit>.value(
      value: _cubit,
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
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
                  
                  // Main Content with Pull-to-Refresh
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<DashboardCubit>().refresh();
                        // Wait a bit for the refresh to complete
                        await Future.delayed(const Duration(milliseconds: 500));
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtil.getHorizontalPadding(context),
                          vertical: ResponsiveUtil.getVerticalPadding(context),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state is DashboardLoaded)
                              _buildLoadedContent(context, state)
                            else if (state is DashboardError)
                              _buildErrorState(context, state.message, isStats: state.isStatsError)
                            else
                              _buildLoadingState(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom navigation is handled by main app
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        _buildMetricCardsSkeleton(),
        SizedBox(height: ResponsiveUtil.getLargeSpacing(context)),
        _buildChartSkeleton(),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String message, {required bool isStats}) {
    final spacing = ResponsiveUtil.getSpacing(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FeatherIcons.alertCircle,
              size: 64,
              color: AppColors.error,
            ),
            SizedBox(height: spacing),
            Text(
              'Error loading dashboard',
              style: TextStyle(
                fontSize: ResponsiveUtil.getFontSize(context, baseSize: 18),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: spacing / 2),
            Text(
              message,
              style: TextStyle(
                fontSize: ResponsiveUtil.getFontSize(context, baseSize: 14),
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing * 2),
            ElevatedButton.icon(
              onPressed: () {
                if (isStats) {
                  context.read<DashboardCubit>().loadStats();
                } else {
                  context.read<DashboardCubit>().loadChart();
                }
              },
              icon: const Icon(FeatherIcons.refreshCw),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.metricPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: spacing * 2,
                  vertical: spacing,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedContent(BuildContext context, DashboardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Metric Cards Grid
        _buildMetricCards(state.stats),
        SizedBox(height: ResponsiveUtil.getLargeSpacing(context)),
        
        // Revenue vs Expenses Chart
        if (state.chartData != null)
          RevenueExpensesChart(chartData: state.chartData!)
        else
          _buildChartPlaceholderWithRetry(context),
        SizedBox(height: ResponsiveUtil.getLargeSpacing(context)),
      ],
    );
  }

  Widget _buildMetricCardsSkeleton() {
    final spacing = ResponsiveUtil.getSpacing(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildSkeletonCard()),
            SizedBox(width: spacing),
            Expanded(child: _buildSkeletonCard()),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          children: [
            Expanded(child: _buildSkeletonCard()),
            SizedBox(width: spacing),
            Expanded(child: _buildSkeletonCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtil.getCardPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 100,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 80,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSkeleton() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtil.getCardPadding(context) + 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      height: ResponsiveUtil.getChartHeight(context) + 100,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.metricPurple,
        ),
      ),
    );
  }

  Widget _buildChartPlaceholderWithRetry(BuildContext context) {
    // Automatically retry loading chart data if it's null
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final currentState = context.read<DashboardCubit>().state;
        if (currentState is DashboardLoaded && currentState.chartData == null) {
          print('🔄 DashboardScreen: Chart data is null, retrying...');
          context.read<DashboardCubit>().loadChart();
        }
      }
    });
    
    final spacing = ResponsiveUtil.getSpacing(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveUtil.getCardPadding(context) + 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      height: ResponsiveUtil.getChartHeight(context) + 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.metricPurple,
          ),
          SizedBox(height: spacing),
          Text(
            'Loading chart data...',
            style: TextStyle(
              fontSize: ResponsiveUtil.getFontSize(context, baseSize: 14),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        // Get user information from auth state
        final userName = authState is AuthAuthenticated 
            ? authState.user.name 
            : AppConstants.defaultUserName;
        final userInitials = authState is AuthAuthenticated 
            ? UserUtil.getInitials(authState.user.name)
            : UserUtil.getInitials(AppConstants.defaultUserName);
        
        final profileSize = ResponsiveUtil.getContainerSize(context, baseSize: 56);
        final greetingFontSize = ResponsiveUtil.getFontSize(context, baseSize: 11);
        final nameFontSize = ResponsiveUtil.getFontSize(context, baseSize: 20);
        final buttonIconSize = ResponsiveUtil.getIconSize(context, baseSize: 22);
        final initialsFontSize = ResponsiveUtil.getFontSize(context, baseSize: 18);
        
        return Container(
          padding: ResponsiveUtil.getTopBarPadding(context),
          color: Colors.white,
          child: Row(
            children: [
              // Profile Picture with User Initials
              Container(
                width: profileSize,
                height: profileSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.profileBackground,
                  border: Border.all(color: AppColors.profileBorder, width: 2.5),
                ),
                child: Center(
                  child: Text(
                    userInitials,
                    style: TextStyle(
                      fontSize: initialsFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.profileIcon,
                      letterSpacing: 0.5,
                    ),
                  ),
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
                            userName,
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
      },
    );
  }

  Widget _buildMetricCards(DashboardStats stats) {
    final spacing = ResponsiveUtil.getSpacing(context);
    
    return Column(
      children: [
        // First Row
        Row(
          children: [
            Expanded(
              child: MetricCard(
                value: stats.formattedTotalStockValue,
                label: 'Total Stock Value',
                iconColor: AppColors.metricPurple,
                icon: FeatherIcons.shoppingCart,
                isCircularIcon: true,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: MetricCard(
                value: stats.formattedTotalStock,
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
                value: stats.outOfStock.toString().padLeft(2, '0'),
                label: 'Out of Stock',
                iconColor: AppColors.metricRed,
                icon: FeatherIcons.package,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: MetricCard(
                value: stats.lowStock.toString().padLeft(2, '0'),
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

