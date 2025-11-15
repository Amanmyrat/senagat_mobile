import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
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
  late Box accountsBox;


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

    accountsBox = Hive.box('accountsBox');

    controllers = [
      stateTrafficController = TextEditingController(),
      waterController = TextEditingController(),
      gasController = TextEditingController(),
      lightController = TextEditingController(),
      internetController = TextEditingController(),
      homePhoneController = TextEditingController(),
    ];

    _loadSavedValues();


  }

  void _loadSavedValues() {
    for (int i = 0; i < serviceNames.length; i++) {
      String key = serviceNames[i];
      String? savedValue = accountsBox.get(key);

      if (savedValue != null) {
        controllers[i].text = savedValue;
      }
    }
    update();
  }


  void saveServiceValue(int index) {
    String key = serviceNames[index];
    String value = controllers[index].text;

    accountsBox.put(key, value);
    update();
  }

  void onTextIsNotEmpty(String? v, int index) {
    continueEnabled = controllers[index].text.isNotEmpty;
    update();
  }


  @override
  void onClose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.onClose();
  }
}