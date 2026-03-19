import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/card/controller/card_controller.dart';
import 'package:senagat_mobile/src/features/home/controller/home_controller.dart';
import '../../../core/states/stateful_data.dart';
import '../../add_card/model/card_model.dart';


class CardSettingsController extends GetxController with StateControlMixin {
  late final TextEditingController cardNickNameController;
  bool continueEnabled = false;
  final cardBox = Hive.box<CardModel>('cardsBox');
  late final String cardNumber;
  late final String nickName;
  late final String cardDesign;
  late String maskedNumber;
  late final int index;
  final homeController = Get.find<HomeController>();
  final cardController = Get.find<CardController>();


  void onChangeNickName() {
    if(continueEnabled) {
      final card = cardBox.getAt(index);
      if (card != null) {
        card.nickName = cardNickNameController.text;
        card.save();
      }
    } else if(cardNickNameController.text.isEmpty){
      cardNickNameController.text = r'Senagat Bank';
    }
    cardController.refresh();
    homeController.refresh();

    status = Status.completed;
    cardNickNameController.clear();
    update();
    Get.back();
  }

  void isTextEmpty(){
    if(cardNickNameController.text.isNotEmpty){
      continueEnabled = true;
      update();
    }else{
      continueEnabled = false;
      update();
    }
  }

  void onClearText(){
    cardNickNameController.clear();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    index = Get.arguments['index'];

    cardNumber = cardBox.getAt(index)?.cardNumber ?? '';
    maskedNumber = hideCardCenter(cardNumber);

    nickName = cardBox.getAt(index)?.nickName.tr ?? '';
    cardDesign = cardBox.getAt(index)?.cardDesign ?? '';
    cardNickNameController = TextEditingController(text: nickName);
  }

  String hideCardCenter(String number) {
    if (number.length < 8) return number;

    final start = number.substring(0, 4);
    final end = number.substring(number.length - 4);
    final hiddenCount = number.length - 11;

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

