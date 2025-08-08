import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/register_password_setup/presentation/register_password_setup_screen.dart';

class RegisterConfirmationController extends GetxController
    with StateControlMixin {
  final String phoneNumber;
  RegisterConfirmationController(this.phoneNumber);

  final int otpLength = 5;
  final int timerMaxSeconds = 60;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController otpController;
  late final FocusNode otpFocus;

  Timer? _timer;
  int secondsLeft = 60;
  bool timerEnded = false;
  bool pinLengthError = false;

  bool get isPinFull => otpController.text.length == otpLength;

  @override
  void onInit() {
    super.onInit();
    otpController = TextEditingController();
    otpFocus = FocusNode();
    otpController.addListener(_onOtpChanged);
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    secondsLeft = timerMaxSeconds;
    timerEnded = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        secondsLeft--;
      } else {
        timerEnded = true;
        timer.cancel();
      }
      update();
    });

    update();
  }

  void _onOtpChanged() {
    pinLengthError =
        otpController.text.isNotEmpty && otpController.text.length < otpLength;
    if (otpController.text.length == otpLength) pinLengthError = false;
    update();
  }

  void applyOtpCode() async {
    if (formKey.currentState?.validate() != true) return;

    status = Status.loading;
    update();

    await Future.delayed(const Duration(seconds: 2));

    status = Status.completed;
    update();

    Get.toNamed(RegisterPasswordSetupScreen.route);
  }

  String? validateOtp(String? code) {
    if ((code ?? '').length != otpLength) {
      return 'Введите 5-значный код';
    }
    return null;
  }

  void resendOtpCode() async {
    status = Status.loading;
    update();

    await Future.delayed(const Duration(seconds: 1));
    otpController.clear();
    startTimer();

    status = Status.completed;
    update();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    otpFocus.dispose();
    super.dispose();
  }
}
