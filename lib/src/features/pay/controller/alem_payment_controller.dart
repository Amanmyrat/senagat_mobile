

import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/states/stateful_data.dart';

class AlemPaymentController extends PaymentController {
  AlemPaymentController(super.repository);


  @override
  Future<void> onInit() async {
    super.onInit();

  }

  @override
  Future<void> onTap() async {
    if (!continueEnabled) return;

    status = Status.loading;
    update();


  }

}

