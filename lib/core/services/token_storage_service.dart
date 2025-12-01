import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing and retrieving authentication tokens.
/// 
/// Uses FlutterSecureStorage which stores data in:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences with AES encryption
/// 
/// This ensures tokens are stored securely and not accessible to other apps.
class TokenStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const String _tokenKey = 'auth_token';

  /// Save authentication token securely.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Retrieve authentication token.
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Delete authentication token.
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Check if user is logged in (has token).
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all stored data.
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

