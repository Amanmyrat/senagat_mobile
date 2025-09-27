import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';


class NotificationController extends GetxController with StateControlMixin, GetSingleTickerProviderStateMixin {

  late bool isNotificationEmpty = true;
  late bool isLongTap = false;
  late TabController tabController;

  List<String> items = ['1', 'q', 'q', 'h'];

  void onLongTap(){
    if(isLongTap == false){
      isLongTap = true;
    }else{
      isLongTap = false;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
  }
}

