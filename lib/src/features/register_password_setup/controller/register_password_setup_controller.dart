import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/auth_success/presentation/auth_success_screen.dart';
import 'package:senagat_mobile/src/features/register/presentation/register_screen.dart';
import 'package:senagat_mobile/src/features/register_confirmation/controller/register_confirmation_controller.dart';
import 'package:senagat_mobile/src/features/register_password_setup/models/new_password_model.dart';
import '../../../core/states/stateful_data.dart';
import '../../../core/control_state_variable_mixin.dart';
import '../../../utils/api_error_handler.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/repository/auth_repository.dart';
import '../../register/controller/register_controller.dart';
import '../models/register_model.dart';

class RegisterPasswordSetupController extends GetxController
    with StateControlMixin {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  final AuthRepository repository;

  late final String? otpToken;
  late final String login;

  bool isPasswordVisible = false;
  bool isPasswordValid = false;

  final bool otpEnabled = Configs.OTPEnabled;

  late final TextEditingController passwordController;
  late final FocusNode passwordFocus;

  final phoneBox = Hive.box<String>('phoneBox');

  int currentStep = 3;

  RegisterPasswordSetupController(this.repository);

  @override
  void onInit() {
    try {
      final args = Get.arguments;
      otpToken = args?['otpToken'];
      login = args?['login'] ?? '';
    } catch (e) {
      otpToken = null;
      login = '';
    }
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

  Future<RegisterModelForEnabledOTP> _getRegisterModel() async {
    return RegisterModelForEnabledOTP(otpToken: otpToken ?? '', password: passwordController.text);
  }

  Future<RegisterModel> _getRegisterModel2() async {
    return RegisterModel(phone: phoneBox.get('phone') ?? '', password: passwordController.text);
  }

  Future<NewPasswordModel> _getNewPasswordModel() async {
    return NewPasswordModel(
      phone: phoneBox.get('phone') ?? '',
      otpToken: otpToken ?? '',
      password: passwordController.text,
    );
  }

  Future<void> confirmPassword() async {
    if (key.currentState?.validate() ?? false) {
      key.currentState!.save();
      status = Status.loading;
      update();

      final registerModel = await _getRegisterModel();
      final registerModel2 = await _getRegisterModel2();
      await repository
          .register(data: Configs.OTPEnabled == false ? registerModel2.toMap() : registerModel.toMap())
          .then((value) {
            status = Status.completed;
            update();
            authController.onAccountUpdate(value);
            authController.onTokenUpdate(value);

            Get.toNamed(AuthSuccessScreen.route);
          })
          .catchError((e) {
            status = Status.error;
            update();
            ApiErrorHandler.handleApiError(e);
            debugPrint(e.toString());
          });
    }
  }

  Future<void> newPassword() async {
    if (key.currentState?.validate() ?? false) {
      key.currentState!.save();
      status = Status.loading;
      update();

      final newPassword = await _getNewPasswordModel();
      await repository
          .resetPassword(data: newPassword.toMap())
          .then((value) {
            status = Status.completed;

            Get.delete<RegisterController>(force: true);
            Get.delete<RegisterConfirmationController>(force: true);
            Get.toNamed(RegisterScreen.route, arguments: {'login': 'login'});
            update();
          })
          .catchError((e) {
            status = Status.error;
            update();
            ApiErrorHandler.handleApiError(e);
            debugPrint(e.toString());
          });
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordFocus.dispose();
    super.dispose();
  }
}
