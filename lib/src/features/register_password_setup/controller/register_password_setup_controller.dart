import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/auth_success/presentation/auth_success_screen.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import '../../../core/states/stateful_data.dart';
import '../../../core/control_state_variable_mixin.dart';

class RegisterPasswordSetupController extends GetxController with StateControlMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool isPasswordValid = false;

  late final TextEditingController passwordController;
  late final FocusNode passwordFocus;

  int currentStep = 3;

  @override
  void onInit() {
    passwordController = TextEditingController();
    passwordFocus = FocusNode();
    super.onInit();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void onPasswordChanged(String val) {
    isPasswordValid = val.length >= 6;
    update();
  }

  Future<void> confirmPassword() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      status = Status.loading;
      update();

      await Future.delayed(const Duration(seconds: 2));

      status = Status.completed;
      update();

      Get.toNamed(AuthSuccessScreen.route);
    }
  }
  @override
  void dispose() {
    passwordController.dispose();
    passwordFocus.dispose();
    super.dispose();
  }
}
