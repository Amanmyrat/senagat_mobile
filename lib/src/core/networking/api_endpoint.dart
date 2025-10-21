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
      case AuthEndpoint.PROFILE:
        return '$path/profile';
      case AuthEndpoint.CHECK_REGISTER:
        return '$path/users/check';
    }
  }

  static Future<String> inquiries(
    InquiriesEndpoint endpoint, {
    int? id,
    String? date,
  }) async {
    const path = '';
    switch (endpoint) {
      case InquiriesEndpoint.CERTIFICATE_TYPES:
        return '$path/certificate-types';

      case InquiriesEndpoint.CERTIFICATE_ORDER:
        return '$path/certificate-order';
    }
  }

  static Future<String> card(
    CardEndpoint endpoint, {
    int? id,
    String? date,
  }) async {
    const path = '';
    switch (endpoint) {
      case CardEndpoint.CARD_TYPES:
        return '$path/card/types';

      case CardEndpoint.CARD_ORDER:
        return '$path/card/order';
    }
  }

  static Future<String> credit(
    CreditEndpoint endpoint, {
    int? id,
    String? date,
  }) async {
    const path = '';
    switch (endpoint) {
      case CreditEndpoint.CREDIT_TYPES:
        return '$path/credit';
      case CreditEndpoint.CREDIT_DETAILS:
        return '$path/application/credit-details';
      case CreditEndpoint.WORK_INFO:
        return '$path/application/work-info';
      case CreditEndpoint.BRANCH_INFO:
        return '$path/application/branch-info';
    }
  }

  static Future<String> location(
    LocationEndpoint endpoint, {
    int? id,
    String? date,
  }) async {
    const path = '';
    switch (endpoint) {
      case LocationEndpoint.LOCATION:
        return '$path/location';
      case LocationEndpoint.LOCATION_BRANCHES:
        return '$path/location/branches';
    }
  }

  static Future<String> exchangeRate(
    ExchangeRateEndpoint endpoint, {
    int? id,
    String? date,
  }) async {
    const path = '';
    switch (endpoint) {
      case ExchangeRateEndpoint.EXCHANGE_RALE:
        return '$path/exchange-rate';
    }
  }
}

enum AuthEndpoint {
  PRE_LOGIN,
  REQUEST_OTP,
  LOGIN,
  VERIFY_OTP,
  REGISTER,
  CHECK_REGISTER,
  PROFILE,
}

enum InquiriesEndpoint { CERTIFICATE_TYPES, CERTIFICATE_ORDER }

enum CardEndpoint { CARD_TYPES, CARD_ORDER }

enum CreditEndpoint { CREDIT_TYPES, CREDIT_DETAILS, WORK_INFO, BRANCH_INFO }

enum LocationEndpoint { LOCATION, LOCATION_BRANCHES }

enum ExchangeRateEndpoint { EXCHANGE_RALE }
