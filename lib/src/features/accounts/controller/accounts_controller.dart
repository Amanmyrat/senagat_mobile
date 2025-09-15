import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';


class AccountsController extends GetxController with StateControlMixin, GetSingleTickerProviderStateMixin {

  late final TextEditingController stateTrafficController;
  late final TextEditingController waterController;
  late final TextEditingController gasController;
  late final TextEditingController lightController;
  late final TextEditingController internetController;
  late final TextEditingController homePhoneController;

  String? selectedDropdownIssuance;
  String? selectedDropdownCity;
  String? selectedDropdownBank;
  bool continueEnabled = false;
  bool check = false;
  int pageIndex = 1;

  List<String> serviceNames = [
    r'state_traffic_safety_inspectorate',
    r'water',
    r'gas',
    r'light',
    r'internet',
    r'home_phone',
  ];


  late List<TextEditingController> controllers;

  @override
  void onInit() {
    super.onInit();
    controllers = [
      stateTrafficController = TextEditingController(),
      waterController = TextEditingController(),
      gasController = TextEditingController(),
      lightController = TextEditingController(),
      internetController = TextEditingController(),
      homePhoneController = TextEditingController(),
    ];

  }

  void onTextIsNotEmpty(String? v,int index){
    if(controllers[index].text.isNotEmpty){
      continueEnabled = true;
      update();
    }else{
      continueEnabled = false;
      update();
    }
  }


  @override
  void onClose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.onClose();
  }
}