import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../core/networking/custom_exception.dart';

class ErrorUtils {
  static String present(String raw) {
    final translated = raw.tr;
    if (translated != raw) return translated;
    if (raw.contains(' ') || !raw.contains('_')) return raw;

    final sentence = raw.replaceAll('_', ' ').trim();
    if (sentence.isEmpty) return r'error'.tr;
    return sentence[0].toUpperCase() + sentence.substring(1);
  }

  static String? extractErrorText(Object e) {
    try {
      if (e is CustomException) {
        return present(e.message);
      }

      if (e is DioError) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {

          if (data['error'] is Map && data['error']['message'] != null) {
            return present(data['error']['message'].toString());
          }

          if (data['message'] != null) {
            return present(data['message'].toString());
          }

          if (data['errors'] != null && data['errors'] is Map) {
            final firstKey = (data['errors'] as Map).keys.first;
            final firstValue = (data['errors'][firstKey] as List?)?.first;
            return firstValue == null
                ? 'Error on field "$firstKey"'
                : present(firstValue.toString());
          }
        }

        return e.message == null ? 'Unknown network error' : present(e.message!);
      }

      if (e is Map) {
        final message = e['message']?.toString();
        return message == null ? present(jsonEncode(e)) : present(message);
      }

      if (e is String) {
        try {
          final decoded = jsonDecode(e);
          final message = decoded['message']?.toString();
          return message == null ? present(e) : present(message);
        } catch (_) {
          return present(e);
        }
      }

      return present(e.toString());
    } catch (err) {
      return 'Unknown error: $err';
    }
  }
}