import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/login_confirmation/presetation/login_confirmation.dart';
import 'package:senagat_mobile/src/utils/validator.dart';

class LoginController extends GetxController {
  // Observable for loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Observable for error state
  final RxBool _hasError = false.obs;
  bool get hasError => _hasError.value;

  // Observable for phone number
  final RxString _phoneNumber = ''.obs;
  String get phoneNumber => _phoneNumber.value;

  // Observable for step progress
  final RxInt _currentStep = 1.obs;
  int get currentStep => _currentStep.value;

  // Country code
  final String countryCode = '+993';

  final RxString phoneNumberError = ''.obs;

  final TextEditingController phoneController = TextEditingController();
  final FocusNode phoneFocus = FocusNode();

  bool get isPhoneValid => _phoneNumber.value.length == 8;

  @override
  void onInit() {
    super.onInit();
    // Initialize any required setup
  }

  /// Update phone number
  void updatePhoneNumber(String value) {
    _phoneNumber.value = value;
    if (value.length != 8) {
      phoneNumberError.value = 'Неправильно введен номер';
    } else {
      phoneNumberError.value = '';
    }
  }

  void onPhoneTextChanged(String value) {
    _phoneNumber.value = value;
    if (phoneNumberError.value.isNotEmpty) {
      phoneNumberError.value = '';
    }
  }

  /// Validate phone number
  bool _validatePhoneNumber(String phone) {
    // Add phone validation logic here
    return phone.length >= 8;
  }

  /// Send verification code
  void sendVerificationCode() {
    if (!_validatePhoneNumber(_phoneNumber.value)) {
      _hasError.value = true;
      return;
    }

    _isLoading.value = true;
    try {
      // Simulate sending verification code
      Future.delayed(const Duration(seconds: 2), () {
        _isLoading.value = false;
        _navigateToNextScreen();
      });
    } catch (e) {
      _hasError.value = true;
      _isLoading.value = false;
      print('Error sending verification code: $e');
    }
  }

  /// Navigate to next screen after sending code
  void _navigateToNextScreen() {
    try {
      Get.toNamed(LoginConfiramationScreen.route);
    } catch (e) {
      _hasError.value = true;
      print('Error navigating to next screen: $e');
    }
  }

  String? validatePhone() {
    if (phoneController.text.isEmpty) {
      return 'fill_field';
    } else if (!Validator.matchPhoneNumberWithoutPrefix(phoneController.text)) {
      return r'input_correct_number'.tr;
    }

    return null;
  }

  /// Reset error state
  void resetError() {
    _hasError.value = false;
  }

  /// Get full phone number
  String getFullPhoneNumber() {
    return '$countryCode$_phoneNumber';
  }

  /// Get phone validation message
  String getPhoneValidationMessage() {
    if (_phoneNumber.value.isEmpty) {
      return '';
    }
    if (_phoneNumber.value.length < 8) {
      return 'Номер телефона должен содержать минимум 8 цифр';
    }
    return '';
  }
}
