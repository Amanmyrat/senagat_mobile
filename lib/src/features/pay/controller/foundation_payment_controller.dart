import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/model/charity_model.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import 'package:senagat_mobile/src/utils/api_error_handler.dart';

class FoundationPaymentController extends PaymentController {
  FoundationPaymentController(PaymentRepository repository) : super(repository);

  late var charityModel = CharityModel();

  @override
  void isTextNotEmpty() {
    continueEnabled =
        phoneController.text.length >= 8 &&
            sumController.text.isNotEmpty &&
            nameController.text.isNotEmpty &&
            lastnameController.text.isNotEmpty &&
            selectedCard != null;
    update();
  }

  Future<CharityModel> _getCharityModel() async {
    return CharityModel(
      bankName: selectedCard?.bank ?? '',
      name: nameController.text,
      surName: lastnameController.text,
      phoneNumber: phoneController.text,
      amount: int.parse(sumController.text),
    );
  }

  @override
  Future<void> onTap() async {
    if (!continueEnabled) return;

    status = Status.loading;
    update();

    String? url;
    String? orderId;

    try {
      final requestModel = await _getCharityModel();
      final result = await repository.charity(data: requestModel.toMap());
      charityModel = result;
      url = charityModel.formUrl;
      orderId = charityModel.orderId;

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
      if (kDebugMode) {debugPrint(e.toString());}
    }
  }
}

