import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/payment_verification/presentation/payment_verification_screen.dart';


class GetCardDetailsController extends GetxController with StateControlMixin {

  late final TextEditingController nameController;
  late final TextEditingController lastNameController;
  late final TextEditingController surNameController;
  late final TextEditingController bothDateController;
  late final TextEditingController passportNumberController;
  late final TextEditingController dateIssueController;
  late final TextEditingController addressController;
  late final TextEditingController phoneController;

  String? selectedCard;
  String? selectedDropdownType;
  String? selectedDropdownBranch;
  String? selectedDropdownIssuance;
  bool continueEnabled = false;
  int pageIndex = 1;


  List<String> textFieldTitle = [
    r'name'.tr,
    r'Last_name'.tr,
    r'Surname'.tr,
    r'Date_birth'.tr,
    r'Passport_number'.tr,
    r'date_issue'.tr,
  ];

  final List<String> typeSelection = [
    "Option 1",
    "Option 2",
    "Option 3",
  ];


  final List<String> branchSelection = [
    "Option 1",
    "Option 2",
    "Option 3",
  ];

  final List<String> issuanceSelection = [
    "Option 1",
    "Option 2",
    "Option 3",
  ];

  late List<TextEditingController> controllers;

  @override
  void onInit() {
    super.onInit();
    selectedCard = Get.arguments['selectedCard'];
    controllers = [
      nameController = TextEditingController(),
      lastNameController = TextEditingController(),
      surNameController = TextEditingController(),
      bothDateController = TextEditingController(),
      passportNumberController = TextEditingController(),
      dateIssueController = TextEditingController(),
    ];
    addressController = TextEditingController();
    phoneController = TextEditingController();

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
    if(addressController.text.isNotEmpty &&
        phoneController.text.length >= 8){
      continueEnabled = true;
      update();
    }else{
      continueEnabled = false;
      update();
    }
  }

  void setDropdownType(String? value) {
    selectedDropdownType = value;
    continueEnabled = true;
    update();
  }

  void onTap(){
    if(pageIndex == 1 && continueEnabled){
      pageIndex = 2;
      continueEnabled = false;
      update();
    }else if(pageIndex == 2 && continueEnabled){
      Get.toNamed(PaymentVerificationScreen.route, arguments: {
        'serviceName': 'inquiries',
        'isInquiries': true
      });
      update();
    }

  }
  void onBack(){
    if(pageIndex == 1){
      Get.back();
      update();
    }else if(pageIndex == 2 ) {
      pageIndex = 1;
      update();
    }
  }

  void setDropdownIssuance(String? value) {
    selectedDropdownIssuance = value;
    onTextIsNotEmpty(value);
    update();
  }

  void setDropdownBranch(String? value) {
    selectedDropdownBranch = value;
    onInformationNotEmpty(value);
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