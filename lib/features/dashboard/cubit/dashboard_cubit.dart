import 'dart:async';
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
    // Check if cubit is closed before proceeding
    if (isClosed) return;
    
    // If we already have stats, preserve chart data if it exists
    final currentState = state;
    RevenueExpensesChartData? existingChartData;
    if (currentState is DashboardLoaded) {
      existingChartData = currentState.chartData;
    }

    if (!isClosed) {
      emit(const DashboardLoading(isLoadingStats: true, isLoadingChart: false));
    }
    
    try {
      final stats = await _dashboardRepository.getStats();
      
      // Check if cubit is still open before emitting
      if (isClosed) return;
      
      // If we have existing chart data, include it in the loaded state
      if (existingChartData != null) {
        emit(DashboardLoaded(stats: stats, chartData: existingChartData));
      } else {
        emit(DashboardLoaded(stats: stats));
      }
    } on ApiException catch (e) {
      if (!isClosed) {
        emit(DashboardError(e.message, isStatsError: true, isChartError: false));
      }
    } catch (e) {
      if (!isClosed) {
        emit(DashboardError('Failed to load stats: ${e.toString()}', 
            isStatsError: true, isChartError: false));
      }
    }
  }

  /// Load revenue vs expenses chart data.
  /// 
  /// Fetches chart data from the API and emits appropriate states.
  /// If stats are already loaded, preserves them in the loaded state.
  Future<void> loadChart() async {
    // Check if cubit is closed before proceeding
    if (isClosed) return;
    
    // If we already have stats, preserve them
    final currentState = state;
    DashboardStats? existingStats;
    if (currentState is DashboardLoaded) {
      existingStats = currentState.stats;
    }

    if (!isClosed) {
      emit(const DashboardLoading(isLoadingStats: false, isLoadingChart: true));
    }
    
    try {
      final chartData = await _dashboardRepository.getRevenueExpensesChart();
      
      // Check if cubit is still open before emitting
      if (isClosed) return;
      
      // If we have existing stats, include them in the loaded state
      if (existingStats != null) {
        emit(DashboardLoaded(stats: existingStats, chartData: chartData));
      } else {
        // If no stats yet, we need to load them first
        await loadStats();
        if (!isClosed) {
          final updatedState = state;
          if (updatedState is DashboardLoaded) {
            emit(updatedState.copyWith(chartData: chartData));
          }
        }
      }
    } on ApiException catch (e) {
      if (!isClosed) {
        emit(DashboardError(e.message, isStatsError: false, isChartError: true));
      }
    } catch (e) {
      if (!isClosed) {
        emit(DashboardError('Failed to load chart: ${e.toString()}', 
            isStatsError: false, isChartError: true));
      }
    }
  }

  /// Load both stats and chart data.
  /// 
  /// Convenience method to load all dashboard data at once.
  /// Only loads if data hasn't been loaded yet (state is initial or error).
  Future<void> loadAll() async {
    // Check if cubit is closed before proceeding
    if (isClosed) {
      print('⚠️ DashboardCubit: loadAll() called but cubit is closed');
      return;
    }
    
    // Don't reload if data is already loaded
    final currentState = state;
    if (currentState is DashboardLoaded) {
      print('✅ DashboardCubit: Data already loaded, skipping reload');
      return;
    }
    
    print('🔄 DashboardCubit: Starting loadAll()');
    if (!isClosed) {
      emit(const DashboardLoading(isLoadingStats: true, isLoadingChart: true));
      print('📤 DashboardCubit: Emitted DashboardLoading state');
    }
    
    try {
      print('🌐 DashboardCubit: Fetching stats and chart data...');
      
      // Load both in parallel but handle errors independently
      // This way if one fails, we can still show the other
      DashboardStats? stats;
      RevenueExpensesChartData? chartData;
      
      try {
        print('📊 DashboardCubit: Fetching stats...');
        stats = await _dashboardRepository.getStats()
            .timeout(const Duration(seconds: 30));
        print('✅ DashboardCubit: Stats received');
      } catch (e) {
        print('❌ DashboardCubit: Failed to load stats: $e');
        // Continue even if stats fail - we'll show error for stats only
      }
      
      try {
        print('📈 DashboardCubit: Fetching chart data...');
        chartData = await _dashboardRepository.getRevenueExpensesChart()
            .timeout(const Duration(seconds: 30));
        print('✅ DashboardCubit: Chart data received - ${chartData.labels.length} labels');
      } catch (e, stackTrace) {
        print('❌ DashboardCubit: Failed to load chart: $e');
        print('❌ DashboardCubit: Chart error stack: $stackTrace');
        // Continue even if chart fails - we'll show error for chart only
        chartData = null;
      }
      
      // Check if cubit is still open before emitting
      if (isClosed) {
        print('⚠️ DashboardCubit: Data received but cubit is closed');
        return;
      }
      
      // If we have at least stats, show the dashboard
      if (stats != null) {
        final chartLabelsCount = chartData?.labels.length ?? 0;
        print('✅ DashboardCubit: Data received - Stats: ${stats.totalStockValue}, Chart: $chartLabelsCount labels');
        if (!isClosed) {
          emit(DashboardLoaded(stats: stats, chartData: chartData));
          print('📤 DashboardCubit: Emitted DashboardLoaded state');
        }
      } else {
        // If both failed, show error
        throw Exception('Failed to load dashboard data');
      }
    } on TimeoutException catch (e) {
      print('⏱️ DashboardCubit: TimeoutException - ${e.message}');
      if (!isClosed) {
        emit(DashboardError('Request timed out. Please check your internet connection.'));
        print('📤 DashboardCubit: Emitted DashboardError state (timeout)');
      }
    } on ApiException catch (e) {
      print('❌ DashboardCubit: ApiException - ${e.message}');
      if (!isClosed) {
        emit(DashboardError(e.message));
        print('📤 DashboardCubit: Emitted DashboardError state');
      }
    } catch (e, stackTrace) {
      print('❌ DashboardCubit: Exception - ${e.toString()}');
      print('📚 Stack trace: $stackTrace');
      if (!isClosed) {
        emit(DashboardError('Failed to load dashboard: ${e.toString()}'));
        print('📤 DashboardCubit: Emitted DashboardError state');
      }
    }
  }

  /// Refresh dashboard data (pull-to-refresh).
  /// 
  /// Reloads both stats and chart data.
  Future<void> refresh() async {
    await loadAll();
  }
}

