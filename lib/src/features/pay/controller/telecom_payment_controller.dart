import 'package:flutter/material.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/utils/api_error_handler.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/model/belet_top_up_model.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';

import '../model/telecom_top_up_model.dart';

class TelecomPaymentController extends PaymentController {
  TelecomPaymentController(PaymentRepository repository) : super(repository);

  late var telecomTopUpModel = TelecomTopUpModel();

  String _cleanSpaces(String phoneNumber) {
    return phoneNumber.replaceAll(' ', '');
  }

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
        phone: _cleanSpaces(phoneController.text),
      );

      final result =
          await repository.telecomPay(data: requestModel.toMap());
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
    }
  }
}

