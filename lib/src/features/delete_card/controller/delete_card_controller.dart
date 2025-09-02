import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';

import '../../../core/control_state_variable_mixin.dart';
import 'package:get/get.dart';

import '../../../core/states/stateful_data.dart';

class DeleteCardController extends GetxController with StateControlMixin {
 late bool check = false;

 void startBankVerification() {
   check = true;
   status = Status.loading;
   update();
   Future.delayed(Duration(seconds: 3),(){
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
}