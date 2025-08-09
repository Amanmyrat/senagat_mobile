import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:senagat_mobile/src/features/register_password_setup/controller/register_password_setup_controller.dart';

import '../../../core/control_state_variable_mixin.dart';

class AuthSuccessController extends GetxController with StateControlMixin{

  bool _isBankVerificationComplete = false;
  bool get isBankVerificationComplete => _isBankVerificationComplete;

  @override
  void onInit() {
    super.onInit();
    _startBankVerification();
  }

  void _startBankVerification() {
    status = Status.loading;
    // Simulate bank verification process
    Future.delayed(const Duration(seconds: 3), () {
      _isBankVerificationComplete = true;
      status = Status.completed;
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    try {
      Get.toNamed(DashboardScreen.route);
    } catch (e) {
      status = Status.error;
      print('Error navigating to next screen: $e');
    }
  }

}
