import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:senagat_mobile/src/features/register_confirmation/models/account_model.dart';

import '../typedefs.dart';
import 'key_value_storage_base.dart';

/// A service class for providing methods to store and retrieve key-value data
/// from common or secure storage.
class KeyValueStorageService {
  /// The name of auth token key
  static const _authTokenKey = 'authToken';

  /// The name of user model key
  static const _authUserKey = 'authUserKey';

  /// Instance of key-value storage base class
  final _keyValueStorage = KeyValueStorageBase();
  //
  // /// Returns last authenticated user
  // Account? getAuthUser() {
  //   final user = _keyValueStorage.getCommon<String>(_authUserKey);
  //   if (user == null) return null;
  //   return Account.fromJson(jsonDecode(user) as JSON);
  // }
  //
  // /// Sets the authenticated user to this value. Even though this method is
  // /// asynchronous, we don't care about it's completion which is why we don't
  // /// use `await` and let it execute in the background.
  // void setAuthUser(Account user) {
  //   _keyValueStorage.setCommon<String>(_authUserKey, jsonEncode(user.toJson()));
  // }

  /// Returns last authentication token
  Future<String> getAuthToken() async {
    debugPrint('[KeyValueStorageService] Getting auth token...');
    final token = await _keyValueStorage.getEncrypted(_authTokenKey) ?? '';
    debugPrint('[KeyValueStorageService] Retrieved auth token: ${token.isEmpty ? 'EMPTY' : '${token.length} chars'}');
    return token;
  }

  /// Sets the authentication token to this value. Even though this method is
  /// asynchronous, we don't care about it's completion which is why we don't
  /// use `await` and let it execute in the background.
  // void setAuthToken(String token) {
  //   _keyValueStorage.setEncrypted(_authTokenKey, token);
  // }

  Future<void> setAuthToken(String token) async {
    debugPrint('[KeyValueStorageService] Attempting to set auth token (${token.length} chars)');
    final success = await _keyValueStorage.setEncrypted(_authTokenKey, token);

    if (!success) {
      debugPrint('[KeyValueStorageService] FAILED to set auth token!');
      throw Exception('Failed to store auth token');
    }
    debugPrint('[KeyValueStorageService] Auth token set successfully');
  }

  // AccountModel? getAuthUser() {
  //   final user = _keyValueStorage.getCommon<String>(_authUserKey);
  //   if (user == null) return null;
  //   return AccountModel.fromJson(jsonDecode(user) as JSON);
  // }

  Future<AccountModel?> getAuthUser() async {
    debugPrint('[KeyValueStorageService] Getting auth user...');
    final user = await _keyValueStorage.getEncrypted(_authUserKey);
    
    if (user == null) {
      debugPrint('[KeyValueStorageService] Auth user is NULL');
      return null;
    }
    
    debugPrint('[KeyValueStorageService] Retrieved auth user JSON: ${user.length} chars');
    try {
      final decoded = jsonDecode(user) as JSON;
      debugPrint('[KeyValueStorageService] Decoded JSON successfully');
      final result = AccountModel.fromJson(decoded);
      debugPrint('[KeyValueStorageService] Parsed AccountModel: id=${result.id}, phone=${result.phoneNumber}');
      return result;
    } catch (e) {
      debugPrint('[KeyValueStorageService] ERROR parsing auth user: $e');
      rethrow;
    }
  }

  /// Sets the authenticated user to this value. Even though this method is
  /// asynchronous, we don't care about it's completion which is why we don't
  /// use `await` and let it execute in the background.
  // void setAuthUser(AccountModel user) {
  //   _keyValueStorage.setCommon<String>(_authUserKey, jsonEncode(user.toMap()));
  // }

  Future<void> setAuthUser(AccountModel user) async {
    debugPrint('[KeyValueStorageService] Attempting to set auth user: id=${user.id}, phone=${user.phoneNumber}');
    final userJson = jsonEncode(user.toMap());
    debugPrint('[KeyValueStorageService] Encoded user JSON: ${userJson.length} chars');
    
    final success = await _keyValueStorage.setEncrypted(
      _authUserKey,
      userJson,
    );

    if (!success) {
      debugPrint('[KeyValueStorageService] FAILED to set auth user!');
      throw Exception('Failed to store auth user');
    }
    debugPrint('[KeyValueStorageService] Auth user set successfully');
  }

  /// Resets the authentication. Even though these methods are asynchronous, we
  /// don't care about their completion which is why we don't use `await` and
  /// let them execute in the background.
  // void resetKeys() {
  //   _keyValueStorage
  //     ..clearCommon()
  //     ..clearEncrypted();
  // }

  Future<void> resetKeys() async {
    await _keyValueStorage.clearCommon();
    await _keyValueStorage.clearEncrypted();
  }
}
