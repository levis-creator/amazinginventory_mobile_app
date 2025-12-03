import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for monitoring network connectivity status.
/// 
/// Provides real-time updates about network connectivity and allows
/// checking the current connection status.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _connectionController;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isConnected = true;

  ConnectivityService() {
    _connectionController = StreamController<bool>.broadcast();
    _init();
  }

  /// Initialize connectivity monitoring.
  Future<void> _init() async {
    // Check initial connectivity status
    final result = await _connectivity.checkConnectivity();
    _isConnected = _hasConnection(result);
    _connectionController?.add(_isConnected);

    // Listen for connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final wasConnected = _isConnected;
        _isConnected = _hasConnection(results);
        
        // Only emit if status changed
        if (wasConnected != _isConnected) {
          _connectionController?.add(_isConnected);
        }
      },
    );
  }

  /// Check if any of the connectivity results indicate a connection.
  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => 
      result != ConnectivityResult.none
    );
  }

  /// Stream of connectivity status changes.
  /// 
  /// Emits `true` when connected, `false` when disconnected.
  Stream<bool> get onConnectivityChanged {
    return _connectionController?.stream ?? 
           Stream.value(_isConnected);
  }

  /// Check if currently connected to the internet.
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    _isConnected = _hasConnection(result);
    return _isConnected;
  }

  /// Get current connectivity status (synchronous).
  bool get currentStatus => _isConnected;

  /// Dispose resources.
  void dispose() {
    _subscription?.cancel();
    _connectionController?.close();
    _connectionController = null;
  }
}

