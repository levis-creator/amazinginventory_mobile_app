/// Utility functions for generating greetings.
/// 
/// Follows the Single Responsibility Principle (SOLID) by focusing solely
/// on greeting generation logic.
class GreetingUtil {
  /// Returns a greeting based on the current time of day.
  /// 
  /// Time ranges:
  /// - Before 12:00 PM -> "GOOD MORNING! ^-^"
  /// - 12:00 PM - 4:59 PM -> "GOOD AFTERNOON! ^-^"
  /// - 5:00 PM and later -> "GOOD EVENING! ^-^"
  /// 
  /// Returns the appropriate greeting string.
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'GOOD MORNING! ^-^';
    } else if (hour < 17) {
      return 'GOOD AFTERNOON! ^-^';
    } else {
      return 'GOOD EVENING! ^-^';
    }
  }
}

