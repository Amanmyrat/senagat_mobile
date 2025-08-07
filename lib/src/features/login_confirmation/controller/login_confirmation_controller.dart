import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/password/presentation/password_screen.dart';
import 'dart:async';

class LoginConfirmationController extends GetxController {
  // Observable for loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Observable for error state
  final RxBool _hasError = false.obs;
  bool get hasError => _hasError.value;

  // Observable for OTP code
  final RxString _otpCode = ''.obs;
  String get otpCode => _otpCode.value;

  // Observable for phone number
  final RxString _phoneNumber = '+99364626088'.obs;
  String get phoneNumber => _phoneNumber.value;

  // Observable for step progress
  final RxInt _currentStep = 2.obs;
  int get currentStep => _currentStep.value;

  // Timer for OTP
  final RxInt _secondsLeft = 60.obs;
  int get secondsLeft => _secondsLeft.value;

  final RxBool _timerEnded = false.obs;
  bool get timerEnded => _timerEnded.value;

  // Pin length error
  final RxBool _pinLengthError = false.obs;
  bool get pinLengthError => _pinLengthError.value;

  bool get isPinFull => _otpCode.value.length == 5;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    // Initialize any required setup
  }

  void startTimer() {
    _timer?.cancel();
    _secondsLeft.value = 60;
    _timerEnded.value = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft.value > 0) {
        _secondsLeft.value--;
      } else {
        _timerEnded.value = true;
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// Update OTP code
  void updateOtpCode(String code) {
    _otpCode.value = code;
    if (code.isNotEmpty && code.length < 5) {
      _pinLengthError.value = true;
    } else if (code.length == 5) {
      _pinLengthError.value = false;
    }
  }

  /// Apply OTP code
  void applyOtpCode() {
    if (_timerEnded.value) {
      _hasError.value = true;
      return;
    }
    if (_otpCode.value.length != 5) {
      _pinLengthError.value = true;
      return;
    }

    _isLoading.value = true;
    try {
      // Simulate OTP validation
      Future.delayed(const Duration(seconds: 2), () {
        _isLoading.value = false;
        _navigateToNextScreen();
      });
    } catch (e) {
      _hasError.value = true;
      _isLoading.value = false;
      print('Error applying OTP: $e');
    }
  }

  /// Navigate to next screen after OTP validation
  void _navigateToNextScreen() {
    try {
      Get.toNamed(PasswordScreen.route);
    } catch (e) {
      _hasError.value = true;
      print('Error navigating to next screen: $e');
    }
  }

  /// Reset error state
  void resetError() {
    _hasError.value = false;
    _pinLengthError.value = true;
  }

  /// Resend OTP code
  void resendOtpCode() {
    _isLoading.value = true;
    try {
      // Simulate resending OTP
      Future.delayed(const Duration(seconds: 1), () {
        _isLoading.value = false;
        // Reset OTP code
        _otpCode.value = '';
        startTimer();
      });
    } catch (e) {
      _hasError.value = true;
      _isLoading.value = false;
      print('Error resending OTP: $e');
    }
  }

  /// Update phone number
  void updatePhoneNumber(String phone) {
    _phoneNumber.value = phone;
  }
}
