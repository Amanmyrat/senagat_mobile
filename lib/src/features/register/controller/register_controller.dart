import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/utils/validator.dart';

import '../../register_confirmation/presentation/register_confirmation.dart';

class RegisterController extends GetxController with StateControlMixin {
  final GlobalKey<FormState> key;
  bool continueEnabled = false;

  RegisterController(this.key);

  late final TextEditingController phoneController;
  late final FocusNode phoneFocus;

  @override
  void onInit() {
    phoneController = TextEditingController();
    phoneFocus = FocusNode();
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
        arguments: {'phone': phoneController.text},
      );
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

  void onPhoneTextChanged(String val) {
    continueEnabled = val.length >= 8;
    update();
  }

  @override
  void dispose() {
    phoneController.dispose();
    phoneFocus.dispose();
    super.dispose();
  }
}
