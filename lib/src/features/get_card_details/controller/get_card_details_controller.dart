import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/get_card_details/models/card_order_model.dart';
import 'package:senagat_mobile/src/features/map_search/repository/location_repository.dart';
import 'package:senagat_mobile/src/features/payment_verification/presentation/payment_verification_screen.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';
import '../../get_card/repository/card_repository.dart';
import '../../map_search/model/location_model.dart';

class GetCardDetailsController extends GetxController with StateControlMixin {
  late final TextEditingController workPhoneController;
  late final TextEditingController emailController;
  late final TextEditingController workPositionController;
  late bool internetService = false;
  late bool delivery = false;

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
    workPhoneController = TextEditingController();
    emailController = TextEditingController();
    workPositionController = TextEditingController();
    getBranches();
  }

  void onInformationNotEmpty(String v) {
    if (workPhoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        workPositionController.text.isNotEmpty &&
        workPhoneController.text.length >= 8 &&
        selectedDropdownBranch != null) {
      continueEnabled = true;
      update();
    } else {
      continueEnabled = false;
      update();
    }
  }

  void onCheckBoxTap(String type) {
    if (type == 'internet') {
      internetService = !internetService;
    } else if (type == 'delivery') {
      delivery = !delivery;
    }
    update();
  }

  Future<CardOrderModel> _getCardOrderModel() async {
    return CardOrderModel(
      typeId: selectedCardId,
      workPhone: int.parse(workPhoneController.text),
      workPosition: workPositionController.text,
      bankBranch: selectedDropdownBranch,
      internetService: internetService,
      delivery: delivery,
      email: emailController.text,
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

            Get.toNamed(
              PaymentVerificationScreen.route,
              arguments: {
                'serviceName': r'get_a_card',
                'sum': sum,
                'isInquiries': true,
                'isFoundation': false,
              },
            );
          })
          .catchError((e) {
            status = Status.error;
            update();
            ApiErrorHandler.handleApiError(e);
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
        })
        .catchError((e) {
          status = Status.error;
          update();
          ApiErrorHandler.handleApiError(e);
          debugPrint(e.toString());
        });
  }

  void setDropdownBranch(int? value) {
    selectedDropdownBranch = value;
    onInformationNotEmpty('');
    update();
  }
}
