/// Utility functions for user-related operations.
/// 
/// Follows the Single Responsibility Principle (SOLID) by focusing solely
/// on user-related utility functions.
class UserUtil {
  /// Gets user initials from a full name.
  /// 
  /// Takes the first letter of the first word and the first letter of the second word (if available).
  /// If only one word is provided, returns the first letter.
  /// 
  /// Examples:
  /// - "John Doe" -> "JD"
  /// - "John" -> "J"
  /// - "Mary Jane Watson" -> "MJ"
  /// 
  /// [name] The full name of the user
  /// Returns the initials as an uppercase string
  static String getInitials(String name) {
    if (name.trim().isEmpty) {
      return '?';
    }
    
    final words = name.trim().split(RegExp(r'\s+'));
    
    if (words.length == 1) {
      // Single word - return first letter
      return words[0][0].toUpperCase();
    } else {
      // Multiple words - return first letter of first two words
      final firstInitial = words[0][0].toUpperCase();
      final secondInitial = words[1][0].toUpperCase();
      return '$firstInitial$secondInitial';
    }
  }
}




