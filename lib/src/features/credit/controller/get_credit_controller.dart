import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';


class GetCreditController extends GetxController with StateControlMixin {

  double currentValue = 10000;
  late final TextEditingController sumController;

  late TabController tabBarController ;

  String? selectedDropdownValue;
  bool continueEnabled = false;

  final List<String> dropdownItems = [
    "Option 1",
    "Option 2",
    "Option 3",
  ];


  void setDropdownValue(String? value) {
    selectedDropdownValue = value;
    continueEnabled = true;
    update();
  }

  void updateText(double value) {
    currentValue = value;
    sumController.text = NumberFormat('#,###').format(currentValue);
    update();
  }

  @override
  void onInit() {

    sumController = TextEditingController();
    sumController.text = NumberFormat('#,###').format(currentValue);
    super.onInit();
  }

  @override
  void dispose() {
    tabBarController.dispose();
    super.dispose();
  }


}