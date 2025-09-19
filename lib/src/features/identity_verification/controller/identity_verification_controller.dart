import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import '../../../core/states/stateful_data.dart';

class IdentityVerificationController extends GetxController with StateControlMixin, GetSingleTickerProviderStateMixin {

  late final TextEditingController nameController;
  late final TextEditingController lastNameController;
  late final TextEditingController surNameController;
  late final TextEditingController dateOfBirthController;
  late final TextEditingController dateIssueController;
  late final TextEditingController passportNumberController;
  late final TextEditingController asController;

  String? selectedDropdownCity;

  bool continueEnabled = false;
  bool check = false;

  final dateOfBirthFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: { "#": RegExp(r'[0-9]') },
  );

  List<String> textFieldTitle = [
    r'name',
    r'last_name',
    r'surname',
    r'date_birth',
    r'passport_number',
    r'date_issue',
  ];

  final List<String> citySelection = [
    "Option 1",
    "Option 2",
    "Option 3",
  ];

  late List<TextEditingController> controllers;

  @override
  void onInit() {
    super.onInit();
    controllers = [
      nameController = TextEditingController(),
      lastNameController = TextEditingController(),
      surNameController = TextEditingController(),
      dateOfBirthController = TextEditingController(),
      passportNumberController = TextEditingController(),
      dateIssueController = TextEditingController(),
      asController = TextEditingController(),
    ];
  }

  void onTextIsNotEmpty(String? v){
    if(nameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        surNameController.text.isNotEmpty &&
        dateOfBirthController.text.isNotEmpty &&
        passportNumberController.text.isNotEmpty &&
        dateIssueController.text.isNotEmpty &&
        asController.text.isNotEmpty &&
        selectedDropdownCity != null){
      continueEnabled = true;
      update();
    }else{
      continueEnabled = false;
      update();
    }
  }

  void setDropdownCity(String? value) {
    selectedDropdownCity = value;
    onTextIsNotEmpty(value);
    update();
  }


  void startBankVerification() {
    check = true;
    status = Status.loading;
    update();
    Future.delayed(Duration(seconds: 3),(){
      status = Status.completed;
      update();

    });

  }

  @override
  void onClose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.onClose();
  }
}