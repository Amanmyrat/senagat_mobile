import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/register/models/request_otp.dart';
import '../../../utils/api_error_handler.dart';
import '../../register_confirmation/presentation/register_confirmation.dart';
import '../models/pre_login_model.dart';
import '../../auth/repository/auth_repository.dart';

class RegisterController extends GetxController with StateControlMixin {
  final AuthRepository repository;

  final GlobalKey<FormState> key;
  bool continueEnabled = false;
  late String login;

  bool isPasswordVisible = false;
  bool isPasswordValid = false;

  late final TextEditingController passwordController;
  late final FocusNode passwordFocus;

  RegisterController(this.repository, this.key);

  late final TextEditingController phoneController;
  late final FocusNode phoneFocus;

  final phoneBox = Hive.box<String>('phoneBox');

  @override
  void onInit() {
    login = Get.arguments['login'];
    phoneController = TextEditingController();
    phoneFocus = FocusNode();
    passwordController = TextEditingController();
    passwordFocus = FocusNode();
    print(login);
    super.onInit();
  }

  Future<PreLoginModel> _getPreLoginModel() async {
    return PreLoginModel(
      phone: phoneController.text,
      password: passwordController.text,
    );
  }

  Future<RequestModel> _getRequestModel() async {
    return RequestModel(phone: phoneController.text, purpose: login);
  }

  void onRegisterTap() async {
    if (key.currentState?.validate() ?? false) {
      status = Status.loading;

      key.currentState!.save();
      update();

      // repository
      //     .checkRegister(data: <String, dynamic>{"phone": phoneController.text})
      //     .then((value) async {
      //       print(value == true ? 'TRUE' : 'FALSE');
      //
      //     })
      //     .catchError((e) {
      //       status = Status.error;
      //       update();
      //       final errorText = ErrorUtils.extractErrorText(e);
      //       ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);
      //     });

      final requestModel = await _getRequestModel();
      await repository
          .requestOTP(data: requestModel.toMap())
          .then((value) {
            status = Status.completed;
            phoneBox.put('phone', phoneController.text);
            update();

            Get.toNamed(
              RegisterConfirmationScreen.route,
              arguments: {'phone': phoneController.text, 'login': login},
            );
          })
          .catchError((e) {
            status = Status.error;
            update();
            ApiErrorHandler.handleApiError(e);
          });
    }
  }

  void onLoginTap() async {
    if (key.currentState?.validate() ?? false) {
      status = Status.loading;

      key.currentState!.save();
      update();

      final preLoginModel = await _getPreLoginModel();
      await repository
          .preLogin(data: preLoginModel.toMap())
          .then((value) {
            status = Status.completed;
            phoneBox.put('phone', phoneController.text);
            update();

            Get.toNamed(
              RegisterConfirmationScreen.route,
              arguments: {'phone': phoneController.text, 'login': login},
            );
          })
          .catchError((e) {
            status = Status.error;
            update();
            ApiErrorHandler.handleApiError(e);
          });
    }
  }

  void onForgetPasswordTap() {
    login = 'reset_password';
    update();
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
