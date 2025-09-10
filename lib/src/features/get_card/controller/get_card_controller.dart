import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';

import '../../../core/states/stateful_data.dart';
import '../../get_card_details/presentation/get_card_details_screen.dart';


class GetCardController extends GetxController with StateControlMixin, GetSingleTickerProviderStateMixin {

  late TabController tabController;
  int selectedTabIndex = 0;

  final List<String> tabLabels = [
    r'Salary',
    r'Deposit',
    r'Family',
    r'Overdraft',
  ];

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      selectedTabIndex = tabController.index;
      update();
    });
  }
  void onTap(){
    Get.toNamed(GetCardDetailsScreen.route, arguments: {
      'selectedCard': currentTabText,
    });
  }
  String get currentTabText => tabLabels[selectedTabIndex];
}