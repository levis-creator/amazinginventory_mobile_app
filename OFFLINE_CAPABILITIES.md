# Offline Capabilities Documentation

## Overview

The Amazing Inventory Flutter app now supports full offline capabilities, allowing users to:
- View cached data when offline
- Queue create/update/delete operations for automatic sync when online
- Automatically sync queued requests when connection is restored
- Access recently viewed data without internet connection

## Architecture

### Core Services

1. **ConnectivityService** (`lib/core/services/connectivity_service.dart`)
   - Monitors network connectivity status
   - Provides real-time connectivity updates via streams
   - Detects when device goes online/offline

2. **OfflineStorageService** (`lib/core/services/offline_storage_service.dart`)
   - Uses Hive for fast local data storage
   - Caches API responses with optional TTL (time-to-live)
   - Queues offline requests for later sync
   - Manages cache expiration and cleanup

3. **SyncService** (`lib/core/services/sync_service.dart`)
   - Monitors connectivity changes
   - Automatically syncs queued requests when online
   - Processes requests in order (FIFO)
   - Periodic sync check (every 30 seconds)

4. **OfflineApiService** (`lib/core/services/offline_api_service.dart`)
   - Wraps the base ApiService with offline capabilities
   - Implements the same interface as ApiService (drop-in replacement)
   - Handles caching for GET requests
   - Queues POST/PUT/DELETE requests when offline

## How It Works

### GET Requests (Read Operations)

1. **When Online:**
   - Fetches fresh data from API
   - Caches the response locally (default TTL: 5 minutes)
   - Returns the fresh data

2. **When Offline:**
   - Checks local cache first
   - Returns cached data if available and not expired
   - Throws error if no cached data available

### POST/PUT/DELETE Requests (Write Operations)

1. **When Online:**
   - Sends request immediately to API
   - Invalidates related cache entries
   - Returns API response

2. **When Offline:**
   - Queues the request locally
   - Returns success response indicating request was queued
   - Request is automatically synced when connection is restored

### Automatic Sync

- Sync service monitors connectivity 24/7
- When connection is restored, automatically processes queued requests
- Requests are processed in order (oldest first)
- Failed requests remain in queue for retry
- Periodic sync check every 30 seconds (when online)

## Usage

### For Developers

The offline capabilities are **automatically enabled** for all repositories. No code changes are required in your repositories or cubits - they work exactly as before.

#### Accessing Offline API Service

```dart
// Get offline API service from service locator
final offlineApiService = getIt<OfflineApiService>();

// Check if online
final isOnline = await offlineApiService.isOnline;

// Manually trigger sync
await offlineApiService.sync();

// Get number of queued requests
final queuedCount = offlineApiService.queuedRequestCount;

// Clear cache
await offlineApiService.clearCache();
```

#### Customizing Cache TTL

By default, cached data expires after 5 minutes. You can customize this per request:

```dart
// Cache for 1 hour (3600 seconds)
final response = await offlineApiService.get(
  '/products',
  cacheTTL: 3600,
);

// Force refresh (bypass cache)
final response = await offlineApiService.get(
  '/products',
  forceRefresh: true,
);
```

### For Users

Users don't need to do anything special - the app works automatically:

1. **Viewing Data Offline:**
   - Open the app while offline
   - Previously viewed data (products, categories, dashboard) will load from cache
   - Data is shown with a note that it may be outdated

2. **Creating/Updating/Deleting Offline:**
   - Perform any create/update/delete operation while offline
   - The operation is queued automatically
   - When connection is restored, operations sync automatically
   - User receives confirmation when sync completes

3. **Manual Sync:**
   - Pull to refresh on any list screen
   - This triggers a manual sync of queued requests

## Configuration

### Cache Settings

Default cache TTL: **5 minutes** (300 seconds)

You can change this in `OfflineApiService`:
```dart
static const int defaultCacheTTL = 300; // Change to desired seconds
```

### Sync Settings

- **Automatic sync check interval:** 30 seconds
- **Sync on connectivity change:** Enabled
- **Request retry:** Enabled (failed requests stay in queue)

## Dependencies

The following packages were added for offline support:

- `connectivity_plus: ^6.0.5` - Network connectivity detection
- `hive: ^2.2.3` - Fast local NoSQL database
- `hive_flutter: ^1.1.0` - Hive Flutter integration
- `path_provider: ^2.1.2` - Path provider for local storage
- `uuid: ^4.5.1` - UUID generation for request IDs

## Storage

### Cache Storage

- Location: Hive box named `offline_storage`
- Keys: `cache_<endpoint>?<query_params>`
- Metadata: `meta_<endpoint>?<query_params>` (stores timestamp and TTL)

### Queue Storage

- Location: Same Hive box
- Keys: `queue_<request_id>`
- Format: JSON with method, endpoint, data, and timestamp

## Limitations

1. **Cache Expiration:** Cached data expires after TTL (default 5 minutes). Users need to be online to refresh data.

2. **Queue Size:** No hard limit, but very large queues may impact performance. Consider implementing queue size limits for production.

3. **Conflict Resolution:** No automatic conflict resolution. If a resource is modified both offline and online, the last write wins.

4. **Authentication:** Login/register operations require online connection (not queued for security reasons).

## Future Enhancements

Potential improvements for future versions:

1. **Conflict Resolution:** Implement optimistic locking or versioning
2. **Queue Size Limits:** Add maximum queue size with oldest-first eviction
3. **Selective Caching:** Allow per-endpoint cache configuration
4. **Background Sync:** Use WorkManager for background sync on Android
5. **Sync Status UI:** Show sync progress and queued request count to users
6. **Offline Indicators:** Visual indicators showing when data is from cache

## Troubleshooting

### Cache Not Working

1. Ensure Hive is initialized (done automatically in service locator)
2. Check if storage permissions are granted
3. Verify cache TTL hasn't expired

### Requests Not Syncing

1. Check connectivity status: `await connectivityService.isConnected()`
2. Verify sync service is running: `syncService.isSyncing`
3. Check queued requests: `offlineStorage.getQueuedRequests()`

### Storage Issues

1. Clear cache: `await offlineStorage.clearCache()`
2. Clear queue: `await offlineStorage.clearQueue()`
3. Check storage stats: `offlineStorage.getStats()`

## Testing

To test offline capabilities:

1. **Enable Airplane Mode** on your device
2. **Open the app** - should load cached data
3. **Create/Update/Delete** items - should queue successfully
4. **Disable Airplane Mode** - requests should sync automatically
5. **Check sync status** - verify all requests completed

## Support

For issues or questions about offline capabilities, please refer to:
- Service implementations in `lib/core/services/`
- Repository examples in `lib/features/*/data/`
- Service locator configuration in `lib/core/di/service_locator.dart`

