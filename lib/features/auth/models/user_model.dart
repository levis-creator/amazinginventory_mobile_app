/// User model representing authenticated users.
/// 
/// This data class represents a user in the system with roles and permissions.
class UserModel {
  /// Unique identifier for the user
  final int id;
  
  /// User's full name
  final String name;
  
  /// User's email address
  final String email;
  
  /// Email verification timestamp
  final DateTime? emailVerifiedAt;
  
  /// User roles (when loaded)
  final List<String>? roles;
  
  /// User permissions (when loaded)
  final List<String>? permissions;
  
  /// Creation timestamp
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;

  /// Creates a new [UserModel] instance.
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.roles,
    this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a [UserModel] from JSON data (API response).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      roles: json['roles'] != null
          ? (json['roles'] as List).map((role) => role as String).toList()
          : null,
      permissions: json['permissions'] != null
          ? (json['permissions'] as List).map((perm) => perm as String).toList()
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the model to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'roles': roles,
      'permissions': permissions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Checks if user has a specific permission.
  bool hasPermission(String permission) {
    return permissions?.contains(permission) ?? false;
  }

  /// Checks if user has a specific role.
  bool hasRole(String role) {
    return roles?.contains(role) ?? false;
  }

  /// Checks if user is an admin.
  bool get isAdmin => hasRole('admin');
}

/// Authentication response model.
class AuthResponse {
  final String message;
  final UserModel user;
  final String accessToken;
  final String tokenType;

  AuthResponse({
    required this.message,
    required this.user,
    required this.accessToken,
    required this.tokenType,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
      'access_token': accessToken,
      'token_type': tokenType,
    };
  }
}

/// User permissions response model.
class PermissionsResponse {
  final List<String> permissions;

  PermissionsResponse({
    required this.permissions,
  });

  factory PermissionsResponse.fromJson(Map<String, dynamic> json) {
    return PermissionsResponse(
      permissions: (json['permissions'] as List)
          .map((perm) => perm as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permissions': permissions,
    };
  }
}

/// Permission check response model.
class PermissionCheckResponse {
  final String permission;
  final bool hasPermission;

  PermissionCheckResponse({
    required this.permission,
    required this.hasPermission,
  });

  factory PermissionCheckResponse.fromJson(Map<String, dynamic> json) {
    return PermissionCheckResponse(
      permission: json['permission'] as String,
      hasPermission: json['has_permission'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permission': permission,
      'has_permission': hasPermission,
    };
  }
}

