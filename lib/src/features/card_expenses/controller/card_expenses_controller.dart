import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';

import '../../../utils/api_error_handler.dart';
import '../../pay/model/paymet_history_model.dart';

class CardExpensesController extends GetxController
    with StateControlMixin {
  late final PageController pageController;
  final PaymentRepository repository;

  List<PaymentHistoryModel> history = [];

  CardExpensesController(this.repository);

  @override
  void onInit() {
    pageController = PageController();
    _loadHistory();
    super.onInit();
  }

  Future<void> _loadHistory() async {
    status = Status.loading;
    try {
      history = await repository.getPaymentHistory();
      status = Status.completed;
      update();
    } catch (e) {
      status = Status.error;
      update();
      ApiErrorHandler.handleApiError(e);
      debugPrint(e.toString());
    }
  }
}
