import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/login_accept/presentation/login_accept_screen.dart';

class PasswordController extends GetxController {
  // Observable for loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Observable for error state
  final RxBool _hasError = false.obs;
  bool get hasError => _hasError.value;

  // Observable for password visibility
  final RxBool _isPasswordVisible = false.obs;
  bool get isPasswordVisible => _isPasswordVisible.value;

  // Observable for password
  final RxString _password = ''.obs;
  String get password => _password.value;

  // Observable for step progress
  final RxInt _currentStep = 3.obs;
  int get currentStep => _currentStep.value;

  bool get isPasswordValid => _password.value.length >= 8;

  @override
  void onInit() {
    super.onInit();
    // Initialize any required setup
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  /// Update password
  void updatePassword(String newPassword) {
    _password.value = newPassword;
  }

  /// Validate password
  bool _validatePassword(String password) {
    // Add password validation logic here
    return password.length >= 8;
  }

  /// Confirm password
  void confirmPassword() {
    if (!_validatePassword(_password.value)) {
      _hasError.value = true;
      return;
    }

    _isLoading.value = true;
    try {
      // Simulate password confirmation
      Future.delayed(const Duration(seconds: 2), () {
        _isLoading.value = false;
        _navigateToNextScreen();
      });
    } catch (e) {
      _hasError.value = true;
      _isLoading.value = false;
      print('Error confirming password: $e');
    }
  }

  /// Navigate to next screen after password confirmation
  void _navigateToNextScreen() {
    try {
      Get.toNamed(LoginAcceptScreen.route);
    } catch (e) {
      _hasError.value = true;
      print('Error navigating to next screen: $e');
    }
  }

  /// Reset error state
  void resetError() {
    _hasError.value = false;
  }

  /// Get password validation message
  String getPasswordValidationMessage() {
    if (_password.value.isEmpty) {
      return '';
    }
    if (_password.value.length < 8) {
      return 'Пароль должен содержать минимум 8 символов';
    }
    return '';
  }
}
