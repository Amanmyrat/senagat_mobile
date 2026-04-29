// ignore_for_file: constant_identifier_names
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

/// An enum that holds names for our custom exceptions.
enum ExceptionType {
  /// The exception for an expired bearer token.
  TokenExpiredException,

  /// The exception for a prematurely cancelled request.
  CancelException,

  /// The exception for a failed connection attempt.
  ConnectTimeoutException,

  /// The exception for failing to send a request.
  SendTimeoutException,

  /// The exception for failing to receive a response.
  ReceiveTimeoutException,

  /// The exception for no internet connectivity.
  SocketException,

  /// A better name for the socket exception.
  FetchDataException,

  /// The exception for an incorrect parameter in a request/response.
  FormatException,

  /// The exception for an unknown type of failure.
  UnrecognizedException,

  /// The exception for an unknown exception from the api.
  ApiException,

  /// The exception for any parsing failure encountered during
  /// serialization/deserialization of a request.
  SerializationException,
  UnauthorizedException,
}

class CustomException implements Exception {
  final String name, message;
  final String? code;
  final int? statusCode;
  final bool? success;
  final ExceptionType exceptionType;

  CustomException({
    this.code,
    this.success,
    int? statusCode,
    required this.message,
    this.exceptionType = ExceptionType.ApiException,
  }) : statusCode = statusCode ?? 500,
       name = exceptionType.name;

  factory CustomException.fromDioException(Exception error) {
    try {
      if (error is DioError) {
        switch (error.type) {
          case DioExceptionType.connectionError:
            if (error.error is SocketException) {
              return CustomException(
                exceptionType: ExceptionType.FetchDataException,
                message: 'network_error'.tr,
              );
            }
            return CustomException(
              exceptionType: ExceptionType.ApiException,
              message: 'no_internet_connection'.tr,
            );

          case DioErrorType.cancel:
            return CustomException(
              exceptionType: ExceptionType.CancelException,
              statusCode: error.response?.statusCode,
              message: 'Request cancelled prematurely',
            );
          case DioErrorType.connectionTimeout:
            return CustomException(
              exceptionType: ExceptionType.ConnectTimeoutException,
              statusCode: error.response?.statusCode,
              message: 'Connection not established',
            );
          case DioErrorType.sendTimeout:
            return CustomException(
              exceptionType: ExceptionType.SendTimeoutException,
              statusCode: error.response?.statusCode,
              message: 'Failed to send',
            );
          case DioErrorType.receiveTimeout:
            return CustomException(
              exceptionType: ExceptionType.ReceiveTimeoutException,
              statusCode: error.response?.statusCode,
              message: 'Failed to receive',
            );
          case DioErrorType.badResponse:
            if (error.response?.statusCode == 401) {
              return CustomException(
                exceptionType: ExceptionType.UnauthorizedException,
                statusCode: error.response?.statusCode,
                message: 'unauthorized'.tr,
              );
            }
            if (error.message?.contains('Unauthenticated') ?? false) {
              return CustomException(
                exceptionType: ExceptionType.UnauthorizedException,
                statusCode: error.response?.statusCode,
                message: 'unauthorized'.tr,
              );
            }
            // Try to parse structured error from response body
            try {
              final data = error.response?.data;
              if (data is Map) {
                final code = data['code']?.toString();
                final message =
                    data['message']?.toString() ??
                    (data['errors'] is Map
                        ? ((data['errors'] as Map).values.first as List?)?.first
                              ?.toString()
                        : null) ??
                    data['error_message']?.toString() ??
                    data['error']?.toString() ??
                    'Response error';

                final success = data['success'] is bool
                    ? data['success'] as bool
                    : null;
                return CustomException(
                  exceptionType: ExceptionType.ApiException,
                  statusCode: error.response?.statusCode,
                  code: code,
                  success: success,
                  message: message,
                );
              }
            } catch (_) {}
            return CustomException(
              exceptionType: ExceptionType.UnrecognizedException,
              statusCode: error.response?.statusCode,
              message: 'Response error',
            );
          case DioErrorType.unknown:
            if (error.message?.contains(ExceptionType.SocketException.name) ??
                false) {
              return CustomException(
                exceptionType: ExceptionType.FetchDataException,
                statusCode: error.response?.statusCode,
                message: r'network_error'.tr,
              );
            }
            if (error.response?.data is String ||
                error.response?.data == null) {
              return CustomException(
                exceptionType: ExceptionType.UnrecognizedException,
                statusCode: error.response?.statusCode,
                message: error.response?.statusMessage ?? 'Unknown',
              );
            }
            try {
              final data = error.response?.data;
              if (data is Map) {
                final code = data['code']?.toString();
                final message =
                    data['message']?.toString() ??
                    data['error']?.toString() ??
                    'Unknown';
                final success = data['success'] is bool
                    ? data['success'] as bool
                    : null;
                return CustomException(
                  exceptionType: ExceptionType.ApiException,
                  statusCode: error.response?.statusCode,
                  code: code,
                  success: success,
                  message: message,
                );
              }
            } catch (_) {}
            return CustomException(
              exceptionType: ExceptionType.UnrecognizedException,
              statusCode: error.response?.statusCode,
              message: error.response?.statusMessage ?? 'Unknown',
            );
          case DioExceptionType.badCertificate:
            return CustomException(
              exceptionType: ExceptionType.ApiException,
              statusCode: error.response?.statusCode,
              message: 'Bad certificate',
            );
          case DioExceptionType.connectionError:
            return CustomException(
              exceptionType: ExceptionType.ApiException,
              statusCode: error.response?.statusCode,
              message: 'no_internet_connection'.tr,
            );
        }
      } else {
        return CustomException(
          exceptionType: ExceptionType.UnrecognizedException,
          message: 'Error unrecognized',
        );
      }
    } on FormatException catch (e) {
      return CustomException(
        exceptionType: ExceptionType.FormatException,
        message: e.message,
      );
    } on Exception catch (_) {
      return CustomException(
        exceptionType: ExceptionType.UnrecognizedException,
        message: 'Error unrecognized',
      );
    }
  }

  factory CustomException.fromParsingException(Exception error) {
    if (kDebugMode) {
      debugPrint('fromParsingException: $error');
    }
    return CustomException(
      exceptionType: ExceptionType.SerializationException,
      message: 'Failed to parse network response to model or vice versa',
    );
  }
}
