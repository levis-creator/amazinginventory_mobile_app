import 'package:get_it/get_it.dart';
import '../services/api_service.dart';
import '../services/api_interface.dart';
import '../services/token_storage_service.dart';
import '../services/connectivity_service.dart';
import '../services/offline_storage_service.dart';
import '../services/sync_service.dart';
import '../services/offline_api_service.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/dashboard/data/dashboard_repository.dart';
import '../../features/dashboard/cubit/dashboard_cubit.dart';
import '../../features/inventory/data/product_repository.dart';
import '../../features/inventory/cubit/product_cubit.dart';
import '../../features/categories/data/category_repository.dart';
import '../../features/categories/cubit/category_cubit.dart';

/// Service locator for dependency injection.
/// 
/// Provides a centralized way to register and retrieve dependencies.
/// This follows the Dependency Inversion Principle and makes testing easier.
final getIt = GetIt.instance;

/// Initialize all dependencies.
Future<void> setupServiceLocator() async {
  // Core Services
  getIt.registerLazySingleton<TokenStorageService>(() => TokenStorageService());
  
  // Initialize offline storage first (required for other services)
  final offlineStorage = OfflineStorageService();
  await offlineStorage.init();
  getIt.registerLazySingleton<OfflineStorageService>(() => offlineStorage);
  
  // Connectivity service
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  
  // Base API service (used by offline API service)
  final tokenStorage = getIt<TokenStorageService>();
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(tokenStorage: tokenStorage),
  );
  
  // Sync service (requires API service, connectivity, and offline storage)
  getIt.registerLazySingleton<SyncService>(
    () => SyncService(
      apiService: getIt<ApiService>(),
      connectivityService: getIt<ConnectivityService>(),
      offlineStorage: getIt<OfflineStorageService>(),
    ),
  );
  
  // Offline-enabled API service (wraps base API service)
  getIt.registerLazySingleton<OfflineApiService>(
    () => OfflineApiService(
      apiService: getIt<ApiService>(),
      connectivityService: getIt<ConnectivityService>(),
      offlineStorage: getIt<OfflineStorageService>(),
      syncService: getIt<SyncService>(),
    ),
  );

  // Repositories - Use OfflineApiService for offline support
  // Note: OfflineApiService has the same interface as ApiService, so repositories work as-is
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      getIt<OfflineApiService>(),
      getIt<TokenStorageService>(),
    ),
  );

  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepository(
      getIt<OfflineApiService>(),
    ),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(
      getIt<OfflineApiService>(),
    ),
  );

  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepository(
      getIt<OfflineApiService>(),
    ),
  );

  // Cubits/State Management
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      authRepository: getIt<AuthRepository>(),
    ),
  );

  // Register DashboardCubit as singleton to preserve state across navigation
  getIt.registerLazySingleton<DashboardCubit>(
    () => DashboardCubit(
      dashboardRepository: getIt<DashboardRepository>(),
    ),
  );

  getIt.registerFactory<ProductCubit>(
    () => ProductCubit(
      productRepository: getIt<ProductRepository>(),
    ),
  );

  getIt.registerFactory<CategoryCubit>(
    () => CategoryCubit(
      categoryRepository: getIt<CategoryRepository>(),
    ),
  );

  // Load token from storage and set it in offline API service
  final token = await tokenStorage.getToken();
  if (token != null) {
    await getIt<OfflineApiService>().setToken(token);
    print('✅ Authentication token loaded from storage');
  } else {
    print('⚠️ No authentication token found in storage');
  }
  
  // Register ApiInterface alias for backward compatibility
  getIt.registerLazySingleton<ApiInterface>(() => getIt<OfflineApiService>());
}

