/// Utility functions for JSON conversion and manipulation
class JsonUtils {
  /// Safely parse a JSON value to a specific type
  /// Returns null if parsing fails or value is null
  static T? safeParse<T>(dynamic value) {
    if (value == null) return null;
    try {
      return value as T;
    } catch (e) {
      return null;
    }
  }

  /// Safely parse a number to double
  static double? safeParseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  /// Safely parse a value to int
  static int? safeParseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  /// Safely parse a value to bool
  static bool? safeParseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) {
      return value == 1;
    }
    return null;
  }

  /// Safely parse a DateTime from ISO 8601 string
  static DateTime? safeParseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Safely parse a list from JSON
  static List<T>? safeParseList<T>(dynamic value, T Function(dynamic) parser) {
    if (value == null) return null;
    if (value is! List) return null;
    try {
      return value.map((item) => parser(item)).toList();
    } catch (e) {
      return null;
    }
  }

  /// Convert a Map to JSON-safe format (removes null values optionally)
  static Map<String, dynamic> toJsonSafe(
    Map<String, dynamic> data, {
    bool removeNulls = false,
  }) {
    if (!removeNulls) return data;

    final result = <String, dynamic>{};
    data.forEach((key, value) {
      if (value != null) {
        result[key] = value;
      }
    });
    return result;
  }

  /// Deep merge two JSON maps
  static Map<String, dynamic> mergeJson(
    Map<String, dynamic> base,
    Map<String, dynamic> overlay,
  ) {
    final result = Map<String, dynamic>.from(base);

    overlay.forEach((key, value) {
      if (value is Map<String, dynamic> &&
          result[key] is Map<String, dynamic>) {
        result[key] = mergeJson(result[key] as Map<String, dynamic>, value);
      } else {
        result[key] = value;
      }
    });

    return result;
  }
}
