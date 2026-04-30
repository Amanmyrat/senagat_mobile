import 'dart:convert';

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
    return await _keyValueStorage.getEncrypted(_authTokenKey) ?? '';
  }

  /// Sets the authentication token to this value. Even though this method is
  /// asynchronous, we don't care about it's completion which is why we don't
  /// use `await` and let it execute in the background.
  // void setAuthToken(String token) {
  //   _keyValueStorage.setEncrypted(_authTokenKey, token);
  // }

  Future<void> setAuthToken(String token) async {
    final success = await _keyValueStorage.setEncrypted(_authTokenKey, token);

    if (!success) {
      throw Exception('Failed to store auth token');
    }
  }

  AccountModel? getAuthUser() {
    final user = _keyValueStorage.getCommon<String>(_authUserKey);
    if (user == null) return null;
    return AccountModel.fromJson(jsonDecode(user) as JSON);
  }

  // AccountModel? getAuthUser() async {
  //   final user = await _keyValueStorage.getEncrypted(_authUserKey);
  //   if (user == null) return null;
  //   return AccountModel.fromJson(jsonDecode(user));
  // }

  /// Sets the authenticated user to this value. Even though this method is
  /// asynchronous, we don't care about it's completion which is why we don't
  /// use `await` and let it execute in the background.
  // void setAuthUser(AccountModel user) {
  //   _keyValueStorage.setCommon<String>(_authUserKey, jsonEncode(user.toMap()));
  // }
  Future<void> setAuthUser(AccountModel user) async {
    await _keyValueStorage.setEncrypted(
      _authUserKey,
      jsonEncode(user.toMap()),
    );
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
