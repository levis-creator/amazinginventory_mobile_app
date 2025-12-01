import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Interceptor for logging API requests and responses in debug mode.
/// 
/// Only logs when running in debug mode (kDebugMode).
/// Masks sensitive information like authorization tokens and passwords.
class ApiLoggingInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) {
      return handler.next(options);
    }

    final uri = options.uri.toString();
    final method = options.method;
    final headers = _maskSensitiveHeaders(options.headers);
    final queryParams = options.queryParameters;
    final data = _maskSensitiveData(options.data);

    _logger.d(
      '🌐 API Request',
      error: {
        'Method': method,
        'URL': uri,
        'Headers': headers,
        if (queryParams.isNotEmpty) 'Query Params': queryParams,
        if (data != null) 'Body': data,
      },
    );

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!kDebugMode) {
      return handler.next(response);
    }

    final statusCode = response.statusCode;
    final statusMessage = response.statusMessage;
    final uri = response.requestOptions.uri.toString();
    final method = response.requestOptions.method;
    final data = response.data;
    final responseTime = response.extra['response_time'] as Duration?;

    final logLevel = _getLogLevel(statusCode);
    final emoji = _getStatusEmoji(statusCode);

    _logger.log(
      logLevel,
      '$emoji API Response',
      error: {
        'Method': method,
        'URL': uri,
        'Status': '$statusCode ${statusMessage ?? ''}',
        if (responseTime != null) 'Response Time': '${responseTime.inMilliseconds}ms',
        if (data != null) 'Data': _truncateData(data),
      },
    );

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode) {
      return handler.next(err);
    }

    final uri = err.requestOptions.uri.toString();
    final method = err.requestOptions.method;
    final statusCode = err.response?.statusCode;
    final responseData = err.response?.data;
    final errorMessage = err.message;

    _logger.e(
      '❌ API Error',
      error: {
        'Method': method,
        'URL': uri,
        if (statusCode != null) 'Status Code': statusCode,
        if (errorMessage != null) 'Error': errorMessage,
        if (responseData != null) 'Response Data': _truncateData(responseData),
        if (err.type != DioExceptionType.unknown) 'Error Type': err.type.toString(),
      },
      stackTrace: err.stackTrace,
    );

    return handler.next(err);
  }

  /// Masks sensitive headers like Authorization tokens.
  Map<String, dynamic> _maskSensitiveHeaders(Map<String, dynamic> headers) {
    final masked = Map<String, dynamic>.from(headers);
    final sensitiveKeys = ['authorization', 'cookie', 'x-csrf-token', 'x-api-key'];

    for (final key in sensitiveKeys) {
      final lowerKey = key.toLowerCase();
      if (masked.containsKey(key)) {
        masked[key] = '***MASKED***';
      } else {
        // Check case-insensitive
        final foundKey = masked.keys.firstWhere(
          (k) => k.toLowerCase() == lowerKey,
          orElse: () => '',
        );
        if (foundKey.isNotEmpty) {
          masked[foundKey] = '***MASKED***';
        }
      }
    }

    return masked;
  }

  /// Masks sensitive data fields like passwords.
  dynamic _maskSensitiveData(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      final masked = Map<String, dynamic>.from(data);
      final sensitiveFields = [
        'password',
        'password_confirmation',
        'current_password',
        'token',
        'api_key',
        'access_token',
        'refresh_token',
      ];

      for (final field in sensitiveFields) {
        if (masked.containsKey(field)) {
          masked[field] = '***MASKED***';
        }
      }

      return masked;
    }

    return data;
  }

  /// Truncates large data objects for better readability.
  dynamic _truncateData(dynamic data) {
    if (data == null) return null;

    if (data is String && data.length > 500) {
      return '${data.substring(0, 500)}... (truncated, ${data.length} chars)';
    }

    if (data is Map || data is List) {
      final jsonString = data.toString();
      if (jsonString.length > 500) {
        return '${jsonString.substring(0, 500)}... (truncated, ${jsonString.length} chars)';
      }
    }

    return data;
  }

  /// Gets the appropriate log level based on HTTP status code.
  Level _getLogLevel(int? statusCode) {
    if (statusCode == null) return Level.error;

    if (statusCode >= 500) {
      return Level.error;
    } else if (statusCode >= 400) {
      return Level.warning;
    } else {
      return Level.info;
    }
  }

  /// Gets emoji based on HTTP status code.
  String _getStatusEmoji(int? statusCode) {
    if (statusCode == null) return '❌';

    if (statusCode >= 500) {
      return '🔴';
    } else if (statusCode >= 400) {
      return '🟡';
    } else {
      return '✅';
    }
  }
}


