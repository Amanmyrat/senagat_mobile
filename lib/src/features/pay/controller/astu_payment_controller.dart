import 'package:flutter/cupertino.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/model/astu_top_up_model.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';

class AstuPaymentController extends PaymentController {
  AstuPaymentController(super.repository);

  late var astuTopUpModel = AstuTopUpModel();

  @override
  Future<void> onTap() async {
    if (!continueEnabled) return;

    status = Status.loading;
    update();

    String? url;
    String? orderId;

    String type = '';

    if(serviceName == 'IP TV'){
      type = 'iptv';
    }else if(serviceName == 'home_phone'){
      type = 'phone';
    }else if(serviceName == 'astu_internet'){
      type = 'internet';
    }else if(serviceName == 'CDMA'){
      type = 'cdma';
    }

    try {
      final requestModel = AstuTopUpModel(
        bankName: selectedCard?.bank ?? '',
        amount: int.parse(sumController.text),
        phone: phoneController.text,
        type: type,
      );

      final result =
      await repository.astuPay(data: requestModel.toMap());
      astuTopUpModel = result;
      url = astuTopUpModel.formUrl;
      orderId = astuTopUpModel.orderId;

      if (url == null || url.isEmpty) {
        throw Exception('Payment URL is empty');
      }

      if (orderId == null || orderId.isEmpty) {
        throw Exception('Payment orderId is empty');
      }

      await openBankPayment(url, orderId);
    } catch (e) {
      status = Status.error;
      update();
      ApiErrorHandler.handleApiError(e);
      debugPrint(e.toString());
    }
  }
}

