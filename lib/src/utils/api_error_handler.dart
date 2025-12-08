import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/services/error_utils.dart';
import '../core/networking/custom_exception.dart';
import '../features/no_internet/presentation/no_internet_screen.dart';
import '../utils/services/show_snack.dart';

class ApiErrorHandler {
  static void handleApiError(dynamic error) {
    if (error is CustomException) {
      if (error.exceptionType == ExceptionType.FetchDataException ||
          error.exceptionType == ExceptionType.SocketException ||
          error.message.contains("network_error")) {
        Get.to(() => const NoInternetScreen());
        return;
      }
    }

    // fallback - extract error text and show snackbar
    final errorText = ErrorUtils.extractErrorText(error);
    ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);
  }
}

