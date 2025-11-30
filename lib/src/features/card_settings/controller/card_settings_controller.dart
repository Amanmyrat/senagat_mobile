import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/card/controller/card_controller.dart';
import 'package:senagat_mobile/src/features/dashboard/controller/dashboard_controller.dart';
import 'package:senagat_mobile/src/features/dashboard/utils/nested_nav_ids.dart';
import 'package:senagat_mobile/src/features/home/controller/home_controller.dart';
import '../../../core/states/stateful_data.dart';
import '../../add_card/model/card_model.dart';


class CardSettingsController extends GetxController with StateControlMixin {
  late final TextEditingController cardNumberController;
  bool continueEnabled = false;
  final cardBox = Hive.box<CardModel>('cardsBox');
  late final String cardNumber;
  late String maskedNumber;
  late final int index;
  final homeController = Get.find<HomeController>();
  final cardController = Get.find<CardController>();


  void onChangeNickName() {
    final card = cardBox.getAt(index);
    if (card != null) {
      card.nickName = cardNumberController.text;
      card.save();
    }
    if(cardNumberController.text.isEmpty){
      cardNumberController.text = r'Senagat Bank';
    }
    cardController.refresh();
    homeController.refresh();

    status = Status.completed;
    cardNumberController.clear();
    update();
    Get.back();
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

    cardNumberController = TextEditingController(text: cardBox.getAt(index)?.nickName);
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

