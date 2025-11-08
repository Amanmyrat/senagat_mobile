import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/networking/custom_exception.dart';

class ErrorUtils {
  static String? extractErrorText(Object e) {
    try {
      // If it's your CustomException
      if (e is CustomException) {
        return e.message;
      }

      // Handle DioError
      if (e is DioError) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          // Try message first
          if (data['message'] != null) {
            return data['message'].toString();
          }

          // Then nested errors: { errors: { birth_date: [ "..." ] } }
          if (data['errors'] != null && data['errors'] is Map) {
            final firstKey = (data['errors'] as Map).keys.first;
            final firstValue = (data['errors'][firstKey] as List?)?.first;
            return firstValue?.toString() ??
                'Error on field "$firstKey"';
          }
        }

        // Fallback
        return e.message ?? 'Unknown network error';
      }

      // If it’s a plain Map (sometimes returned by repositories)
      if (e is Map) {
        return e['message']?.toString() ?? jsonEncode(e);
      }

      // If it’s a raw String
      if (e is String) {
        try {
          final decoded = jsonDecode(e);
          return decoded['message']?.toString() ?? e;
        } catch (_) {
          return e;
        }
      }

      return e.toString();
    } catch (err) {
      return 'Unknown error: $err';
    }
  }
}
