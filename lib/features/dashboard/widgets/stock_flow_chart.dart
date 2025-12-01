import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/responsive_util.dart';

/// Stock flow chart widget displaying weekly inventory trends
/// Uses fl_chart for visualization
/// Uses AppColors for consistent theming
class StockFlowChart extends StatelessWidget {
  const StockFlowChart({super.key});

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveUtil.getCardPadding(context);
    final titleFontSize = ResponsiveUtil.getFontSize(context, baseSize: 22);
    final subtitleFontSize = ResponsiveUtil.getFontSize(context, baseSize: 14);
    final periodFontSize = ResponsiveUtil.getFontSize(context, baseSize: 12);
    final chartHeight = ResponsiveUtil.getChartHeight(context);
    final spacing = ResponsiveUtil.getSpacing(context);
    
    return Container(
      padding: EdgeInsets.all(cardPadding + 4),
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
              Flexible(
                child: Text(
                  'Stock Flow',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtil.isSmallScreen(context) ? 10 : 14,
                  vertical: ResponsiveUtil.isSmallScreen(context) ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Last 7 days',
                      style: TextStyle(
                        fontSize: periodFontSize,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
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
          SizedBox(height: spacing - 2),
          Text(
            '+18% Rise in Total Inventory Units',
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: AppColors.successText,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: spacing + 8),
          SizedBox(
            height: chartHeight,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[value.toInt()],
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  // Monday
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 45,
                        color: AppColors.chartPurple,
                        width: 20,
                      ),
                      BarChartRodData(
                        toY: 65,
                        color: AppColors.chartBlue,
                        width: 20,
                        fromY: 45,
                      ),
                      BarChartRodData(
                        toY: 85,
                        color: AppColors.chartGreen,
                        width: 20,
                        fromY: 65,
                      ),
                      BarChartRodData(
                        toY: 95,
                        color: AppColors.chartYellow,
                        width: 20,
                        fromY: 85,
                      ),
                      BarChartRodData(
                        toY: 100,
                        color: AppColors.chartOrange,
                        width: 20,
                        fromY: 95,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  // Tuesday
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 20,
                        color: AppColors.chartPurple,
                        width: 20,
                      ),
                      BarChartRodData(
                        toY: 50,
                        color: AppColors.chartBlue,
                        width: 20,
                        fromY: 20,
                      ),
                      BarChartRodData(
                        toY: 70,
                        color: AppColors.chartGreen,
                        width: 20,
                        fromY: 50,
                      ),
                      BarChartRodData(
                        toY: 90,
                        color: AppColors.chartYellow,
                        width: 20,
                        fromY: 70,
                      ),
                      BarChartRodData(
                        toY: 100,
                        color: AppColors.chartOrange,
                        width: 20,
                        fromY: 90,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  // Wednesday
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 50,
                        color: AppColors.chartPurple,
                        width: 20,
                      ),
                      BarChartRodData(
                        toY: 70,
                        color: AppColors.chartBlue,
                        width: 20,
                        fromY: 50,
                      ),
                      BarChartRodData(
                        toY: 85,
                        color: AppColors.chartGreen,
                        width: 20,
                        fromY: 70,
                      ),
                      BarChartRodData(
                        toY: 95,
                        color: AppColors.chartYellow,
                        width: 20,
                        fromY: 85,
                      ),
                      BarChartRodData(
                        toY: 100,
                        color: AppColors.chartOrange,
                        width: 20,
                        fromY: 95,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  // Thursday
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: 35,
                        color: AppColors.chartPurple,
                        width: 20,
                      ),
                      BarChartRodData(
                        toY: 60,
                        color: AppColors.chartBlue,
                        width: 20,
                        fromY: 35,
                      ),
                      BarChartRodData(
                        toY: 80,
                        color: AppColors.chartGreen,
                        width: 20,
                        fromY: 60,
                      ),
                      BarChartRodData(
                        toY: 95,
                        color: AppColors.chartYellow,
                        width: 20,
                        fromY: 80,
                      ),
                      BarChartRodData(
                        toY: 100,
                        color: AppColors.chartOrange,
                        width: 20,
                        fromY: 95,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  // Friday
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                        toY: 100,
                        color: AppColors.chartPurple,
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

