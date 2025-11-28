import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import '../../../core/states/stateful_data.dart';
import '../../add_card/model/card_model.dart';


class CardSettingsController extends GetxController with StateControlMixin {
  late final TextEditingController cardNumberController;
  bool continueEnabled = false;
  final cardBox = Hive.box<CardModel>('cardsBox');
  late final String cardNumber;
  late String maskedNumber;
  late final int index;

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
    super.onInit();
    index = Get.arguments['index'];

    cardNumber = cardBox.getAt(index)?.cardNumber ?? '';
    maskedNumber = hideCardCenter(cardNumber);

    cardNumberController = TextEditingController();
  }

  String hideCardCenter(String number) {
    if (number.length < 8) return number;

    final start = number.substring(0, 4);
    final end = number.substring(number.length - 4);
    final hiddenCount = number.length - 7;

    final hidden = '*' * hiddenCount;

    final masked = '$start$hidden$end';

    final buffer = StringBuffer();
    for (int i = 0; i < masked.length; i++) {
      buffer.write(masked[i]);
      if ((i + 1) % 4 == 0 && i != masked.length - 1) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }


}

