import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/pay/model/pay_model.dart';
import '../../../core/states/stateful_data.dart';

class PaymentVerificationController extends GetxController with StateControlMixin {

  bool check = false;

  late String? serviceName;
  late String? serviceIcon;
  late String? number;
  late String? sum;
  late String? userName;

  @override
  void onInit() {
    serviceName = Get.arguments['serviceName'];
    serviceIcon = Get.arguments['serviceIcon'];
    number = Get.arguments['number'];
    sum = Get.arguments['sum'];
    userName = Get.arguments['userName'];
    super.onInit();
  }

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
    final box = Hive.box<PayModel>(serviceIcon!.isEmpty ? 'payFoundationBox' : 'payBox');
    final pay = PayModel(
      serviceName: serviceName ?? '',
      serviceIcon: serviceIcon ?? '',
      number: number ?? '',
      sum: sum ?? '',
      userName: userName ?? '',
    );
    await box.add(pay);
  }

}

