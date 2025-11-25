import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/auth_success/presentation/auth_success_screen.dart';
import 'package:senagat_mobile/src/features/register_confirmation/models/verify_otp_model.dart';
import 'package:senagat_mobile/src/features/register_password_setup/presentation/register_password_setup_screen.dart';

import '../../../utils/services/show_snack.dart';
import '../../../utils/services/error_utils.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/repository/auth_repository.dart';
import '../../register/models/request_otp.dart';
import '../models/account_model.dart';
import '../models/login_model.dart';

class RegisterConfirmationController extends GetxController
    with StateControlMixin {

  final AuthRepository repository;

  String phoneNumber = '';

  final int otpLength = 5;
  final int timerMaxSeconds = 60;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController otpController;
  late final FocusNode otpFocus;

  final authController = Get.find<AuthController>();

  Timer? _timer;
  int secondsLeft = 60;
  bool pinLengthError = false;
  late String login;

  late AccountModel accountModel;

  RegisterConfirmationController(this.repository);

  bool get isPinFull => otpController.text.length == otpLength;

  @override
  void onInit() {
    super.onInit();
    login = Get.arguments['login'];
    phoneNumber = Get.arguments['phone'];
    otpController = TextEditingController();
    otpFocus = FocusNode();
    otpController.addListener(_onOtpChanged);
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    secondsLeft = timerMaxSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        secondsLeft--;
      } else {
        status == Status.error;
        timer.cancel();
      }
      update();
    });

    update();
  }

  Future<RequestModel> _getRequestModel() async {
    return RequestModel(
      phone: phoneNumber,
      purpose: login,
    );
  }

  void resendOtpCode() async {
      status = Status.loading;
      update();

      final requestModel = await _getRequestModel();
      await repository
          .requestOTP(data: requestModel.toMap())
          .then((value) {
        status = Status.completed;
        startTimer();
        update();

      })
          .catchError((e) {
        status = Status.error;
        update();
        final errorText = ErrorUtils.extractErrorText(e);
        ShowSnack.showSnack(
          errorText ?? r'error'.tr,
          SnackType.error,
        );
      });
  }

  void _onOtpChanged() {
    pinLengthError =
        otpController.text.isNotEmpty && otpController.text.length < otpLength;
    if (otpController.text.length == otpLength) pinLengthError = false;
    update();
  }

  Future<LoginModel> _getLoginModel() async {
    return LoginModel(phone: phoneNumber, otpNumber: otpController.text);
  }
  Future<VerifyOtpModel> _getVerifyOtpModel() async {
    return VerifyOtpModel(phone: phoneNumber, code: otpController.text, purpose: login);
  }

  void applyOtpCode() async {
    if (formKey.currentState?.validate() ?? false) {
      status = Status.loading;

      formKey.currentState!.save();
      update();

      final loginModel = await _getLoginModel();
      await repository.login(data: loginModel.toMap()).then((value) {
        status = Status.completed;
        update();

        authController.onAccountUpdate(value);
        authController.onTokenUpdate(value);

        accountModel = value;
        Get.toNamed(login == 'login' ? AuthSuccessScreen.route : RegisterPasswordSetupScreen.route,);
      }).catchError((e) {
        status = Status.error;
        update();
        final errorText = ErrorUtils.extractErrorText(e);
        ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);

        debugPrint(e.toString());
      });
    }
  }

  Future<void> verifyOtp() async {
    if (formKey.currentState?.validate() ?? false) {
      status = Status.loading;

      formKey.currentState!.save();
      update();

      final verifyOtpModel = await _getVerifyOtpModel();
      await repository.verifyOTP(data: verifyOtpModel.toMap()).then((value) {
        status = Status.completed;
        update();
        print(value);

        Get.toNamed(RegisterPasswordSetupScreen.route, arguments: {
          'otpToken': value,
          'login': login,
        });
      }).catchError((e) {
        status = Status.error;
        update();
        final errorText = ErrorUtils.extractErrorText(e);
        ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);

        debugPrint(e.toString());
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    otpFocus.dispose();
    super.dispose();
  }
}
