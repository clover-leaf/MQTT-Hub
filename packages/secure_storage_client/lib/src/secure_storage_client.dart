import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// {@template secure_storage_client}
/// The secure storage client
/// {@endtemplate}
class SecureStorageClient {
  /// {@macro secure_storage_client}
  SecureStorageClient({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  /// read value by key
  Future<String?> readSecureData(String key) async {
    return _secureStorage.read(
      key: key,
      aOptions: _getAndroidOptions(),
    );
  }

  /// write key and value to storage
  Future<void> writeSecureData(String key, String value) async {
    await _secureStorage.write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
    );
  }

  /// delete key
  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key, aOptions: _getAndroidOptions());
  }

  /// read all pair
  Future<Map<String, String>> readAll() async {
    return _secureStorage.readAll(
      aOptions: _getAndroidOptions(),
    );
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
