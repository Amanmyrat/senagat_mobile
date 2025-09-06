import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';

class CardExpensesController extends GetxController with StateControlMixin {
  late final PageController pageController;


  @override
  void onInit() {
    pageController = PageController();


    super.onInit();
  }


}
