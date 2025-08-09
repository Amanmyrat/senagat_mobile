import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';

import '../../register_confirmation/presentation/register_confirmation.dart';

class RegisterController extends GetxController with StateControlMixin {
  final GlobalKey<FormState> key;
  bool continueEnabled = false;
  bool login = false;

  bool isPasswordVisible = false;
  bool isPasswordValid = false;

  late final TextEditingController passwordController;
  late final FocusNode passwordFocus;

  RegisterController(this.key);

  late final TextEditingController phoneController;
  late final FocusNode phoneFocus;

  @override
  void onInit() {
    login = Get.arguments['login'];
    phoneController = TextEditingController();
    phoneFocus = FocusNode();
    passwordController = TextEditingController();
    passwordFocus = FocusNode();
    super.onInit();
  }

  void onLoginTap() async {
    if (key.currentState?.validate() ?? false) {
      status = Status.loading;
      key.currentState!.save();
      update();
      // Simulate sending OTP

      await Future.delayed(const Duration(seconds: 2));
      status = Status.completed;
      update();
      Get.toNamed(
        RegisterConfirmationScreen.route,
        arguments: {'phone': phoneController.text, 'login': login},
      );
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void onPasswordChanged(String val) {
    isPasswordValid = val.length >= 6;
    update();
  }

  void onPhoneTextChanged(String val) {
    continueEnabled = val.length >= 8;
    update();
  }

  @override
  void dispose() {
    phoneController.dispose();
    phoneFocus.dispose();
    passwordController.dispose();
    passwordFocus.dispose();
    super.dispose();
  }
}
