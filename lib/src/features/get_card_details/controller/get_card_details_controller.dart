import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/get_card_details/models/card_order_model.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/payment_verification/presentation/payment_verification_screen.dart';
import 'package:senagat_mobile/src/widgets/text_input_masks.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';
import '../../get_card/repository/card_repository.dart';
import '../../loan/models/location_model.dart';
import '../../loan/repository/location_repository.dart';

class GetCardDetailsController extends PaymentController {
  GetCardDetailsController(super.repository,this.cardRepository, this.locRepository);

  late final TextEditingController workPhoneController;
  late final TextEditingController emailController;
  late final TextEditingController workPositionController;
  late bool internetService = false;
  late bool delivery = false;
  String? emailError;

  String? selectedCardTitle;
  String? selectedCardImage;
  double cardPrice = 0;
  double deliveryPrice = 0;
  int? selectedCardId;
  int? selectedDropdownBranch;
  bool _continueEnabled = false;

  @override
  bool get continueEnabled => _continueEnabled;

  @override
  set continueEnabled(bool value) {
    _continueEnabled = value;
  }
  CardRepository cardRepository;
  LocationRepository locRepository;

  late bool requiredPayment = false;

  final List<LocationModel> _branches = [];
  List<LocationModel> get branches => _branches;


  final dateOfBirthFormatter = CustomMaskFormatter(
    mask: '##-##-####', prefix: '',
  );

  late List<TextEditingController> controllers;

  @override
  void onInit() {
    super.onInit();
    isGetCard = true;
    selectedCardTitle = Get.arguments['selectedCardTitle'];
    selectedCardImage = Get.arguments['selectedCardImage'];
    selectedCardId = Get.arguments['selectedCardId'];
    cardPrice = _parseAmount(Get.arguments['sum']);
    deliveryPrice = _parseAmount(Get.arguments['deliveryPrice']);
    workPhoneController = TextEditingController();
    emailController = TextEditingController();
    workPositionController = TextEditingController();
    getBranches();
  }

  void onInformationNotEmpty(String v) {
    final emailText = emailController.text.trim();

    if (emailText.isNotEmpty && !isValidEmail(emailText)) {
      emailError = "email_invalid".tr;
    } else {
      emailError = null;
    }

    if(requiredPayment){
      if(emailText.isNotEmpty && emailError == null && selectedDropdownBranch != null && selectedCard != null){
        continueEnabled = true;
      }else{
        continueEnabled = false;
      }

    }else{
      continueEnabled = emailText.isNotEmpty && emailError == null && selectedDropdownBranch != null;

    }


    update();
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
      workPhone: workPhoneController.text.isEmpty
          ? null
          : int.tryParse(workPhoneController.text),

      workPosition: workPositionController.text.isEmpty
          ? null
          : workPositionController.text,

      bankBranch: selectedDropdownBranch,
      internetService: internetService,
      delivery: delivery,
      email: emailController.text,
      requiredPayment: requiredPayment,
    );
  }


  Future<void> onButtonTap() async {
    if (continueEnabled) {
      status = Status.loading;
      update();
      final cardOrderModel = await _getCardOrderModel();
      await cardRepository
          .createCardOrder(data: cardOrderModel.toMap())
          .then((value) {
            status = Status.completed;
            update();

            Get.toNamed(
              PaymentVerificationScreen.route,
              arguments: {
                'serviceName': r'get_a_card',
                'sum': formatAmount(displaySum),
                'cardPrice': formatAmount(cardPrice),
                'deliveryPrice': formatAmount(deliveryPrice),
                'delivery': delivery,
                'createdAt': value.createdAt,
                'paymentUrl': value.paymentUrl,
                'isInquiries': true,
                'isFoundation': false,
                'requiredPayment':  requiredPayment,
                'selectedCard':  selectedCard,
              },
            );
          })
          .catchError((e) {
            status = Status.error;
            update();
            ApiErrorHandler.handleApiError(e);
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

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void setDropdownBranch(int? value) {
    selectedDropdownBranch = value;
    onInformationNotEmpty('');
    update();
  }

  double get displaySum => delivery ? cardPrice + deliveryPrice : cardPrice;

  double _parseAmount(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String formatAmount(double value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toString();
  }
}
