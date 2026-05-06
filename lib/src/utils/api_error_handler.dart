import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/services/error_utils.dart';
import '../utils/services/show_snack.dart';

class ApiErrorHandler {
  static void handleApiError(dynamic error) {
    // if (error is CustomException) {
    //   if (error.exceptionType == ExceptionType.FetchDataException ||
    //       error.exceptionType == ExceptionType.SocketException ||
    //       error.message.contains("network_error")) {
    //     return;
    //   }
    // }

    // fallback - extract error text and show snackbar
    final errorText = ErrorUtils.extractErrorText(error);
    ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);
  }
}

