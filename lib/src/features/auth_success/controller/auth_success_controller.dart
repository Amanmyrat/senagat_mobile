import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';

import '../../../core/control_state_variable_mixin.dart';
import '../../dashboard/controller/dashboard_controller.dart';

class AuthSuccessController extends GetxController with StateControlMixin {
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
    Future.delayed(const Duration(seconds: 2), () {
      _isBankVerificationComplete = true;
      status = Status.completed;
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {

    try {
      Navigator.of(Get.context!).pushNamedAndRemoveUntil(
        DashboardScreen.route,
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      status = Status.error;
      print('Error navigating to next screen: $e');
    }
  }
}
