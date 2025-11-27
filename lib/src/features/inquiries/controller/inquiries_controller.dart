import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/inquiries/models/inquiries_model.dart';
import 'package:senagat_mobile/src/features/inquiries/repository/inquiries_repository.dart';
import 'package:senagat_mobile/src/features/map_search/repository/location_repository.dart';
import 'package:senagat_mobile/src/features/payment_verification/presentation/payment_verification_screen.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/services/show_snack.dart';
import '../../../utils/services/error_utils.dart';
import '../../map_search/model/location_model.dart';
import '../models/inquiries_order_model.dart';

class InquiriesController extends GetxController with StateControlMixin {
  late final TextEditingController addressController;
  late final TextEditingController phoneController;

  InquiriesRepository repository;
  LocationRepository locRepository;
  final GlobalKey<FormState> key;
  final _inquiries = <InquiriesModel>[];

  late int inquiriesId;
  late int inquiriesPrice;

  List<InquiriesModel> get inquiries => _inquiries;

  final List<LocationModel> _branches = [];
  List<LocationModel> get branches => _branches;

  String? selectedDropdownType;
  int? selectedDropdownBranch;
  bool continueEnabled = false;
  bool isDropdownSelected = false;

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


  InquiriesController(this.repository, this.locRepository ,this.key,);

  @override
  void onInit() {
    super.onInit();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    getInquiries();
    getBranches();
  }

  void onInformationNotEmpty(v) {
    if (addressController.text.isNotEmpty &&
        phoneController.text.length >= 8 &&
        selectedDropdownBranch != null) {
      continueEnabled = true;
      update();
    } else {
      continueEnabled = false;
      update();
    }
  }

  void setDropdownType(String? value) {
    selectedDropdownType = value;
    isDropdownSelected = true;
    update();
  }

  Future<InquiriesOrderModel> _getInquiriesOrderModel() async {
    getInquiriesId();
    return InquiriesOrderModel(
      typeId: inquiriesId,
      phoneNumber: phoneController.text,
      homeAddress: addressController.text,
      bankBranch: selectedDropdownBranch,
    );
  }

  Future<void> onTap() async {
    if (continueEnabled) {

        status = Status.loading;
        update();
        final inquiriesOrderModel = await _getInquiriesOrderModel();
        await repository
            .createInquiresOrder(data: inquiriesOrderModel.toMap())
            .then((value) {
              status = Status.completed;
              update();
              getInquiriesPrice();

              Get.toNamed(
                PaymentVerificationScreen.route,
                arguments: {'isInquiries': true, 'isFoundation': false, 'serviceName': r'get_inquiries', 'sum': inquiriesPrice.toString()},
              );
            })
            .catchError((e) {
              status = Status.error;
              update();
              final errorText = ErrorUtils.extractErrorText(e);
              ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);

              debugPrint(e.toString());
            });
    }
  }
  void getInquiries() async{
    status = Status.loading;
    update();
    await repository.getInquiriesTypes().then((value){
      status = Status.completed;
      update();
      _inquiries.addAll(value);
    }).catchError((e){
      status = Status.error;
      update();
      final errorText = ErrorUtils.extractErrorText(e);
      ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);

      debugPrint(e.toString());
    });
  }


  void getBranches() async {
    status = Status.loading;
    update();

    await locRepository
        .getBranches()
        .then((value) {
      _branches.addAll(value);
      status = Status.completed;
      update();
    }).catchError((e) {
      status = Status.error;
      update();
      final errorText = ErrorUtils.extractErrorText(e);
      ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);
      debugPrint(e.toString());
    });
  }


  getInquiriesId(){
    final selectedType = selectedDropdownType;

    final selectedInquiry = _inquiries.firstWhere(
          (inquiry) => inquiry.title == selectedType,
      orElse: () => InquiriesModel(id: -1, title: ''),
    );

    inquiriesId = selectedInquiry.id!;
  }

  getInquiriesPrice(){
    final selectedType = selectedDropdownType;

    final selectedInquiry = _inquiries.firstWhere(
          (inquiry) => inquiry.title == selectedType,
      orElse: () => InquiriesModel(id: -1, title: ''),
    );

    inquiriesPrice = selectedInquiry.price!;
  }

    void setDropdownBranch(int? value) {
    selectedDropdownBranch = value;
    onInformationNotEmpty(value);
    update();
  }
}
