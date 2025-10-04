import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/auth_success/presentation/auth_success_screen.dart';
import '../../../core/states/stateful_data.dart';
import '../../../core/control_state_variable_mixin.dart';
import '../../../utils/services/show_snack.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/repository/auth_repository.dart';
import '../models/register_model.dart';

class RegisterPasswordSetupController extends GetxController with StateControlMixin {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  final AuthRepository repository;

  late final String otpToken;

  bool isPasswordVisible = false;
  bool isPasswordValid = false;

  late final TextEditingController passwordController;
  late final FocusNode passwordFocus;

  int currentStep = 3;

  RegisterPasswordSetupController(this.repository,);

  @override
  void onInit() {
    otpToken = Get.arguments['otpToken'];
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
        ShowSnack.showSnack(r'error'.tr, SnackType.error);

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
