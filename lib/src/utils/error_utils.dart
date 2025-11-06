import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/networking/custom_exception.dart';

class ErrorUtils {
  static String? extractErrorText(Object e) {
    try {
      // 1️⃣ Обработка нашего CustomException
      if (e is CustomException) {
        return e.message;
      }

      // 2️⃣ Если DioError напрямую
      if (e is DioError) {
        final data = e.response?.data;
        if (data is Map) {
          // Берём message или первую ошибку из errors
          final msg = data['message'] ??
              (data['errors']?.values?.first is List
                  ? (data['errors']?.values?.first as List).first
                  : null);
          return msg?.toString() ?? 'Unknown error';
        }
      }

      // 3️⃣ Если пришла просто Map
      if (e is Map) {
        return e['message']?.toString() ?? jsonEncode(e);
      }

      // 4️⃣ Если строка
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
