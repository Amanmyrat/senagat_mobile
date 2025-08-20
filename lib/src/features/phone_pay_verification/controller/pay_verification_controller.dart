import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/phone_pay/model/pay_model.dart';
import '../../../core/states/stateful_data.dart';

class PhonePayVerificationController extends GetxController with StateControlMixin {

  bool check = false;

  final payBox = Hive.box<PayModel>('payBox');
  String payKey = 'pay';


  void startBankVerification() {
    saveCard();
    check = true;
    status = Status.loading;
    update();
    Future.delayed(Duration(seconds: 3),(){
      status = Status.completed;
      update();

    });

  }

  Future<void> saveCard() async {
    final box = Hive.box<PayModel>(payBox.get(payKey)!.serviceIcon.isEmpty?'payFoundationBox': '');
    final pay = PayModel(
      serviceName: payBox.get(payKey)?.serviceName ?? '',
      serviceIcon: payBox.get(payKey)?.serviceIcon ?? '',
      number: payBox.get(payKey)?.number ?? '',
      sum: payBox.get(payKey)?.sum ?? '',
      userName: payBox.get(payKey)?.userName ?? '',
    );
    await box.add(pay);
  }

}

