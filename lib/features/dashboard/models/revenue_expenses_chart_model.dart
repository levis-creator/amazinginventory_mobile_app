/// Revenue vs Expenses chart data model.
/// 
/// This data class represents the chart data for displaying revenue
/// and expenses trends over the last 30 days.
class RevenueExpensesChartData {
  /// Date labels for the chart (e.g., ["Jan 1", "Jan 2", ...])
  final List<String> labels;
  
  /// Daily revenue amounts
  final List<double> revenueData;
  
  /// Daily expense amounts
  final List<double> expensesData;

  /// Creates a new [RevenueExpensesChartData] instance.
  RevenueExpensesChartData({
    required this.labels,
    required this.revenueData,
    required this.expensesData,
  });

  /// Creates a [RevenueExpensesChartData] from JSON data (API response).
  factory RevenueExpensesChartData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return RevenueExpensesChartData(
      labels: (data['labels'] as List).map((label) => label as String).toList(),
      revenueData: (data['revenue_data'] as List)
          .map((value) => (value as num).toDouble())
          .toList(),
      expensesData: (data['expenses_data'] as List)
          .map((value) => (value as num).toDouble())
          .toList(),
    );
  }

  /// Converts the model to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'data': {
        'labels': labels,
        'revenue_data': revenueData,
        'expenses_data': expensesData,
      },
    };
  }

  /// Calculates total revenue for the period.
  double get totalRevenue {
    return revenueData.fold(0.0, (sum, value) => sum + value);
  }

  /// Calculates total expenses for the period.
  double get totalExpenses {
    return expensesData.fold(0.0, (sum, value) => sum + value);
  }

  /// Calculates net profit (revenue - expenses).
  double get netProfit {
    return totalRevenue - totalExpenses;
  }

  /// Calculates revenue trend percentage (comparing first half vs second half).
  /// Returns positive value if revenue is increasing, negative if decreasing.
  double get revenueTrend {
    if (revenueData.length < 2) return 0.0;
    
    final midPoint = revenueData.length ~/ 2;
    final firstHalf = revenueData.sublist(0, midPoint);
    final secondHalf = revenueData.sublist(midPoint);
    
    final firstHalfAvg = firstHalf.fold(0.0, (sum, v) => sum + v) / firstHalf.length;
    final secondHalfAvg = secondHalf.fold(0.0, (sum, v) => sum + v) / secondHalf.length;
    
    if (firstHalfAvg == 0) return secondHalfAvg > 0 ? 100.0 : 0.0;
    
    return ((secondHalfAvg - firstHalfAvg) / firstHalfAvg) * 100;
  }
}

