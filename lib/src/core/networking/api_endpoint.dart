// ignore_for_file: constant_identifier_names
// DO NOT USE 'dartfmt' on this file for formatting

import 'package:flutter/material.dart';

import '../../core/globals.dart';

/// A utility class for getting paths for API endpoints.
/// This class has no constructor and all methods are `static`.
@immutable
class ApiEndpoint {
  const ApiEndpoint._();

  /// The base url of our REST API, to which all the requests will be sent.
  /// It is supplied at the time of building the apk or running the app:
  /// ```
  /// flutter build apk --debug --dart-define=BASE_URL=www.some_url.com
  /// ```
  /// OR
  /// ```
  /// flutter run --dart-define=BASE_URL=www.some_url.com
  /// ```
  static const baseUrl = Configs.baseUrl;

  /// Returns the path for an authentication [endpoint].
  static String auth(AuthEndpoint endpoint, {int? id, String? date}) {
    const path = '';
    switch (endpoint) {
      case AuthEndpoint.PRE_LOGIN:
        return '$path/users/auth/pre-login';
      case AuthEndpoint.REQUEST_OTP:
        return '$path/users/auth/request-otp';
      case AuthEndpoint.VERIFY_OTP:
        return '$path/users/auth/verify-otp';
      case AuthEndpoint.LOGIN:
        return '$path/users/auth/login';
      case AuthEndpoint.REGISTER:
        return '$path/users/auth/register';
    }
  }
}

/// A collection of endpoints used for authentication purposes.
enum AuthEndpoint {
  /// An endpoint for auth requests.
  PRE_LOGIN,
  REQUEST_OTP,
  LOGIN,
  VERIFY_OTP,
  REGISTER,
}
