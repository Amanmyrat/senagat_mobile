import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:senagat_mobile/src/features/register_password_setup/controller/register_password_setup_controller.dart';

class AuthSuccessController extends GetxController {
  // Observable for loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Observable for error state
  final RxBool _hasError = false.obs;
  bool get hasError => _hasError.value;

  // Observable for bank verification status
  final RxBool _isBankVerificationComplete = false.obs;
  bool get isBankVerificationComplete => _isBankVerificationComplete.value;

  @override
  void onInit() {
    super.onInit();
    _startBankVerification();
  }

  /// Start bank verification process
  void _startBankVerification() {
    _isLoading.value = true;
    // Simulate bank verification process
    Future.delayed(const Duration(seconds: 3), () {
      _isBankVerificationComplete.value = true;
      _isLoading.value = false;
      _navigateToNextScreen();
    });
  }

  /// Navigate to next screen after verification
  void _navigateToNextScreen() {
    try {
      Get.toNamed(DashboardScreen.route);
    } catch (e) {
      _hasError.value = true;
      print('Error navigating to next screen: $e');
    }
  }

  /// Reset error state
  void resetError() {
    _hasError.value = false;
  }

  /// Retry bank verification
  void retryVerification() {
    _isBankVerificationComplete.value = false;
    _startBankVerification();
  }
}
