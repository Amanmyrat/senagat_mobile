import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/inquiries/models/inquiries_model.dart';
import 'package:senagat_mobile/src/features/inquiries/models/inquiries_model.dart';
import 'package:senagat_mobile/src/features/inquiries/repository/inquiries_repository.dart';
import 'package:senagat_mobile/src/features/payment_verification/presentation/payment_verification_screen.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/services/show_snack.dart';
import '../models/inquiries_order_model.dart';

class InquiriesController extends GetxController with StateControlMixin {
  late final TextEditingController addressController;
  late final TextEditingController phoneController;

  InquiriesRepository repository;
  final GlobalKey<FormState> key;

  int? selectedDropdownType;
  String? selectedDropdownBranch;
  bool continueEnabled = false;
  int pageIndex = 1;

  final dateOfBirthFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  List<String> textFieldTitle = [
    r'name',
    r'last_name',
    r'surname',
    r'date_birth',
    r'passport_number',
    r'date_issue',
  ];

  final Map<int, String> typeSelection = {
    1: r'obtain_certificate',
    2: r'letter_stating_that_there_is_no_debt',
    3: r'about_the_wage_situation',
    4: r'certificate_of_loan_balance',
  };

  final List<String> branchSelection = [
    "Option 1",
    "Option 2",
    "Option 3",
  ];

  InquiriesController(this.repository, this.key);

  @override
  void onInit() {
    super.onInit();
    addressController = TextEditingController();
    phoneController = TextEditingController();
  }

  void onInformationNotEmpty(v) {
    if (addressController.text.isNotEmpty &&
        phoneController.text.length >= 8 &&
        selectedDropdownBranch!.isNotEmpty) {
      continueEnabled = true;
      update();
    } else {
      continueEnabled = false;
      update();
    }
  }

  void setDropdownType(int? value) {
    selectedDropdownType = value;
    continueEnabled = true;
    update();
  }

  Future<InquiriesOrderModel> _getInquiriesOrderModel() async {
    return InquiriesOrderModel(
      typeId: selectedDropdownType,
      phoneNumber: phoneController.text,
      homeAddress: addressController.text,
      bankBranch: selectedDropdownBranch,
    );
  }

  Future<void> onTap() async {
    if (pageIndex == 1 && continueEnabled) {
      pageIndex = 2;
      continueEnabled = false;
      update();
    } else if (pageIndex == 2 && continueEnabled) {

        status = Status.loading;
        update();

        final requestModel = await _getInquiriesOrderModel();
        await repository
            .createInquiresOrder(data: requestModel.toMap())
            .then((value) {
              status = Status.completed;
              update();
              Get.toNamed(
                PaymentVerificationScreen.route,
                arguments: {'isInquiries': true, 'isFoundation': false},
              );
            })
            .catchError((e) {
              status = Status.error;
              update();
              ShowSnack.showSnack(r'error'.tr, SnackType.error);

              debugPrint(e.toString());
            });
    }
  }

  void onBack() {
    if (pageIndex == 1) {
      Get.back();
      update();
    } else if (pageIndex == 2) {
      pageIndex = 1;
      continueEnabled = true;
      update();
    }
  }

  void setDropdownBranch(String? value) {
    selectedDropdownBranch = value;
    onInformationNotEmpty(value);
    update();
  }
}
