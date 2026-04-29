// ignore_for_file: constant_identifier_names
// DO NOT USE 'dartfmt' on this file for formatting

import 'package:flutter/material.dart';

import '../../core/globals.dart';

@immutable
class ApiEndpoint {
  const ApiEndpoint._();

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
      case AuthEndpoint.USER_INFORMATION:
        return '$path/users/auth/user-information';
      case AuthEndpoint.RESET_PASSWORD:
        return '$path/reset/password';
      case AuthEndpoint.RESET_REQUEST:
        return '$path/reset/request';
      case AuthEndpoint.RESET_CONFIRM:
        return '$path/reset/confirm';
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
        return '$path/credit/types';
      case CreditEndpoint.CREDIT_ORDER:
        return '$path/application/credit/order';
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
  static Future<String> payment(
    PaymentEndpoint endpoint, {
    int? id,
    String? date,
  }) async {
    const path = '';
    switch (endpoint) {
      case PaymentEndpoint.CHECK_PHONE:
        return '$path/belet/belet/check-phone';
      case PaymentEndpoint.BALANCE:
        return '$path/belet/balances';
      case PaymentEndpoint.TOP_UP:
        return '$path/belet/top-up';
      case PaymentEndpoint.BELET_BALANCE:
        return '$path/belet/belet/check-phone-balance';
      case PaymentEndpoint.HISTORY:
        return '$path/payment-history';
      case PaymentEndpoint.TELECOM_BALANCE:
        return '$path/telecom/balance';
      case PaymentEndpoint.TELECOM_PAY:
        return '$path/telecom/pay';
      case PaymentEndpoint.ASTU_BALANCE:
        return '$path/astu/balance';
      case PaymentEndpoint.ASTU_PAY:
        return '$path/astu/pay';
      case PaymentEndpoint.TMCELL_BALANCE:
        return '$path/tmcell/balance';
      case PaymentEndpoint.TMCELL_PAY:
        return '$path/tmcell/pay';
        case PaymentEndpoint.CDMA_BALANCE:
        return '$path/cdma/balance';
      case PaymentEndpoint.CDMA_PAY:
        return '$path/cdma/pay';
    }
  }
  static Future<String> charity(
    CharityEndpoint endpoint, {
    int? id,
    String? date,
  }) async {
    const path = '';
    switch (endpoint) {
      case CharityEndpoint.CHARITY:
        return '$path/charity';
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
  USER_INFORMATION,
  RESET_PASSWORD,
  RESET_REQUEST,
  RESET_CONFIRM,
}

enum InquiriesEndpoint { CERTIFICATE_TYPES, CERTIFICATE_ORDER }

enum CardEndpoint { CARD_TYPES, CARD_ORDER }

enum CreditEndpoint { CREDIT_TYPES, CREDIT_ORDER }

enum LocationEndpoint { LOCATION, LOCATION_BRANCHES }

enum ExchangeRateEndpoint { EXCHANGE_RALE }

enum PaymentEndpoint { CHECK_PHONE, BALANCE, TOP_UP, BELET_BALANCE, HISTORY, TELECOM_BALANCE, TELECOM_PAY,ASTU_BALANCE, ASTU_PAY,TMCELL_BALANCE,TMCELL_PAY, CDMA_BALANCE, CDMA_PAY}

enum CharityEndpoint { CHARITY }