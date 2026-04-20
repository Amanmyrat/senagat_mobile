import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';

import '../../add_card/model/card_model.dart';


class CardDetailsController extends GetxController with StateControlMixin {
  final cardBox = Hive.box<CardModel>('cardsBox');
  late final String cardNumber;
  late final String cardName;
  late final String cardTerm;
  late final dynamic key;
  CardModel? card;
  late String maskedNumber;

  @override
  void onInit() {
    super.onInit();
    key = Get.arguments['key'];
    card = cardBox.get(key);

    cardNumber = card?.cardNumber ?? '';
    maskedNumber = hideCardCenter(cardNumber);

    cardName = card?.name ?? '';
    cardTerm = card?.expiryDate ?? '';

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


  @override
  void dispose() {
    super.dispose();
  }
}

