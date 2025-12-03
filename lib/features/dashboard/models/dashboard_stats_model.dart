/// Dashboard statistics model representing key inventory metrics.
/// 
/// This data class represents the statistics displayed on the dashboard,
/// including stock value, stock count, and stock alerts.
class DashboardStats {
  /// Total stock value (sum of stock × cost_price for all active products)
  final double totalStockValue;
  
  /// Total stock quantity (sum of stock for all active products)
  final int totalStock;
  
  /// Count of active products with stock = 0
  final int outOfStock;
  
  /// Count of active products with stock < threshold (default: 10)
  final int lowStock;

  /// Creates a new [DashboardStats] instance.
  DashboardStats({
    required this.totalStockValue,
    required this.totalStock,
    required this.outOfStock,
    required this.lowStock,
  });

  /// Creates a [DashboardStats] from JSON data (API response).
  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return DashboardStats(
      totalStockValue: double.parse(data['total_stock_value'] as String),
      totalStock: data['total_stock'] as int,
      outOfStock: data['out_of_stock'] as int,
      lowStock: data['low_stock'] as int,
    );
  }

  /// Converts the model to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'data': {
        'total_stock_value': totalStockValue.toStringAsFixed(2),
        'total_stock': totalStock,
        'out_of_stock': outOfStock,
        'low_stock': lowStock,
      },
    };
  }

  /// Formats total stock value as currency string (e.g., "$45,210.00").
  String get formattedTotalStockValue {
    return '\$${_formatCurrency(totalStockValue)}';
  }

  /// Formats total stock with commas (e.g., "1,284").
  String get formattedTotalStock {
    return _formatInteger(totalStock);
  }

  /// Helper method to format currency with commas and decimals.
  String _formatCurrency(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '00';
    
    // Add commas to integer part
    final formattedInteger = integerPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    
    return '$formattedInteger.$decimalPart';
  }

  /// Helper method to format integers with commas.
  String _formatInteger(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
