import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
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
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }

  /// Check authentication status.
  Future<void> checkAuth() async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.getCurrentUser();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }
}

