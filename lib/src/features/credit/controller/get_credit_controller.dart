import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/credit/models/credit_types_model.dart';
import 'package:senagat_mobile/src/features/credit/repository/credit_repository.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/services/show_snack.dart';
import '../../../utils/services/error_utils.dart';
import '../../loan/presentation/loan_screen.dart';

class GetCreditController extends GetxController with StateControlMixin, GetSingleTickerProviderStateMixin {
  double currentValue = 10000;

  late MoneyMaskedTextController sumController;

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
  late int term;
  late double monthlyPayment;

  late int month;

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
    sumController.updateValue(currentValue);
    calculate();
    update();
  }

  void onTabTap(){
    term = tabBarController.index +1;
    month = (term * 12);
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
          final errorText = ErrorUtils.extractErrorText(e);
          ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);

          debugPrint(e.toString());
        });
  }


  Future<void> onTap() async {
    if (continueEnabled) {
      Get.toNamed(LoanScreen.route, arguments: {
        'creditId': creditId,
        'term': term,
        'amount': currentValue.toInt(),
        'monthlyPayment': monthlyPayment,
      });
    }
  }

  @override
  void onInit() {
    getCredits();
    sumController = MoneyMaskedTextController(
      decimalSeparator: '',
      thousandSeparator: ',',
      precision: 0,
    );
    sumController.updateValue(currentValue);

    bidController = TextEditingController();

    paymentController = TextEditingController();
    tabBarController = TabController(length: 3, vsync: this);
    term = tabBarController.index +1;
    month = (term * 12);
    super.onInit();
  }

  getCreditValues() {
    final selectedCredit = _credits.firstWhereOrNull(
      (credit) => credit.name == selectedDropdownValue,
    );

    if (selectedCredit != null) {

      creditId = selectedCredit.id ?? -1;

      interest = selectedCredit.interest!;

      minAmount = selectedCredit.minAmount!.toDouble();
      maxAmount = selectedCredit.maxAmount!.toDouble();

      minAmountStr = formatMoney(selectedCredit.minAmount ?? 0);
      maxAmountStr = formatMoney(selectedCredit.maxAmount ?? 0);

      formatBid(interest);

      calculate();

    } else {
      debugPrint('⚠️ Credit type not found for $selectedDropdownValue');
    }
  }


  void calculate() {
    double totalWithInterest = currentValue + (currentValue * interest / 100);
    monthlyPayment = totalWithInterest / month;

    String formatted;
    if (monthlyPayment % 1 == 0) {
      formatted = monthlyPayment.toInt().toString();
    } else {
      formatted = monthlyPayment.toStringAsFixed(2);
    }

    formatted = formatted.replaceAll('.', ',');

    paymentController.text = formatted;
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

  @override
  void dispose() {
    tabBarController.dispose();
    super.dispose();
  }
}
