import "dart:convert";

import "package:logger/logger.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/app/initializable_service.dart";
import "package:buzzer/model/auth/stored_identity.dart";

/// Service that can be used to securely store and retrieve sensitive data.
class SecureStorageService with InitializableService {
  final Logger _logger = getLogger("SecureStorageService");

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

  /// Stores the provided [StoredIdentity] in secure storage.
  Future<void> storeIdentity(StoredIdentity identity) async {
    final jsonEncoded = json.encode(identity.toJson());
    final base64Encoded = base64.encode(utf8.encode(jsonEncoded));

    await write("identity", base64Encoded);

    _logger.i("Stored identity in secure storage");
  }

  /// Retrieves the stored [StoredIdentity] from secure storage.
  /// Returns `null` if the identity is not found.
  Future<StoredIdentity?> retrieveIdentity() async {
    final base64Encoded = await read("identity");

    if (base64Encoded == null) {
      return null;
    }

    final jsonEncoded = utf8.decode(base64.decode(base64Encoded));
    final jsonMap = json.decode(jsonEncoded);

    if (jsonMap is! Map<String, dynamic>) {
      return null;
    }

    _logger.i("Retrieved stored identity from secure storage");
    return StoredIdentity.fromJson(jsonMap);
  }

  /// Deletes the stored [StoredIdentity] from secure storage.
  Future<void> deleteIdentity() async {
    await delete("identity");

    _logger.i("Deleted stored identity from secure storage");
  }
}
