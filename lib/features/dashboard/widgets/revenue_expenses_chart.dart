import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/responsive_util.dart';
import '../models/revenue_expenses_chart_model.dart';

/// Revenue vs Expenses chart widget displaying 30-day trends
/// Uses fl_chart for visualization
/// Uses AppColors for consistent theming
class RevenueExpensesChart extends StatelessWidget {
  final RevenueExpensesChartData chartData;

  const RevenueExpensesChart({
    super.key,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveUtil.getCardPadding(context);
    final titleFontSize = ResponsiveUtil.getFontSize(context, baseSize: 22);
    final subtitleFontSize = ResponsiveUtil.getFontSize(context, baseSize: 14);
    final periodFontSize = ResponsiveUtil.getFontSize(context, baseSize: 12);
    final chartHeight = ResponsiveUtil.getChartHeight(context);
    final spacing = ResponsiveUtil.getSpacing(context);
    
    // Calculate trend
    final trend = chartData.revenueTrend;
    final trendText = trend >= 0 
        ? '+${trend.toStringAsFixed(1)}% Revenue increase'
        : '${trend.toStringAsFixed(1)}% Revenue decrease';
    final trendColor = trend >= 0 ? AppColors.successText : AppColors.error;
    
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
                  'Revenue vs Expenses',
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
                      'Last 30 days',
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
            trendText,
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: trendColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: spacing + 8),
          SizedBox(
            height: chartHeight,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => AppColors.cardBackground,
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateInterval(chartData),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.gray200,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: _calculateLabelInterval(chartData.labels.length).toDouble(),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < chartData.labels.length) {
                          // Show every nth label to avoid crowding
                          final interval = _calculateLabelInterval(chartData.labels.length);
                          if (index % interval == 0 || index == chartData.labels.length - 1) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                chartData.labels[index],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: _calculateInterval(chartData),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${_formatValue(value)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: AppColors.gray200, width: 1),
                    left: BorderSide(color: AppColors.gray200, width: 1),
                  ),
                ),
                minX: 0.0,
                maxX: (chartData.labels.length - 1).toDouble(),
                minY: 0.0,
                maxY: _calculateMaxY(chartData),
                lineBarsData: [
                  // Revenue line (green)
                  LineChartBarData(
                    spots: _generateSpots(chartData.revenueData),
                    isCurved: true,
                    color: AppColors.success,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.success.withValues(alpha: 0.1),
                    ),
                  ),
                  // Expenses line (red)
                  LineChartBarData(
                    spots: _generateSpots(chartData.expensesData),
                    isCurved: true,
                    color: AppColors.error,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.error.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                context,
                'Revenue',
                AppColors.success,
              ),
              SizedBox(width: spacing * 2),
              _buildLegendItem(
                context,
                'Expenses',
                AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Generate spots for the line chart
  List<FlSpot> _generateSpots(List<double> data) {
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }

  /// Calculate maximum Y value for the chart
  double _calculateMaxY(RevenueExpensesChartData chartData) {
    final allValues = [
      ...chartData.revenueData,
      ...chartData.expensesData,
    ];
    if (allValues.isEmpty) return 100;
    
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    // Add 20% padding to the top
    return maxValue * 1.2;
  }

  /// Calculate interval for grid lines
  double _calculateInterval(RevenueExpensesChartData chartData) {
    final maxY = _calculateMaxY(chartData);
    if (maxY <= 100) return 20;
    if (maxY <= 500) return 100;
    if (maxY <= 1000) return 200;
    if (maxY <= 5000) return 1000;
    return maxY / 5;
  }

  /// Calculate label interval for bottom axis
  int _calculateLabelInterval(int labelCount) {
    if (labelCount <= 7) return 1;
    if (labelCount <= 14) return 2;
    if (labelCount <= 30) return 5;
    return 7;
  }

  /// Format value for display
  String _formatValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(0);
  }

  /// Build legend item
  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    final fontSize = ResponsiveUtil.getFontSize(context, baseSize: 12);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: ResponsiveUtil.isSmallScreen(context) ? 4 : 6),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

