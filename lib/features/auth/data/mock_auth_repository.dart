import '../models/user_model.dart';

/// Mock repository for authentication data.
/// 
/// Provides sample authentication data matching the Laravel API structure.
/// This is used for development and testing when the API is not available.
class MockAuthRepository {
  /// Mock user data for testing.
  static final UserModel _mockUser = UserModel(
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    emailVerifiedAt: DateTime.now().subtract(const Duration(days: 30)),
    roles: ['admin'],
    permissions: [
      'view users',
      'create users',
      'update users',
      'delete users',
      'view roles',
      'create roles',
      'update roles',
      'delete roles',
      'view permissions',
      'create permissions',
      'update permissions',
      'delete permissions',
    ],
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
    updatedAt: DateTime.now(),
  );

  /// Mock access token.
  static const String _mockToken = '1|mock_token_for_development_only';

  /// Simulates user login.
  /// 
  /// In production, this should make an actual API call to `/api/v1/login`.
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock validation
    if (email == _mockUser.email && password == 'password123') {
      return AuthResponse(
        message: 'Login successful',
        user: _mockUser,
        accessToken: _mockToken,
        tokenType: 'Bearer',
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  /// Simulates user registration.
  /// 
  /// In production, this should make an actual API call to `/api/v1/register`.
  static Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    List<int>? roles,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Mock validation
    if (password != passwordConfirmation) {
      throw Exception('Password confirmation does not match');
    }

    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters');
    }

    // Create new user
    final newUser = UserModel(
      id: 2,
      name: name,
      email: email,
      emailVerifiedAt: DateTime.now(),
      roles: ['user'],
      permissions: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return AuthResponse(
      message: 'User registered successfully',
      user: newUser,
      accessToken: '2|mock_token_for_new_user',
      tokenType: 'Bearer',
    );
  }

  /// Gets the current authenticated user.
  /// 
  /// In production, this should make an actual API call to `/api/v1/user`.
  static Future<UserModel> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockUser;
  }

  /// Gets user permissions.
  /// 
  /// In production, this should make an actual API call to `/api/v1/user/permissions`.
  static Future<PermissionsResponse> getUserPermissions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return PermissionsResponse(
      permissions: _mockUser.permissions ?? [],
    );
  }

  /// Checks if user has a specific permission.
  /// 
  /// In production, this should make an actual API call to `/api/v1/user/check-permission`.
  static Future<PermissionCheckResponse> checkPermission(String permission) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return PermissionCheckResponse(
      permission: permission,
      hasPermission: _mockUser.hasPermission(permission),
    );
  }

  /// Simulates user logout.
  /// 
  /// In production, this should make an actual API call to `/api/v1/logout`.
  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real implementation, this would invalidate the token on the server
  }
}

