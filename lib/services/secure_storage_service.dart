import "package:shared_preferences/shared_preferences.dart";

import "package:buzzer/app/initializable_service.dart";

/// Service that can be used to securely store and retrieve sensitive data.
class SecureStorageService with InitializableService {
  SharedPreferencesAsync? _preferences;

  @override
  Future<void> init() async {
    _preferences = SharedPreferencesAsync();
  }

  /// Determines if the key exists in secure storagem, but does not retrieve
  /// its value. Use [read] to get the value if it exists.
  Future<bool> hasKey(String key) async {
    return _preferences?.containsKey(key) ?? false;
  }

  /// Retrieves the value associated with the given key from secure storage.
  /// Returns `null` if the key does not exist.
  Future<String?> read(String key) async {
    return _preferences?.getString(key);
  }

  /// Writes a value to secure storage under the specified key.
  /// If the key already exists, it will be overwritten.
  Future<void> write(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  /// Deletes the value associated with the given key from secure storage.
  /// If the key does not exist, this operation will have no effect.
  Future<void> delete(String key) async {
    await _preferences?.remove(key);
  }
}
