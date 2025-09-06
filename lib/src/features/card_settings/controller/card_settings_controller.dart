import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import '../../../core/states/stateful_data.dart';


class CardSettingsController extends GetxController with StateControlMixin {
  late final TextEditingController cardNumberController;
  bool continueEnabled = false;

  void onTextChanged(String val) {
    continueEnabled = cardNumberController.text.isNotEmpty;
    update();
  }
  void startBankVerification() {
    status = Status.loading;
    update();
    Future.delayed(Duration(seconds: 3),(){
      status = Status.completed;
      cardNumberController.clear();
      Get.back();
    });

  }

  void onClearText(){
    cardNumberController.clear();
    update();
  }

  @override
  void onInit() {
    cardNumberController = TextEditingController();
    super.onInit();
  }
}

