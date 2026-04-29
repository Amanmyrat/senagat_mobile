import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/model/belet_balances_model.dart';
import 'package:senagat_mobile/src/features/pay/model/belet_top_up_model.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import 'package:senagat_mobile/src/utils/api_error_handler.dart';

class BeletPaymentController extends PaymentController {
  BeletPaymentController(PaymentRepository repository) : super(repository);

  final _beletBalances = <BeletBalanceModel>[];
  List<BeletBalanceModel> get beletBalances => _beletBalances;

  late var beletTopUpModel = BeletTopUpModel();

  final phoneBox = Hive.box<String>('phoneBox');

  @override
  void onInit() {
    super.onInit();
    if (serviceName == 'Belet') {
      getBeletBalances();
    }
  }

  @override
  void isTextNotEmpty() {
    continueEnabled = phoneController.text.length >= 8 &&
        sumController.text.isNotEmpty &&
        selectedCard != null;

    update();
  }

  Future<void> getBeletBalances() async {
    status = Status.loading;
    update();

    try {
      final value = await repository.getBalance();

      _beletBalances.clear();
      _beletBalances.addAll(value);

      status = Status.completed;
    } catch (e) {
      status = Status.error;
      debugPrint("ERROR => $e");
      ApiErrorHandler.handleApiError(e);
    } finally {
      update();
    }
  }

  Future<BeletTopUpModel> _getBeletTopUpModel() async {
    return BeletTopUpModel(
      bankName: selectedCard?.bank ?? '',
      amount: int.parse(sumController.text),
      phone: '993${phoneController.text}',
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
      final requestModel = await _getBeletTopUpModel();
      final result = await repository.beletTopUp(data: requestModel.toMap());
      beletTopUpModel = result;
      url = beletTopUpModel.formUrl;
      orderId = beletTopUpModel.orderId;

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

