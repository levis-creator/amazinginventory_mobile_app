import 'dart:async';
import 'api_service.dart';
import 'connectivity_service.dart';
import 'offline_storage_service.dart';

/// Service for syncing offline requests when connection is restored.
/// 
/// Monitors connectivity and automatically syncs queued requests
/// when the device comes back online.
class SyncService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final OfflineStorageService _offlineStorage;
  
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isSyncing = false;
  Timer? _syncTimer;

  SyncService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
    required OfflineStorageService offlineStorage,
  })  : _apiService = apiService,
        _connectivityService = connectivityService,
        _offlineStorage = offlineStorage {
    _init();
  }

  /// Initialize sync service and start monitoring connectivity.
  void _init() {
    // Listen for connectivity changes
    _connectivitySubscription = _connectivityService.onConnectivityChanged.listen(
      (isConnected) {
        if (isConnected) {
          // Connection restored, sync queued requests
          syncQueuedRequests();
        }
      },
    );

    // Periodic sync check (every 30 seconds when online)
    _syncTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        if (_connectivityService.currentStatus && !_isSyncing) {
          syncQueuedRequests();
        }
      },
    );
  }

  /// Sync all queued requests.
  /// 
  /// Processes queued requests in order and removes them after successful sync.
  Future<void> syncQueuedRequests() async {
    if (_isSyncing) return;
    
    // Check if online
    final isConnected = await _connectivityService.isConnected();
    if (!isConnected) return;
    
    _isSyncing = true;
    
    try {
      final queuedRequests = _offlineStorage.getQueuedRequests();
      
      if (queuedRequests.isEmpty) {
        _isSyncing = false;
        return;
      }
      
      // Process each queued request
      for (final request in queuedRequests) {
        final requestId = request['id'] as String;
        final method = request['method'] as String;
        final endpoint = request['endpoint'] as String;
        final data = request['data'] as Map<String, dynamic>?;
        
        try {
          // Attempt to sync the request
          switch (method.toUpperCase()) {
            case 'POST':
              await _apiService.post(endpoint, data ?? {});
              break;
            case 'PUT':
              await _apiService.put(endpoint, data ?? {});
              break;
            case 'DELETE':
              await _apiService.delete(endpoint);
              break;
            case 'GET':
              // GET requests don't need to be queued, skip
              await _offlineStorage.removeQueuedRequest(requestId);
              continue;
            default:
              // Unknown method, remove from queue
              await _offlineStorage.removeQueuedRequest(requestId);
              continue;
          }
          
          // Successfully synced, remove from queue
          await _offlineStorage.removeQueuedRequest(requestId);
        } catch (e) {
          // Failed to sync, keep in queue for next attempt
          // Could implement retry logic with max attempts here
          print('Failed to sync request $requestId: $e');
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Manually trigger sync (useful for pull-to-refresh).
  Future<void> manualSync() async {
    await syncQueuedRequests();
  }

  /// Get sync status.
  bool get isSyncing => _isSyncing;

  /// Get number of queued requests.
  int get queuedRequestCount {
    return _offlineStorage.getQueuedRequests().length;
  }

  /// Dispose resources.
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
  }
}

