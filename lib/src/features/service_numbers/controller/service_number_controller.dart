import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';

import '../../../core/states/stateful_data.dart';


class ServiceNumberController extends GetxController with StateControlMixin, GetSingleTickerProviderStateMixin {

  late final TextEditingController nameController;
  late final TextEditingController lastNameController;
  late final TextEditingController surNameController;
  late final TextEditingController bothDateController;
  late final TextEditingController passportNumberController;
  late final TextEditingController dateIssueController;

  String? selectedDropdownIssuance;
  String? selectedDropdownCity;
  String? selectedDropdownBank;
  bool continueEnabled = false;
  bool check = false;
  int pageIndex = 1;

  List<String> serviceNames = [
    r'ГАИ',
    r'water',
    r'gas',
    r'ligth',
    r'Интернет',
    r'Дом. телефон',
  ];


  late List<TextEditingController> controllers;

  @override
  void onInit() {
    super.onInit();
    controllers = [
      nameController = TextEditingController(),
      lastNameController = TextEditingController(),
      surNameController = TextEditingController(),
      bothDateController = TextEditingController(),
      passportNumberController = TextEditingController(),
      dateIssueController = TextEditingController(),
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