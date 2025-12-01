import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_storage_service.dart';
import 'auth_state.dart';

/// Cubit for managing authentication state.
/// 
/// Handles login, registration, logout, and user state management.
/// Follows the same pattern as [AddProductCubit].
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ??
            AuthRepository(
              ApiService(),
              TokenStorageService(),
            ),
        super(const AuthInitial());

  /// Login user with email and password.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final authResponse = await _authRepository.login(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(authResponse.user));
    } on ApiException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  /// Register a new user.
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    List<int>? roles,
  }) async {
    emit(const AuthLoading());
    try {
      final authResponse = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        roles: roles,
      );
      emit(AuthAuthenticated(authResponse.user));
    } on ApiException catch (e) {
      emit(AuthError(e.getFormattedErrors() ?? e.message));
    } catch (e) {
      emit(AuthError('Registration failed: ${e.toString()}'));
    }
  }

  /// Logout current user.
  /// 
  /// Calls the logout endpoint to revoke the token on the server,
  /// then emits AuthUnauthenticated state to redirect to login screen.
  Future<void> logout() async {
    // Emit loading state to show loading screen
    emit(const AuthLoading());
    try {
      // Call repository logout which uses the logout endpoint
      await _authRepository.logout();
      // Emit unauthenticated state - BlocBuilder in main.dart will show login screen
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }

  /// Check authentication status.
  /// 
  /// First checks if a token exists in storage. If no token exists,
  /// immediately emits unauthenticated state. If token exists,
  /// validates it by fetching current user from API.
  Future<void> checkAuth() async {
    emit(const AuthLoading());
    
    try {
      // First, ensure token is loaded from storage
      final apiService = _authRepository.apiService;
      await apiService.loadTokenFromStorage();
      
      // Check if we have a token
      final tokenStorage = _authRepository.tokenStorage;
      final hasToken = await tokenStorage?.hasToken() ?? false;
      
      if (!hasToken) {
        // No token found, user is not authenticated
        emit(const AuthUnauthenticated());
        return;
      }
      
      // Token exists, validate it by fetching current user
      final user = await _authRepository.getCurrentUser();
      emit(AuthAuthenticated(user));
    } catch (e) {
      // Token might be invalid or expired, clear it and show login
      final tokenStorage = _authRepository.tokenStorage;
      await tokenStorage?.deleteToken();
      emit(const AuthUnauthenticated());
    }
  }
}

