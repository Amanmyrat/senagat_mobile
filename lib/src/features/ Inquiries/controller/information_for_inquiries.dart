import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';


class InformationForInquiriesController extends GetxController with StateControlMixin {

  late final TextEditingController addressController;
  late final TextEditingController phoneController;


  String? selectedDropdownValue;
  bool continueEnabled = false;


  final List<String> dropdownItems = [
    "Option 1",
    "Option 2",
    "Option 3",
  ];



  @override
  void onInit() {
    addressController = TextEditingController();
    phoneController = TextEditingController();
    super.onInit();
  }

  void onTextIsNotEmpty(String? v){
    if(addressController.text.isNotEmpty &&
        phoneController.text.length >= 8){
      continueEnabled = true;
      update();
    }else{
      continueEnabled = false;
      update();
    }
  }

  void setDropdownValue(String? value) {
    selectedDropdownValue = value;
    onTextIsNotEmpty(value);
    update();
  }

}