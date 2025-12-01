import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/dashboard_repository.dart';
import '../models/dashboard_stats_model.dart';
import '../models/revenue_expenses_chart_model.dart';
import '../../../core/services/api_service.dart';
import 'dashboard_state.dart';

/// Cubit for managing dashboard state.
/// 
/// Handles loading dashboard statistics and chart data.
/// Follows the same pattern as [AuthCubit].
class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _dashboardRepository;

  DashboardCubit({DashboardRepository? dashboardRepository})
      : _dashboardRepository = dashboardRepository ??
            DashboardRepository(
              ApiService(),
            ),
        super(const DashboardInitial());

  /// Load dashboard statistics.
  /// 
  /// Fetches stats from the API and emits appropriate states.
  /// If chart data is already loaded, preserves it in the loaded state.
  Future<void> loadStats() async {
    // If we already have stats, preserve chart data if it exists
    final currentState = state;
    RevenueExpensesChartData? existingChartData;
    if (currentState is DashboardLoaded) {
      existingChartData = currentState.chartData;
    }

    emit(DashboardLoading(isLoadingStats: true, isLoadingChart: false));
    
    try {
      final stats = await _dashboardRepository.getStats();
      
      // If we have existing chart data, include it in the loaded state
      if (existingChartData != null) {
        emit(DashboardLoaded(stats: stats, chartData: existingChartData));
      } else {
        emit(DashboardLoaded(stats: stats));
      }
    } on ApiException catch (e) {
      emit(DashboardError(e.message, isStatsError: true, isChartError: false));
    } catch (e) {
      emit(DashboardError('Failed to load stats: ${e.toString()}', 
          isStatsError: true, isChartError: false));
    }
  }

  /// Load revenue vs expenses chart data.
  /// 
  /// Fetches chart data from the API and emits appropriate states.
  /// If stats are already loaded, preserves them in the loaded state.
  Future<void> loadChart() async {
    // If we already have stats, preserve them
    final currentState = state;
    DashboardStats? existingStats;
    if (currentState is DashboardLoaded) {
      existingStats = currentState.stats;
    }

    emit(DashboardLoading(isLoadingStats: false, isLoadingChart: true));
    
    try {
      final chartData = await _dashboardRepository.getRevenueExpensesChart();
      
      // If we have existing stats, include them in the loaded state
      if (existingStats != null) {
        emit(DashboardLoaded(stats: existingStats, chartData: chartData));
      } else {
        // If no stats yet, we need to load them first
        await loadStats();
        final updatedState = state;
        if (updatedState is DashboardLoaded) {
          emit(updatedState.copyWith(chartData: chartData));
        }
      }
    } on ApiException catch (e) {
      emit(DashboardError(e.message, isStatsError: false, isChartError: true));
    } catch (e) {
      emit(DashboardError('Failed to load chart: ${e.toString()}', 
          isStatsError: false, isChartError: true));
    }
  }

  /// Load both stats and chart data.
  /// 
  /// Convenience method to load all dashboard data at once.
  Future<void> loadAll() async {
    emit(const DashboardLoading(isLoadingStats: true, isLoadingChart: true));
    
    try {
      // Load both in parallel for better performance
      final results = await Future.wait([
        _dashboardRepository.getStats(),
        _dashboardRepository.getRevenueExpensesChart(),
      ]);
      
      final stats = results[0] as DashboardStats;
      final chartData = results[1] as RevenueExpensesChartData;
      
      emit(DashboardLoaded(stats: stats, chartData: chartData));
    } on ApiException catch (e) {
      emit(DashboardError(e.message));
    } catch (e) {
      emit(DashboardError('Failed to load dashboard: ${e.toString()}'));
    }
  }

  /// Refresh dashboard data (pull-to-refresh).
  /// 
  /// Reloads both stats and chart data.
  Future<void> refresh() async {
    await loadAll();
  }
}

