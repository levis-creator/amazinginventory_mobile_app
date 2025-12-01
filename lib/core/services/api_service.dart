import 'package:dio/dio.dart';
import 'token_storage_service.dart';
import 'api_logging_interceptor.dart';

/// API Service for making HTTP requests to the Laravel backend
/// Uses Dio for better performance, automatic JSON parsing, and advanced features
class ApiService {
  static const String baseUrl = 'https://amazinginventory.onrender.com/api/v1';

  late final Dio _dio;
  String? _token;
  final TokenStorageService? _tokenStorage;

  ApiService({TokenStorageService? tokenStorage}) : _tokenStorage = tokenStorage {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logging interceptor (only logs in debug mode)
    _dio.interceptors.add(ApiLoggingInterceptor());

    // Add request interceptor to include auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle 401 Unauthorized - token expired
          if (error.response?.statusCode == 401) {
            _token = null;
            _tokenStorage?.deleteToken();
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// Load token from secure storage.
  /// This should be called during app initialization to restore session.
  Future<void> loadTokenFromStorage() async {
    final tokenStorage = _tokenStorage;
    if (tokenStorage != null) {
      final token = await tokenStorage.getToken();
      if (token != null) {
        _token = token;
      }
    }
  }

  /// Set the authentication token and persist it.
  Future<void> setToken(String? token) async {
    _token = token;
    final tokenStorage = _tokenStorage;
    if (token != null && tokenStorage != null) {
      await tokenStorage.saveToken(token);
    } else if (token == null && tokenStorage != null) {
      await tokenStorage.deleteToken();
    }
  }

  /// Generic POST request
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        endpoint,
        data: data,
      );
      return response.data ?? {};
    } on DioException catch (e) {
      // Handle API errors with proper parsing
      if (e.response != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          throw ApiException(
            message:
                responseData['message'] as String? ??
                e.message ??
                'Request failed',
            statusCode: e.response!.statusCode ?? 500,
            errors: responseData['errors'] as Map<String, dynamic>?,
          );
        }
      }
      throw ApiException(
        message: e.message ?? 'Request failed',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  /// Generic GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParams,
      );
      return response.data ?? {};
    } on DioException catch (e) {
      // Handle API errors with proper parsing
      if (e.response != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          throw ApiException(
            message:
                responseData['message'] as String? ??
                e.message ??
                'Request failed',
            statusCode: e.response!.statusCode ?? 500,
            errors: responseData['errors'] as Map<String, dynamic>?,
          );
        }
      }
      throw ApiException(
        message: e.message ?? 'Request failed',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  /// Generic PUT request
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        endpoint,
        data: data,
      );
      return response.data ?? {};
    } on DioException catch (e) {
      // Handle API errors with proper parsing
      if (e.response != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          throw ApiException(
            message:
                responseData['message'] as String? ??
                e.message ??
                'Request failed',
            statusCode: e.response!.statusCode ?? 500,
            errors: responseData['errors'] as Map<String, dynamic>?,
          );
        }
      }
      throw ApiException(
        message: e.message ?? 'Request failed',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  /// Generic DELETE request
  Future<void> delete(String endpoint) async {
    try {
      await _dio.delete(endpoint);
    } on DioException catch (e) {
      // Handle API errors with proper parsing
      if (e.response != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic>) {
          throw ApiException(
            message:
                responseData['message'] as String? ??
                e.message ??
                'Request failed',
            statusCode: e.response!.statusCode ?? 500,
            errors: responseData['errors'] as Map<String, dynamic>?,
          );
        }
      }
      throw ApiException(
        message: e.message ?? 'Request failed',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors;

  ApiException({required this.message, required this.statusCode, this.errors});

  @override
  String toString() => message;

  /// Get formatted error message from validation errors
  String? getFormattedErrors() {
    if (errors == null) return null;

    final errorMessages = <String>[];
    errors!.forEach((field, messages) {
      if (messages is List) {
        for (final message in messages) {
          errorMessages.add('$field: $message');
        }
      } else {
        errorMessages.add('$field: $messages');
      }
    });

    return errorMessages.isEmpty ? null : errorMessages.join('\n');
  }
}
