import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../core/networking/custom_exception.dart';

class ErrorUtils {
  static String? extractErrorText(Object e) {
    try {
      if (e is CustomException) {
        return e.message.tr;
      }

      if (e is DioError) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {

          if (data['error'] != null && data['error'] is Map) {
            return data['error']['message']?.toString().tr;
          }

          if (data['message'] != null) {
            return data['message'].toString().tr;
          }

          if (data['errors'] != null && data['errors'] is Map) {
            final firstKey = (data['errors'] as Map).keys.first;
            final firstValue = (data['errors'][firstKey] as List?)?.first;
            return firstValue?.toString().tr ??
                'Error on field "$firstKey"';
          }
        }

        return e.message?.tr ?? 'Unknown network error';
      }

      if (e is Map) {
        return e['message']?.toString().tr ?? jsonEncode(e).tr;
      }

      if (e is String) {
        try {
          final decoded = jsonDecode(e);
          return decoded['message']?.toString().tr ?? e.tr;
        } catch (_) {
          return e.tr;
        }
      }

      return e.toString().tr;
    } catch (err) {
      return 'Unknown error: $err';
    }
  }
}