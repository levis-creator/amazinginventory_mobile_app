import 'package:equatable/equatable.dart';
import '../models/dashboard_stats_model.dart';
import '../models/revenue_expenses_chart_model.dart';

/// Base class for dashboard states.
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial dashboard state (unknown).
class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

/// Dashboard loading state (fetching stats and/or chart).
class DashboardLoading extends DashboardState {
  final bool isLoadingStats;
  final bool isLoadingChart;

  const DashboardLoading({
    this.isLoadingStats = true,
    this.isLoadingChart = true,
  });

  @override
  List<Object?> get props => [isLoadingStats, isLoadingChart];
}

/// Dashboard loaded state with stats and chart data.
class DashboardLoaded extends DashboardState {
  final DashboardStats stats;
  final RevenueExpensesChartData? chartData;

  const DashboardLoaded({
    required this.stats,
    this.chartData,
  });

  @override
  List<Object?> get props => [stats, chartData];

  /// Creates a copy of this state with updated values.
  DashboardLoaded copyWith({
    DashboardStats? stats,
    RevenueExpensesChartData? chartData,
  }) {
    return DashboardLoaded(
      stats: stats ?? this.stats,
      chartData: chartData ?? this.chartData,
    );
  }
}

/// Dashboard error state.
class DashboardError extends DashboardState {
  final String message;
  final bool isStatsError;
  final bool isChartError;

  const DashboardError(
    this.message, {
    this.isStatsError = true,
    this.isChartError = false,
  });

  @override
  List<Object?> get props => [message, isStatsError, isChartError];
}
