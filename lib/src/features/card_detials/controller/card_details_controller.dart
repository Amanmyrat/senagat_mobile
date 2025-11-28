import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';

import '../../add_card/model/card_model.dart';


class CardDetailsController extends GetxController with StateControlMixin {
  final cardBox = Hive.box<CardModel>('cardsBox');
  late final String cardNumber;
  late final String cardName;
  late final String cardTerm;
  late final int index;

  @override
  void onInit() {
    super.onInit();
    index = Get.arguments['index'];

    cardNumber = cardBox.getAt(index)?.cardNumber ?? '';
    cardName = cardBox.getAt(index)?.name ?? '';
    cardTerm = cardBox.getAt(index)?.expiryDate ?? '';

  }
}

