import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/credit/models/credit_types_model.dart';
import 'package:senagat_mobile/src/features/credit/repository/credit_repository.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';
import '../../loan/presentation/loan_screen.dart';

class GetCreditController extends GetxController
    with StateControlMixin, GetTickerProviderStateMixin {
  late TextEditingController sumController;
  late TextEditingController bidController;
  late TextEditingController paymentController;

  late TabController tabBarController;
  final _credits = <CreditTypeModel>[];

  late String minAmountStr;
  late String maxAmountStr;

  late double minAmount;
  late double maxAmount;
  late int interest;

  late int creditId;
  int term = 1;
  late double monthlyPayment;
  late String minMonthlyPayment;

  late int month;

  double currentValue = 0;

  List<CreditTypeModel> get credits => _credits;

  String? selectedDropdownValue;
  bool continueEnabled = false;

  CreditRepository repository;

  GetCreditController(this.repository);

  void setDropdownValue(String? value) {
    selectedDropdownValue = value;

    getCreditValues();

    onTextIsNotEmpty(value);
    update();
  }

  void onTextIsNotEmpty(String? v) {
    if (sumController.text.isNotEmpty &&
        bidController.text.isNotEmpty &&
        paymentController.text.isNotEmpty) {
      continueEnabled = true;
    } else {
      continueEnabled = false;
    }
    update();
  }

  void updateText(double value) {
    currentValue = value;

    sumController.text = sumFormat(value);

    calculate();
    update();
  }

  void onTabTap() {
    tabBarController.index;
    month = ((tabBarController.index + 1) * 12);
    updateText(currentValue);
  }

  void getCredits() async {
    status = Status.loading;
    update();
    await repository
        .getCreditTypes()
        .then((value) {
          _credits.addAll(value);

          status = Status.completed;
          update();
        })
        .catchError((e) {
          status = Status.error;
          update();
          ApiErrorHandler.handleApiError(e);
        });
  }

  Future<void> onTap() async {
    if (continueEnabled) {
      Get.toNamed(
        LoanScreen.route,
        arguments: {
          'creditId': creditId,
          'term': tabBarController.index + 1,
          'amount': currentValue.toInt(),
          'monthlyPayment': monthlyPayment,
          'minMonthlyPayment': minMonthlyPayment,
        },
      );
    }
  }

  @override
  void onInit() {
    getCredits();
    sumController = TextEditingController();

    bidController = TextEditingController();

    paymentController = TextEditingController();
    tabBarController = TabController(length: term, vsync: this);
    month = ((tabBarController.index + 1) * 12);
    super.onInit();
  }

  getCreditValues() {
    final selectedCredit = _credits.firstWhereOrNull(
      (credit) => credit.title == selectedDropdownValue,
    );

    if (selectedCredit != null) {
      creditId = selectedCredit.id ?? -1;

      interest = selectedCredit.interest!;

      minAmount = selectedCredit.minAmount!.toDouble();
      maxAmount = selectedCredit.maxAmount!.toDouble();

      currentValue = minAmount;
      sumController.text = sumFormat(currentValue);

      minAmountStr = formatMoney(selectedCredit.minAmount ?? 0);
      maxAmountStr = formatMoney(selectedCredit.maxAmount ?? 0);

      term = selectedCredit.term!;

      tabBarController.dispose();

      tabBarController = TabController(
        length: term,
        vsync: this,
        initialIndex: 0,
      );

      month = ((tabBarController.index + 1) * 12);
      formatBid(interest);

      calculate();
    }
  }

  void calculate() {
    month = ((tabBarController.index + 1) * 12);

    double totalWithInterest = (currentValue * interest / 100);
    monthlyPayment = totalWithInterest / 12;
    double a = currentValue / month;
    double result = monthlyPayment + a;

    double result2 = result * 2;

    String formatted;
    if (result % 1 == 0) {
      formatted = result.toInt().toString();
    } else {
      formatted = result.toStringAsFixed(2);
    }
    formatted = formatted.replaceAll('.', ',');

    paymentController.text = formatted;


    String formatted2;
    if (result2 % 1 == 0) {
      formatted2 = result2.toInt().toString();
    } else {
      formatted2 = result2.toStringAsFixed(2);
    }
    formatted2 = formatted2.replaceAll('.', ',');

    minMonthlyPayment = formatted2;


    update();
  }

  void formatBid(int value) {
    String formatted;

    if (value % 1 == 0) {
      formatted = value.toInt().toString();
    } else {
      formatted = value.toStringAsFixed(2);
    }

    formatted = '${formatted.replaceAll('.', ',')}%';

    bidController.text = formatted;
  }

  String formatMoney(int value) {
    final formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(value);
  }

  String sumFormat(double value) {
    final formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(value);
  }

  @override
  void dispose() {
    tabBarController.dispose();
    super.dispose();
  }
}
