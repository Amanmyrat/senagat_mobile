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
 late final int index;

 void startBankVerification() {
   check = true;
   status = Status.loading;
   update();
   Future.delayed(Duration(seconds: 3),(){
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

 @override
  void onInit() {
   index = Get.arguments['index'];

   cardNumber = cardBox.getAt(index)?.cardNumber ?? '';
   cardName = cardBox.getAt(index)?.name ?? '';
   cardTerm = cardBox.getAt(index)?.expiryDate ?? '';
   super.onInit();
  }
}