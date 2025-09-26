import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';

class GetCreditController extends GetxController with StateControlMixin {

  double currentValue = 10000;

  late MoneyMaskedTextController sumController;

  late TextEditingController bidController;
  late TextEditingController paymentController;

  late TabController tabBarController;

  String? selectedDropdownValue;
  bool continueEnabled = false;

  final List<String> dropdownItems = [
    r'credit_for_newlyweds',
    r'consumer_credit',
    r'student_loan',
  ];

  void setDropdownValue(String? value) {
    selectedDropdownValue = value;
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
    update();
  }

  @override
  void onInit() {
    sumController = MoneyMaskedTextController(
      decimalSeparator: '',
      thousandSeparator: ',',
      precision: 0,
    );
    sumController.updateValue(currentValue);

    bidController = TextEditingController();
    bidController.text = '1%';
    paymentController = TextEditingController();
    paymentController.text = '100';

    super.onInit();
  }

  @override
  void dispose() {
    tabBarController.dispose();
    super.dispose();
  }
}
