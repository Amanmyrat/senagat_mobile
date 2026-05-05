import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageBase {
  static SharedPreferences? _sharedPrefs;

  static const MethodChannel _secureChannel =
  MethodChannel('senagat_secure_storage');

  static KeyValueStorageBase? _instance;

  factory KeyValueStorageBase() => _instance ?? const KeyValueStorageBase._();

  const KeyValueStorageBase._();

  static Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  void _ensureInitialized() {
    if (_sharedPrefs == null) {
      throw StateError('KeyValueStorageBase is not initialized');
    }
  }

  T? getCommon<T>(String key) {
    _ensureInitialized();

    try {
      switch (T) {
        case String:
          return _sharedPrefs!.getString(key) as T?;
        case int:
          return _sharedPrefs!.getInt(key) as T?;
        case bool:
          return _sharedPrefs!.getBool(key) as T?;
        case double:
          return _sharedPrefs!.getDouble(key) as T?;
        default:
          return _sharedPrefs!.get(key) as T?;
      }
    } catch (ex) {
      if (kDebugMode) {
        debugPrint('Common storage read error: $ex');
      }
      return null;
    }
  }

  Future<String?> getEncrypted(String key) async {
    try {
      return await _secureChannel.invokeMethod<String>(
        'read',
        {'key': key},
      );
    } on PlatformException catch (ex) {
      if (kDebugMode) {
        debugPrint('Secure storage read error: ${ex.message}');
      }
      return null;
    }
  }

  Future<bool> setCommon<T>(String key, T value) {
    _ensureInitialized();

    switch (T) {
      case String:
        return _sharedPrefs!.setString(key, value as String);
      case int:
        return _sharedPrefs!.setInt(key, value as int);
      case bool:
        return _sharedPrefs!.setBool(key, value as bool);
      case double:
        return _sharedPrefs!.setDouble(key, value as double);
      default:
        return _sharedPrefs!.setString(key, value as String);
    }
  }

  Future<bool> setEncrypted(String key, String value) async {
    try {
      await _secureChannel.invokeMethod<void>(
        'write',
        {
          'key': key,
          'value': value,
        },
      );
      return true;
    } on PlatformException catch (ex) {
      if (kDebugMode) {
        debugPrint('Secure storage write error: ${ex.message}');
      }
      return false;
    }
  }

  Future<bool> clearCommon() async {
    _ensureInitialized();
    return _sharedPrefs!.clear();
  }

  Future<bool> clearEncrypted() async {
    try {
      await _secureChannel.invokeMethod<void>('deleteAll');
      return true;
    } on PlatformException catch (ex) {
      if (kDebugMode) {
        debugPrint('Secure storage clear error: ${ex.message}');
      }
      return false;
    }
  }
}