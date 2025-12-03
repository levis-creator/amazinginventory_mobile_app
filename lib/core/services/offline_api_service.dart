import 'package:uuid/uuid.dart';
import 'api_service.dart';
import 'api_interface.dart';
import 'connectivity_service.dart';
import 'offline_storage_service.dart';
import 'sync_service.dart';

/// Offline-enabled API service wrapper.
/// 
/// Extends the base ApiService with offline capabilities:
/// - Caches GET responses for offline access
/// - Queues POST/PUT/DELETE requests when offline
/// - Automatically syncs queued requests when online
/// - Falls back to cached data when offline
class OfflineApiService implements ApiInterface {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final OfflineStorageService _offlineStorage;
  final SyncService _syncService;
  final Uuid _uuid = const Uuid();

  // Default cache TTL: 5 minutes (300 seconds)
  static const int defaultCacheTTL = 300;

  OfflineApiService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
    required OfflineStorageService offlineStorage,
    required SyncService syncService,
  })  : _apiService = apiService,
        _connectivityService = connectivityService,
        _offlineStorage = offlineStorage,
        _syncService = syncService;

  /// Base URL for API requests (delegates to underlying API service)
  @override
  String get baseUrlInstance => _apiService.baseUrlInstance;

  /// Check if currently online.
  Future<bool> get isOnline async {
    return await _connectivityService.isConnected();
  }

  /// Generic GET request with offline support.
  /// 
  /// - If online: Fetches from API and caches the response
  /// - If offline: Returns cached data if available
  /// 
  /// [endpoint] API endpoint path
  /// [queryParams] Query parameters
  /// [timeout] Request timeout (for compatibility with ApiInterface)
  /// [cacheTTL] Cache time-to-live in seconds (default: 5 minutes)
  /// [forceRefresh] If true, bypasses cache even when offline
  @override
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Duration? timeout,
    int? cacheTTL,
    bool forceRefresh = false,
  }) async {
    final cacheKey = _buildCacheKey(endpoint, queryParams);
    
    // Try to get from cache first (if not forcing refresh)
    if (!forceRefresh) {
      final cachedData = _offlineStorage.getCachedData(cacheKey);
      if (cachedData != null) {
        // Check if we're offline - if so, return cached data immediately
        final online = await isOnline;
        if (!online) {
          return cachedData;
        }
        // If online, we'll fetch fresh data but cached data is available as fallback
      }
    }

    // Try to fetch from API
    try {
      final online = await isOnline;
      if (!online && !forceRefresh) {
        // Offline and no cached data, or forcing refresh while offline
        final cachedData = _offlineStorage.getCachedData(cacheKey);
        if (cachedData != null) {
          return cachedData;
        }
        throw ApiException(
          message: 'No internet connection and no cached data available',
          statusCode: 0,
        );
      }

      // Online - fetch fresh data
      final response = await _apiService.get(
        endpoint,
        queryParams: queryParams,
        timeout: timeout,
      );

      // Cache the response
      await _offlineStorage.cacheData(
        cacheKey,
        response,
        ttl: cacheTTL ?? defaultCacheTTL,
      );

      return response;
    } on ApiException catch (e) {
      // If request failed but we have cached data, return it
      if (e.statusCode == 0 || e.statusCode >= 500) {
        final cachedData = _offlineStorage.getCachedData(cacheKey);
        if (cachedData != null) {
          return cachedData;
        }
      }
      rethrow;
    } catch (e) {
      // Network error - try to return cached data
      final cachedData = _offlineStorage.getCachedData(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw ApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Generic POST request with offline support.
  /// 
  /// - If online: Sends request immediately
  /// - If offline: Queues request for later sync
  /// 
  /// [endpoint] API endpoint path
  /// [data] Request data
  /// [queueIfOffline] If true, queues request when offline (default: true)
  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool queueIfOffline = true,
  }) async {
    final online = await isOnline;

    if (!online && queueIfOffline) {
      // Queue the request
      final requestId = _uuid.v4();
      await _offlineStorage.queueRequest(
        requestId: requestId,
        method: 'POST',
        endpoint: endpoint,
        data: data,
      );

      // Return a success response indicating the request was queued
      return {
        'message': 'Request queued for sync when online',
        'queued': true,
        'request_id': requestId,
      };
    }

    // Online - send request immediately
    try {
      return await _apiService.post(endpoint, data);
    } catch (e) {
      // If request fails and we're still online, rethrow
      // If we go offline during request, queue it
      if (queueIfOffline && !(await isOnline)) {
        final requestId = _uuid.v4();
        await _offlineStorage.queueRequest(
          requestId: requestId,
          method: 'POST',
          endpoint: endpoint,
          data: data,
        );
        return {
          'message': 'Request queued for sync when online',
          'queued': true,
          'request_id': requestId,
        };
      }
      rethrow;
    }
  }

  /// Generic PUT request with offline support.
  /// 
  /// - If online: Sends request immediately
  /// - If offline: Queues request for later sync
  /// 
  /// [endpoint] API endpoint path
  /// [data] Request data
  /// [queueIfOffline] If true, queues request when offline (default: true)
  @override
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    bool queueIfOffline = true,
  }) async {
    final online = await isOnline;

    if (!online && queueIfOffline) {
      // Queue the request
      final requestId = _uuid.v4();
      await _offlineStorage.queueRequest(
        requestId: requestId,
        method: 'PUT',
        endpoint: endpoint,
        data: data,
      );

      return {
        'message': 'Request queued for sync when online',
        'queued': true,
        'request_id': requestId,
      };
    }

    // Online - send request immediately
    try {
      final response = await _apiService.put(endpoint, data);
      
      // Invalidate cache for this endpoint
      await _invalidateCache(endpoint);
      
      return response;
    } catch (e) {
      if (queueIfOffline && !(await isOnline)) {
        final requestId = _uuid.v4();
        await _offlineStorage.queueRequest(
          requestId: requestId,
          method: 'PUT',
          endpoint: endpoint,
          data: data,
        );
        return {
          'message': 'Request queued for sync when online',
          'queued': true,
          'request_id': requestId,
        };
      }
      rethrow;
    }
  }

  /// Generic DELETE request with offline support.
  /// 
  /// - If online: Sends request immediately
  /// - If offline: Queues request for later sync
  /// 
  /// [endpoint] API endpoint path
  /// [queueIfOffline] If true, queues request when offline (default: true)
  @override
  Future<void> delete(
    String endpoint, {
    bool queueIfOffline = true,
  }) async {
    final online = await isOnline;

    if (!online && queueIfOffline) {
      // Queue the request
      final requestId = _uuid.v4();
      await _offlineStorage.queueRequest(
        requestId: requestId,
        method: 'DELETE',
        endpoint: endpoint,
        data: null,
      );
      return;
    }

    // Online - send request immediately
    try {
      await _apiService.delete(endpoint);
      
      // Invalidate cache for this endpoint
      await _invalidateCache(endpoint);
    } catch (e) {
      if (queueIfOffline && !(await isOnline)) {
        final requestId = _uuid.v4();
        await _offlineStorage.queueRequest(
          requestId: requestId,
          method: 'DELETE',
          endpoint: endpoint,
          data: null,
        );
        return;
      }
      rethrow;
    }
  }

  /// Build cache key from endpoint and query parameters.
  String _buildCacheKey(String endpoint, Map<String, dynamic>? queryParams) {
    if (queryParams == null || queryParams.isEmpty) {
      return endpoint;
    }
    
    // Sort query params for consistent cache keys
    final sortedParams = Map.fromEntries(
      queryParams.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    
    final queryString = sortedParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    
    return '$endpoint?$queryString';
  }

  /// Invalidate cache for an endpoint (and related endpoints).
  Future<void> _invalidateCache(String endpoint) async {
    // Remove exact match
    await _offlineStorage.removeCachedData(endpoint);
    
    // Also remove any cached data with query params for this endpoint
    // (This is a simple implementation - could be enhanced)
    // Note: For a more robust solution, we'd need to track cache keys
    // For now, we'll rely on TTL expiration
  }

  /// Clear all cached data.
  Future<void> clearCache() async {
    await _offlineStorage.clearCache();
  }

  /// Get sync status.
  bool get isSyncing => _syncService.isSyncing;

  /// Get number of queued requests.
  int get queuedRequestCount => _syncService.queuedRequestCount;

  /// Manually trigger sync.
  Future<void> sync() async {
    await _syncService.manualSync();
  }

  /// Set authentication token (delegates to underlying API service).
  @override
  Future<void> setToken(String? token) async {
    await _apiService.setToken(token);
  }

  /// Load token from storage (delegates to underlying API service).
  @override
  Future<void> loadTokenFromStorage() async {
    await _apiService.loadTokenFromStorage();
  }
}

