import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/phone_pay/model/pay_model.dart';

import '../../../core/states/stateful_data.dart';
import '../../dashboard/presentation/dashboard_screen.dart';


class PhonePayVerificationController extends GetxController with StateControlMixin {

  bool check = false;

  final payBox = Hive.box<PayModel>('payBox');
  String payKey = 'pay';


  void startBankVerification() {
    check = true;
    status = Status.loading;
    update();
    Future.delayed(Duration(seconds: 3),(){
      status = Status.completed;
      update();

    });

  }



  void _navigateToNextScreen() {
    try {
      Get.toNamed(DashboardScreen.route,);
    } catch (e) {
      status = Status.error;
      debugPrint('Error navigating to next screen: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();

  }
}

