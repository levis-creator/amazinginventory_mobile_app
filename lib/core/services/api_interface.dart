/// Abstract interface for API services.
/// 
/// This allows repositories to work with both [ApiService] and [OfflineApiService]
/// without tight coupling to a specific implementation.
abstract class ApiInterface {
  /// Base URL for API requests
  String get baseUrlInstance;

  /// Generic GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Duration? timeout,
  });

  /// Generic POST request
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  );

  /// Generic PUT request
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  );

  /// Generic DELETE request
  Future<void> delete(String endpoint);

  /// Set authentication token
  Future<void> setToken(String? token);

  /// Load token from storage
  Future<void> loadTokenFromStorage();
}

