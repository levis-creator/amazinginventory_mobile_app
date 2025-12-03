import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

/// Service for managing offline data storage using Hive.
/// 
/// Provides methods to cache API responses locally and retrieve them
/// when offline. Supports TTL (time-to-live) for cached data.
class OfflineStorageService {
  static const String _boxName = 'offline_storage';
  static const String _cachePrefix = 'cache_';
  static const String _queuePrefix = 'queue_';
  static const String _metadataPrefix = 'meta_';
  
  Box? _box;
  bool _initialized = false;

  /// Initialize Hive and open the storage box.
  Future<void> init() async {
    if (_initialized) return;
    
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
    _initialized = true;
  }

  /// Check if service is initialized.
  bool get isInitialized => _initialized && _box != null;

  /// Cache API response data with optional TTL.
  /// 
  /// [key] Unique key for the cached data (e.g., endpoint path)
  /// [data] Data to cache (will be JSON encoded)
  /// [ttl] Time-to-live in seconds (null = no expiration)
  Future<void> cacheData(
    String key,
    Map<String, dynamic> data, {
    int? ttl,
  }) async {
    if (!isInitialized) await init();
    
    final cacheKey = '$_cachePrefix$key';
    final metadataKey = '$_metadataPrefix$key';
    
    final metadata = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'ttl': ttl,
    };
    
    await _box!.put(cacheKey, jsonEncode(data));
    await _box!.put(metadataKey, jsonEncode(metadata));
  }

  /// Retrieve cached data if available and not expired.
  /// 
  /// Returns null if data doesn't exist or has expired.
  Map<String, dynamic>? getCachedData(String key) {
    if (!isInitialized) return null;
    
    final cacheKey = '$_cachePrefix$key';
    final metadataKey = '$_metadataPrefix$key';
    
    // Check if data exists
    final cachedData = _box!.get(cacheKey);
    final metadataJson = _box!.get(metadataKey);
    
    if (cachedData == null || metadataJson == null) {
      return null;
    }
    
    // Check expiration
    try {
      final metadata = jsonDecode(metadataJson as String) as Map<String, dynamic>;
      final timestamp = metadata['timestamp'] as int;
      final ttl = metadata['ttl'] as int?;
      
      if (ttl != null) {
        final age = DateTime.now().millisecondsSinceEpoch - timestamp;
        if (age > ttl * 1000) {
          // Data expired, remove it
          _box!.delete(cacheKey);
          _box!.delete(metadataKey);
          return null;
        }
      }
      
      // Data is valid, return it
      return jsonDecode(cachedData as String) as Map<String, dynamic>;
    } catch (e) {
      // Invalid data, remove it
      _box!.delete(cacheKey);
      _box!.delete(metadataKey);
      return null;
    }
  }

  /// Check if cached data exists and is valid.
  bool hasCachedData(String key) {
    return getCachedData(key) != null;
  }

  /// Remove cached data.
  Future<void> removeCachedData(String key) async {
    if (!isInitialized) return;
    
    final cacheKey = '$_cachePrefix$key';
    final metadataKey = '$_metadataPrefix$key';
    
    await _box!.delete(cacheKey);
    await _box!.delete(metadataKey);
  }

  /// Clear all cached data.
  Future<void> clearCache() async {
    if (!isInitialized) return;
    
    final keysToDelete = <String>[];
    
    for (var key in _box!.keys) {
      final keyStr = key.toString();
      if (keyStr.startsWith(_cachePrefix) || 
          keyStr.startsWith(_metadataPrefix)) {
        keysToDelete.add(keyStr);
      }
    }
    
    for (var key in keysToDelete) {
      await _box!.delete(key);
    }
  }

  /// Queue a request for later sync.
  /// 
  /// [requestId] Unique identifier for the request
  /// [method] HTTP method (GET, POST, PUT, DELETE)
  /// [endpoint] API endpoint path
  /// [data] Request data (for POST/PUT)
  Future<void> queueRequest({
    required String requestId,
    required String method,
    required String endpoint,
    Map<String, dynamic>? data,
  }) async {
    if (!isInitialized) await init();
    
    final queueKey = '$_queuePrefix$requestId';
    final requestData = {
      'id': requestId,
      'method': method,
      'endpoint': endpoint,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    await _box!.put(queueKey, jsonEncode(requestData));
  }

  /// Get all queued requests.
  List<Map<String, dynamic>> getQueuedRequests() {
    if (!isInitialized) return [];
    
    final requests = <Map<String, dynamic>>[];
    
    for (var key in _box!.keys) {
      final keyStr = key.toString();
      if (keyStr.startsWith(_queuePrefix)) {
        try {
          final requestJson = _box!.get(keyStr);
          if (requestJson != null) {
            final request = jsonDecode(requestJson as String) as Map<String, dynamic>;
            requests.add(request);
          }
        } catch (e) {
          // Invalid request, skip it
        }
      }
    }
    
    // Sort by timestamp (oldest first)
    requests.sort((a, b) {
      final aTime = a['timestamp'] as String;
      final bTime = b['timestamp'] as String;
      return aTime.compareTo(bTime);
    });
    
    return requests;
  }

  /// Remove a queued request after successful sync.
  Future<void> removeQueuedRequest(String requestId) async {
    if (!isInitialized) return;
    
    final queueKey = '$_queuePrefix$requestId';
    await _box!.delete(queueKey);
  }

  /// Clear all queued requests.
  Future<void> clearQueue() async {
    if (!isInitialized) return;
    
    final keysToDelete = <String>[];
    
    for (var key in _box!.keys) {
      final keyStr = key.toString();
      if (keyStr.startsWith(_queuePrefix)) {
        keysToDelete.add(keyStr);
      }
    }
    
    for (var key in keysToDelete) {
      await _box!.delete(key);
    }
  }

  /// Get storage statistics.
  Map<String, dynamic> getStats() {
    if (!isInitialized) {
      return {
        'cached_items': 0,
        'queued_requests': 0,
        'total_size': 0,
      };
    }
    
    int cachedCount = 0;
    int queuedCount = 0;
    
    for (var key in _box!.keys) {
      final keyStr = key.toString();
      if (keyStr.startsWith(_cachePrefix)) {
        cachedCount++;
      } else if (keyStr.startsWith(_queuePrefix)) {
        queuedCount++;
      }
    }
    
    return {
      'cached_items': cachedCount,
      'queued_requests': queuedCount,
      'total_size': _box!.length,
    };
  }

  /// Close the storage box.
  Future<void> close() async {
    if (_box != null) {
      await _box!.close();
      _box = null;
      _initialized = false;
    }
  }
}

