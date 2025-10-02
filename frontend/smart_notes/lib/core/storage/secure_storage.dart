import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

abstract class SecureStorage {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setObject(String key, Map<String, dynamic> value);
  Future<Map<String, dynamic>?> getObject(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
  Future<bool> containsKey(String key);
  Future<Map<String, String>> getAllItems();
}

class SecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage secureStorage;

  SecureStorageImpl(this.secureStorage);

  @override
  Future<void> setString(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> getString(String key) async {
    return await secureStorage.read(key: key);
  }

  @override
  Future<void> setObject(String key, Map<String, dynamic> value) async {
    final jsonString = json.encode(value);
    await secureStorage.write(key: key, value: jsonString);
  }

  @override
  Future<Map<String, dynamic>?> getObject(String key) async {
    final jsonString = await secureStorage.read(key: key);
    if (jsonString == null) return null;
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> delete(String key) async {
    await secureStorage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await secureStorage.deleteAll();
  }

  @override
  Future<bool> containsKey(String key) async {
    return await secureStorage.containsKey(key: key);
  }

  @override
  Future<Map<String, String>> getAllItems() async {
    return await secureStorage.readAll();
  }
}
