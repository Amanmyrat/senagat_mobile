import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/get_card_details/models/card_order_model.dart';
import 'package:senagat_mobile/src/features/map_search/repository/location_repository.dart';
import 'package:senagat_mobile/src/features/payment_verification/presentation/payment_verification_screen.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/services/show_snack.dart';
import '../../get_card/repository/card_repository.dart';
import '../../map_search/model/location_model.dart';

class GetCardDetailsController extends GetxController with StateControlMixin {
  late final TextEditingController homePhoneNumberController;
  late final TextEditingController phoneController;

  String? selectedCardTitle;
  String? selectedCardImage;
  String? sum;
  int? selectedCardId;
  int? selectedDropdownBranch;
  bool continueEnabled = false;
  CardRepository repository;
  LocationRepository locRepository;

  final List<LocationModel> _branches = [];
  List<LocationModel> get branches => _branches;

  GetCardDetailsController(this.repository, this.locRepository);

  final dateOfBirthFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  late List<TextEditingController> controllers;

  @override
  void onInit() {
    super.onInit();
    selectedCardTitle = Get.arguments['selectedCardTitle'];
    selectedCardImage = Get.arguments['selectedCardImage'];
    selectedCardId = Get.arguments['selectedCardId'];
    sum = Get.arguments['sum'];
    homePhoneNumberController = TextEditingController();
    phoneController = TextEditingController();
    getBranches();
  }

  void onInformationNotEmpty() {
    if (homePhoneNumberController.text.isNotEmpty &&
        phoneController.text.length >= 8 &&
        selectedDropdownBranch != null) {
      continueEnabled = true;
      update();
    } else {
      continueEnabled = false;
      update();
    }
  }

  Future<CardOrderModel> _getCardOrderModel() async {
    return CardOrderModel(
      typeId: selectedCardId,
      phoneNumber: phoneController.text,
      homePhoneNumber: homePhoneNumberController.text,
      bankBranch: selectedDropdownBranch,
    );
  }

  Future<void> onTap() async {
    if (continueEnabled) {
      status = Status.loading;
      update();
      final cardOrderModel = await _getCardOrderModel();
      await repository
          .createCardOrder(data: cardOrderModel.toMap())
          .then((value) {
            status = Status.completed;
            update();

            Get.toNamed(PaymentVerificationScreen.route, arguments: {
              'serviceName': r'get_a_card',
              'sum': sum,
              'isInquiries': true,
              'isFoundation': false,
            });
          })
          .catchError((e) {
            status = Status.error;
            update();
            ShowSnack.showSnack(r'error'.tr, SnackType.error);

            debugPrint(e.toString());
          });
    }
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
      ShowSnack.showSnack(r'error'.tr, SnackType.error);
      debugPrint(e.toString());
    });
  }

  void setDropdownBranch(int? value) {
    selectedDropdownBranch = value;
    onInformationNotEmpty();
    update();
  }
}
