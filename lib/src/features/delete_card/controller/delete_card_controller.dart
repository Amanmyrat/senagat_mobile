import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/features/card/controller/card_controller.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:senagat_mobile/src/features/home/controller/home_controller.dart';

import '../../../core/control_state_variable_mixin.dart';
import 'package:get/get.dart';

import '../../../core/states/stateful_data.dart';
import '../../add_card/model/card_model.dart';

class DeleteCardController extends GetxController with StateControlMixin {
 late bool check = false;
 final cardBox = Hive.box<CardModel>('cardsBox');
 late final String cardNumber;
 late final String cardName;
 late final String cardTerm;
 late final String cardDesign;
 late final dynamic key;
 CardModel? card;


 void startBankVerification() {
   check = true;
   status = Status.loading;
   update();

   Future.delayed(Duration(seconds: 1), () {
     cardBox.delete(key);
     status = Status.completed;
     update();
   });

   Future.delayed(const Duration(seconds: 2), () async {
     check = false;
     update();
     goBack();
   });
 }

 void goBack(){
   final cardController = Get.find<CardController>();
   final homeController = Get.find<HomeController>();
   Get.back(); // close delete screen
   Get.back(); // close settings
   cardController.update();
   homeController.update();
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
 void onInit() {
   super.onInit();

   key = Get.arguments['key'];
   card = cardBox.get(key);

   cardNumber = hideCardCenter(card?.cardNumber ?? '');
   cardName = card?.name ?? '';
   cardTerm = card?.expiryDate ?? '';
   cardDesign = card?.cardDesign ?? '';
 }
}