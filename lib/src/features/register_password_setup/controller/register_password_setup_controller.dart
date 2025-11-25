import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/features/auth_success/presentation/auth_success_screen.dart';
import 'package:senagat_mobile/src/features/register_password_setup/models/new_password_model.dart';
import '../../../core/states/stateful_data.dart';
import '../../../core/control_state_variable_mixin.dart';
import '../../../utils/services/show_snack.dart';
import '../../../utils/services/error_utils.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/repository/auth_repository.dart';
import '../models/register_model.dart';

class RegisterPasswordSetupController extends GetxController with StateControlMixin {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  final AuthRepository repository;

  late final String otpToken;
  late final String login;

  bool isPasswordVisible = false;
  bool isPasswordValid = false;

  late final TextEditingController passwordController;
  late final FocusNode passwordFocus;

  final phoneBox = Hive.box<String>('phoneBox');

  int currentStep = 3;

  RegisterPasswordSetupController(this.repository,);

  @override
  void onInit() {
    otpToken = Get.arguments['otpToken'];
    login = Get.arguments['login'];
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

  Future<RegisterModel> _getRegisterModel() async {
    return RegisterModel(otpToken: otpToken, password: passwordController.text);
  }
  Future<NewPasswordModel> _getNewPasswordModel() async {
    return NewPasswordModel(phone: phoneBox.get('phone') ?? '', otpToken: otpToken, password: passwordController.text);
  }

  Future<void> confirmPassword() async {
    if (key.currentState?.validate() ?? false) {
      key.currentState!.save();
      status = Status.loading;
      update();

      final registerModel = await _getRegisterModel();
      await repository.register(data: registerModel.toMap()).then((value) {
        status = Status.completed;
        update();
        authController.onAccountUpdate(value);
        authController.onTokenUpdate(value);

        Get.toNamed(AuthSuccessScreen.route);
      }).catchError((e) {
        status = Status.error;
        update();
        final errorText = ErrorUtils.extractErrorText(e);
        ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);

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
      await repository.resetPassword(data: newPassword.toMap()).then((value) {
        status = Status.completed;
        update();

        Get.toNamed(AuthSuccessScreen.route);
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
    passwordController.dispose();
    passwordFocus.dispose();
    super.dispose();
  }
}
