import 'package:get_it/get_it.dart';
import '../services/api_service.dart';
import '../services/token_storage_service.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/dashboard/data/dashboard_repository.dart';
import '../../features/dashboard/cubit/dashboard_cubit.dart';

/// Service locator for dependency injection.
/// 
/// Provides a centralized way to register and retrieve dependencies.
/// This follows the Dependency Inversion Principle and makes testing easier.
final getIt = GetIt.instance;

/// Initialize all dependencies.
Future<void> setupServiceLocator() async {
  // Services
  getIt.registerLazySingleton<TokenStorageService>(() => TokenStorageService());
  
  // Initialize API service with token storage
  final tokenStorage = getIt<TokenStorageService>();
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(tokenStorage: tokenStorage),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      getIt<ApiService>(),
      getIt<TokenStorageService>(),
    ),
  );

  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepository(
      getIt<ApiService>(),
    ),
  );

  // Cubits/State Management
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(
      dashboardRepository: getIt<DashboardRepository>(),
    ),
  );

  // Load token from storage and set it in API service
  final token = await tokenStorage.getToken();
  if (token != null) {
    await getIt<ApiService>().setToken(token);
  }
}

