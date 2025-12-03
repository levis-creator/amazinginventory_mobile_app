import '../models/user_model.dart';
import '../../../core/services/api_interface.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_storage_service.dart';

/// Repository for authentication operations.
/// 
/// Handles all authentication-related API calls including login, registration,
/// logout, and user information retrieval.
/// Follows repository pattern for clean separation of concerns.
class AuthRepository {
  final ApiInterface _apiService;
  final TokenStorageService _tokenStorage;

  AuthRepository(this._apiService, this._tokenStorage);

  /// Expose API service for token management
  ApiInterface get apiService => _apiService;

  /// Expose token storage for checking token existence
  TokenStorageService? get tokenStorage => _tokenStorage;

  /// Login user with email and password.
  /// 
  /// Returns [AuthResponse] containing user data and access token.
  /// Throws [ApiException] if credentials are invalid or request fails.
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        '/login',
        {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response);
      
      // Store token securely
      await _apiService.setToken(authResponse.accessToken);
      
      return authResponse;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Login failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Register a new user.
  /// 
  /// Returns [AuthResponse] containing user data and access token.
  /// Throws [ApiException] if validation fails or request fails.
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    List<int>? roles,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };

      if (roles != null && roles.isNotEmpty) {
        data['roles'] = roles;
      }

      final response = await _apiService.post('/register', data);
      final authResponse = AuthResponse.fromJson(response);
      
      // Store token securely
      await _apiService.setToken(authResponse.accessToken);
      
      return authResponse;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Registration failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Get current authenticated user.
  /// 
  /// Returns [UserModel] of the currently authenticated user.
  /// Throws [ApiException] if user is not authenticated or request fails.
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiService.get('/user');
      return UserModel.fromJson(response['user'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to get user: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Logout current user.
  /// 
  /// Calls the logout endpoint (POST /api/v1/logout) to revoke the current
  /// access token on the server, then clears the token from local storage.
  /// Throws [ApiException] if request fails.
  Future<void> logout() async {
    try {
      // Call the logout endpoint to revoke token on server
      await _apiService.post('/logout', {});
      
      // Clear token from local storage after successful server logout
      await _apiService.setToken(null);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Logout failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}

