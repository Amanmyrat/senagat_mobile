import '../core/networking/custom_exception.dart';

class ErrorUtils {
  static String? extractErrorText(Object e) {
    try {
      if (e is CustomException) {
        return e.message;
      } else {
        return e.toString();
      }
    } catch (_) {
      return null;
    }
  }
}
