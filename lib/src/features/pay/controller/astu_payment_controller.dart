import 'package:flutter/cupertino.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/model/astu_top_up_model.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';
import '../model/telecom_top_up_model.dart';

class AstuPaymentController extends PaymentController {
  AstuPaymentController(super.repository);

  late var astuTopUpModel = AstuTopUpModel();
  late var telecomTopUpModel = TelecomTopUpModel();

  @override
  Future<void> onTap() async {
    if (!continueEnabled) return;

    status = Status.loading;
    update();

    String? url;
    String? orderId;

    String type = '';

    if (serviceName == 'IP TV') {
      type = 'iptv';
    } else if (serviceName == 'astu_phone') {
      type = 'phone';
    } else if (serviceName == 'astu_internet') {
      type = 'internet';
    } else if (serviceName == 'CDMA') {
      type = 'cdma';
    }

    if (type == 'cdma') {
      status = Status.loading;
      update();

      try {
        final requestModel = TelecomTopUpModel(
          bankName: selectedCard?.bank ?? '',
          amount: int.parse(sumController.text),
          phone: phoneController.text,
        );

        final result =
        await repository.cdmaPay(data: requestModel.toMap());
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


    String _clean12(String phoneNumber) {
      return phoneNumber.replaceAll('12 ', '').replaceAll(' ', '');
    }

    try {
      final requestModel = AstuTopUpModel(
        bankName: selectedCard?.bank ?? '',
        amount: int.parse(sumController.text),
        phone: _clean12(phoneController.text),
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

