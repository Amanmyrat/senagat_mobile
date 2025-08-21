import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/service_settings/controller/service_settings_controller.dart';

import '../../pay_verification/presentation/pay_verification_screen.dart';
import '../model/pay_model.dart';

class PayController extends GetxController with StateControlMixin {
  final GlobalKey<FormState> key;
  bool continueEnabled = false;

  PayController(this.key);

  late final TextEditingController phoneController;
  late final TextEditingController sumController;
  late final TextEditingController nameController;
  late ServiceSettingsController serviceSettingsController;

  String serviceName = '';
  String serviceIcon = '';


  late final FocusNode phoneFocus;

  @override
  void onInit() {
    try{
      serviceName = Get.arguments['selectedServiceTitle'];
      serviceIcon = Get.arguments['selectedServiceIcon'];
    }catch(e){
      print(e);
    }


    serviceSettingsController = Get.find<ServiceSettingsController>();

    phoneController = TextEditingController();
    phoneFocus = FocusNode();
    sumController = TextEditingController();
    nameController = TextEditingController();

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
      Get.offNamed(PayVerificationScreen.route,);
  }

  Future<void> saveCard() async {
    final box = Hive.box<PayModel>('payBox');
    final pay = PayModel(
      serviceName: serviceName,
      serviceIcon: serviceIcon,
      number: phoneController.text,
      sum: sumController.text,
      userName: nameController.text,
    );
    await box.put('pay', pay);
  }

  void isTextNotEmpty(){
    serviceIcon.isEmpty?
    phoneController.text.length >= 8 && sumController.text.isNotEmpty && nameController.text.isNotEmpty ? continueEnabled = true: continueEnabled = false:
    phoneController.text.length >= 8 && sumController.text.isNotEmpty ? continueEnabled = true : continueEnabled = false;
    update();
  }

  @override
  void dispose() {
    phoneController.dispose();
    phoneFocus.dispose();

    sumController.dispose();
    nameController.dispose();

    super.dispose();
  }
}
