import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class LocalStorage {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> setDouble(String key, double value);
  Future<double?> getDouble(String key);
  Future<void> setStringList(String key, List<String> value);
  Future<List<String>?> getStringList(String key);
  Future<void> setObject(String key, Map<String, dynamic> value);
  Future<Map<String, dynamic>?> getObject(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences sharedPreferences;

  LocalStorageImpl(this.sharedPreferences);

  @override
  Future<void> setString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await sharedPreferences.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return sharedPreferences.getInt(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await sharedPreferences.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return sharedPreferences.getBool(key);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    await sharedPreferences.setDouble(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    return sharedPreferences.getDouble(key);
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    await sharedPreferences.setStringList(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    return sharedPreferences.getStringList(key);
  }

  @override
  Future<void> setObject(String key, Map<String, dynamic> value) async {
    final jsonString = json.encode(value);
    await sharedPreferences.setString(key, jsonString);
  }

  @override
  Future<Map<String, dynamic>?> getObject(String key) async {
    final jsonString = sharedPreferences.getString(key);
    if (jsonString == null) return null;
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> remove(String key) async {
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await sharedPreferences.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return sharedPreferences.containsKey(key);
  }
}
