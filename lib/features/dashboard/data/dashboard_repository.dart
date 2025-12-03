import '../../../core/services/api_interface.dart';
import '../models/dashboard_stats_model.dart';
import '../models/revenue_expenses_chart_model.dart';

/// Repository for dashboard data operations.
///
/// Handles fetching dashboard statistics and chart data from the API.
/// Follows the same pattern as [AuthRepository].
class DashboardRepository {
  final ApiInterface apiService;

  DashboardRepository(this.apiService);

  /// Fetches dashboard statistics from the API.
  ///
  /// Returns [DashboardStats] model with key inventory metrics.
  /// Throws [ApiException] if the request fails.
  Future<DashboardStats> getStats() async {
    try {
      // Debug: Log the full endpoint URL being called
      final endpoint = '/dashboard/stats';
      final baseUrl = apiService.baseUrlInstance;
      final fullUrl = '$baseUrl$endpoint';
      print('🔍 Dashboard Stats - Full URL: $fullUrl');
      print('🔍 Dashboard Stats - Base URL: $baseUrl');
      print('🔍 Dashboard Stats - Endpoint: $endpoint');

      final response = await apiService.get(endpoint);
      // Debug: Log response structure
      print('📊 Dashboard Stats Response: $response');
      return DashboardStats.fromJson(response);
    } catch (e) {
      // Debug: Log error details
      print('❌ Dashboard Stats Error: $e');
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
      // Debug: Log the full endpoint URL being called
      final endpoint = '/dashboard/revenue-expenses-chart';
      final baseUrl = apiService.baseUrlInstance;
      final fullUrl = '$baseUrl$endpoint';
      print('🔍 Chart Data - Full URL: $fullUrl');
      print('🔍 Chart Data - Base URL: $baseUrl');
      print('🔍 Chart Data - Endpoint: $endpoint');

      print('⏳ Chart Data - Starting API call...');
      // Use a longer timeout for chart data (60 seconds) as it may take longer
      // The backend query processes 30 days of data which can be slow
      final response = await apiService.get(
        endpoint,
        timeout: const Duration(seconds: 60),
      );
      print('✅ Chart Data - API call completed');

      // Debug: Log response structure
      print('📈 Chart Data Response: $response');
      print('📈 Chart Data Response Type: ${response.runtimeType}');
      print('📈 Chart Data Response Keys: ${response.keys}');

      // Verify response structure matches backend
      if (!response.containsKey('data')) {
        throw Exception(
          'Invalid response format: missing "data" key. Response: $response',
        );
      }

      final data = response['data'] as Map<String, dynamic>;
      print('📈 Chart Data - Parsed data keys: ${data.keys}');

      return RevenueExpensesChartData.fromJson(response);
    } catch (e, stackTrace) {
      // Debug: Log error details with stack trace
      print('❌ Chart Data Error: $e');
      print('❌ Chart Data Error Stack: $stackTrace');
      rethrow;
    }
  }
}
