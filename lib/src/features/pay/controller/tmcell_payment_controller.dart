import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';
import '../model/telecom_top_up_model.dart';

class TmcellPaymentController extends PaymentController {
  TmcellPaymentController(PaymentRepository repository) : super(repository);

  late var telecomTopUpModel = TelecomTopUpModel();

  final phoneBox = Hive.box<String>('phoneBox');


  @override
  Future<void> onTap() async {
    if (!continueEnabled) return;

    status = Status.loading;
    update();

    String? url;
    String? orderId;

    try {
      final requestModel = TelecomTopUpModel(
        bankName: selectedCard?.bank ?? '',
        amount: int.parse(sumController.text),
        phone: phoneController.text,
      );

      final result =
      await repository.tmcellPay(data: requestModel.toMap());
      telecomTopUpModel = result;
      url = telecomTopUpModel.formUrl;
      orderId = telecomTopUpModel.orderId;

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

