import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';

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
 late final int index;

 void startBankVerification() {
   check = true;
   status = Status.loading;
   update();
   Future.delayed(Duration(seconds: 1),(){
     cardBox.deleteAt(index);
     status = Status.completed;
     update();

   });

   Future.delayed(const Duration(seconds: 4), () async {
     check = false;
     update();
     goBack();
   });
 }
 void goBack(){
   Get.offNamed(DashboardScreen.route);
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
   index = Get.arguments['index'];

   cardNumber = hideCardCenter(cardBox.getAt(index)?.cardNumber ?? '');
   cardName = cardBox.getAt(index)?.name ?? '';
   cardTerm = cardBox.getAt(index)?.expiryDate ?? '';
   cardDesign = cardBox.getAt(index)?.cardDesign ?? '';
   super.onInit();
  }
}