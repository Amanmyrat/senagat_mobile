import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';

import '../../../core/states/stateful_data.dart';


class LoanController extends GetxController with StateControlMixin, GetSingleTickerProviderStateMixin {

  late final TextEditingController nameController;
  late final TextEditingController lastNameController;
  late final TextEditingController surNameController;
  late final TextEditingController bothDateController;
  late final TextEditingController passportNumberController;
  late final TextEditingController dateIssueController;

  late final TextEditingController patentNumController;
  late final TextEditingController workAddressController;
  late final TextEditingController registrNumController;

  late final TextEditingController workplaceController;
  late final TextEditingController positionAtWorkController;
  late final TextEditingController workAddress2Controller;
  late final TextEditingController wagesController;
  late final TextEditingController phoneController;

  String? selectedDropdownIssuance;
  String? selectedDropdownCity;
  String? selectedDropdownBank;
  bool continueEnabled = false;
  bool check = false;
  int pageIndex = 1;

  late TabController tabController;
  int selectedTabIndex = 0;

  List<String> textFieldTitle = [
    r'Имя',
    r'Фамилия',
    r'Отчество',
    r'Дата рождения',
    r'Номер паспорта',
    r'Дата выдачи',
  ];

  final List<String> issuanceSelection = [
    "Option 1",
    "Option 2",
    "Option 3",
  ];

  final List<String> citySelection = [
    "Option 1",
    "Option 2",
    "Option 3",
  ];

  final List<String> bankSelection = [
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
      bothDateController = TextEditingController(),
      passportNumberController = TextEditingController(),
      dateIssueController = TextEditingController(),
    ];
    patentNumController = TextEditingController();
    workAddressController  = TextEditingController();
    registrNumController  = TextEditingController();

    workplaceController = TextEditingController();
    positionAtWorkController = TextEditingController();
    workAddress2Controller = TextEditingController();
    wagesController = TextEditingController();
    phoneController = TextEditingController();

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTabIndex = tabController.index;
      update();
    });
  }

  void onTextIsNotEmpty(String? v){
    if(nameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        surNameController.text.isNotEmpty &&
        bothDateController.text.isNotEmpty &&
        passportNumberController.text.isNotEmpty &&
        dateIssueController.text.isNotEmpty &&
        selectedDropdownIssuance != null){
      continueEnabled = true;
      update();
    }else{
      continueEnabled = false;
      update();
    }
  }

  void onInformationNotEmpty(String? v){
    if(selectedTabIndex == 1){
      if(phoneController.text.length >= 8 &&
          workplaceController.text.isNotEmpty &&
          positionAtWorkController.text.isNotEmpty &&
          workAddress2Controller.text.isNotEmpty &&
          wagesController.text.isNotEmpty){
        continueEnabled = true;
        update();
      }else{
        continueEnabled = false;
        update();
      }

    }else if(selectedTabIndex == 0){
      if(patentNumController.text.isNotEmpty &&
          registrNumController.text.isNotEmpty &&
          workAddressController.text.isNotEmpty) {
        continueEnabled = true;
        update();
      }else{
        continueEnabled = false;
        update();
      }
    }
  }

  void setDropdownCity(String? value) {
    selectedDropdownCity = value;
    if(selectedDropdownBank!.isNotEmpty){
      continueEnabled = true;
    }
    update();
  }

  void setDropdownIssuance(String? value) {
    selectedDropdownIssuance = value;
    onTextIsNotEmpty(value);
    update();
  }

  void onTap(){
    if(pageIndex == 1 && continueEnabled){
      pageIndex = 2;
      continueEnabled = false;
      update();
    }else if(pageIndex == 2 && continueEnabled){
      pageIndex = 3;
      continueEnabled = false;
      update();
    }else if(pageIndex == 3 && continueEnabled){
      startBankVerification();
      update();
    }

  }
  void onBack(){
    if(pageIndex == 1){
      Get.back();
      update();
    }else if(pageIndex == 2 ){
      pageIndex = 1;
      update();
    }else if(pageIndex == 3){
      pageIndex = 2;
      update();
    }

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

  void setDropdownBank(String? value) {
    selectedDropdownBank = value;
    if(selectedDropdownCity!.isNotEmpty){
      continueEnabled = true;
    }
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