import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';


class SelectTipInquiriesController extends GetxController with StateControlMixin {

  String? selectedDropdownValue;
  bool continueEnabled = false;

  final List<String> dropdownItems = [
    "Option 1",
    "Option 2",
    "Option 3",
  ];


  void setDropdownValue(String? value) {
    selectedDropdownValue = value;
    continueEnabled = true;
    update(); // refresh GetBuilder
  }

}