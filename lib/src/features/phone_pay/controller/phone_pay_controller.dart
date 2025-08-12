import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/home/controller/home_controller.dart';
import 'package:senagat_mobile/src/features/phone_pay_verification/presentation/phone_pay_verification_screen.dart';
import 'package:senagat_mobile/src/features/service_settings/controller/service_settings_controller.dart';

import '../model/pay_model.dart';

class PhonePayController extends GetxController with StateControlMixin {
  final GlobalKey<FormState> key;
  bool continueEnabled = false;

  PhonePayController(this.key);

  late final TextEditingController phoneController;
  late final TextEditingController sumController;
  late ServiceSettingsController serviceSettingsController;

  String serviceName = '';
  String serviceIcon = '';


  late final FocusNode phoneFocus;

  @override
  void onInit() {
    serviceName = Get.arguments['selectedServiceTitle'];
    serviceIcon = Get.arguments['selectedServiceIcon'];

    serviceSettingsController = Get.find<ServiceSettingsController>();

    phoneController = TextEditingController();
    phoneFocus = FocusNode();
    sumController = TextEditingController();

    super.onInit();
  }

  void onPayTap() async {
    saveCard();

    status = Status.loading;
      update();
      await Future.delayed( Duration(seconds: 2), (){
      });
      status = Status.completed;

      update();
      Get.toNamed(PhonePayVerificationScreen.route,);
  }

  Future<void> saveCard() async {
    final box = Hive.box<PayModel>('payBox');
    final pay = PayModel(
        serviceName: serviceName,
        serviceIcon: serviceIcon,
        number: phoneController.text,
        sum: sumController.text,
        userName: '',
    );
    await box.put('pay',pay);
  }

  void onPhoneTextChanged(String val) {
    continueEnabled = val.length >= 8;
    update();
  }


  @override
  void dispose() {
    phoneController.dispose();
    phoneFocus.dispose();

    sumController.dispose();

    super.dispose();
  }
}
