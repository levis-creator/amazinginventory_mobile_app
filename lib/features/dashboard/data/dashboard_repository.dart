import '../../../core/services/api_service.dart';
import '../models/dashboard_stats_model.dart';
import '../models/revenue_expenses_chart_model.dart';

/// Repository for dashboard data operations.
/// 
/// Handles fetching dashboard statistics and chart data from the API.
/// Follows the same pattern as [AuthRepository].
class DashboardRepository {
  final ApiService apiService;

  DashboardRepository(this.apiService);

  /// Fetches dashboard statistics from the API.
  /// 
  /// Returns [DashboardStats] model with key inventory metrics.
  /// Throws [ApiException] if the request fails.
  Future<DashboardStats> getStats() async {
    try {
      final response = await apiService.get('/dashboard/stats');
      return DashboardStats.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches revenue vs expenses chart data from the API.
  /// 
  /// Returns [RevenueExpensesChartData] model with daily revenue and expenses
  /// for the last 30 days.
  /// Throws [ApiException] if the request fails.
  Future<RevenueExpensesChartData> getRevenueExpensesChart() async {
    try {
      final response = await apiService.get('/dashboard/revenue-expenses-chart');
      return RevenueExpensesChartData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}

