import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/service_settings/controller/service_settings_controller.dart';
import '../../add_card/model/card_model.dart';
import '../../payment_verification/presentation/payment_verification_screen.dart';

class PaymentController extends GetxController with StateControlMixin {
  bool continueEnabled = false;
  bool check = false;


  late final TextEditingController phoneController;
  late final TextEditingController sumController;
  late final TextEditingController nameController;
  late final TextEditingController accountController;
  late ServiceSettingsController serviceSettingsController;
  final cardBox = Hive.box<CardModel>('cardsBox');


  String serviceName = '';
  String serviceIcon = '';
  bool isInquiries = false;
  bool isFoundation = false;
  late String cardNumber = '';
  late final String maskedNumber;



  late final FocusNode phoneFocus;

  @override
  void onInit() {
    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      serviceName   = args['selectedServiceTitle'] as String? ?? '';
      serviceIcon   = args['selectedServiceIcon'] as String? ?? '';
      isInquiries   = args['isInquiries']   as bool? ?? false;
      isFoundation  = args['isFoundation']  as bool? ?? false;
    } else {
      debugPrint('No or invalid arguments passed to this page');
    }

    if(cardBox.isNotEmpty) {
      cardNumber = cardBox
          .getAt(0)
          ?.cardNumber ?? '';
    }
    maskedNumber = hideCardCenter(cardNumber);

    serviceSettingsController = Get.find<ServiceSettingsController>();
    phoneController = TextEditingController();
    phoneFocus = FocusNode();
    sumController = TextEditingController();
    nameController = TextEditingController();
    accountController = TextEditingController(text: '100');

    super.onInit();
  }

  void onPayTap() async {
    status = Status.loading;
      update();
      await Future.delayed( Duration(seconds: 2), (){
      });
      status = Status.completed;

      update();
      Get.toNamed(PaymentVerificationScreen.route,
          arguments:
          {'serviceName': serviceName,
            'serviceIcon': serviceIcon,
            'number': phoneController.text,
            'sum': sumController.text,
            'userName': nameController.text,
            'isInquiries': isInquiries,
            'isFoundation': isFoundation,
      });

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

  void isTextNotEmpty(){
    serviceIcon.isEmpty?
    phoneController.text.length >= 8 && sumController.text.isNotEmpty && nameController.text.isNotEmpty ? continueEnabled = true: continueEnabled = false:
    phoneController.text.length >= 8 && sumController.text.isNotEmpty ? continueEnabled = true : continueEnabled = false;
    update();
  }

  String hideCardCenter(String number) {
    if (number.length < 8) return number;

    final start = number.substring(0, 4);
    final end = number.substring(number.length - 4);
    final hiddenCount = number.length - 7;

    final hidden = '*' * hiddenCount;

    final masked = '$start$hidden$end';

    final buffer = StringBuffer();
    for (int i = 0; i < masked.length; i++) {
      buffer.write(masked[i]);
      if ((i + 1) % 4 == 0 && i != masked.length - 1) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }

  @override
  void dispose() {
    phoneController.dispose();
    phoneFocus.dispose();

    sumController.dispose();
    nameController.dispose();

    super.dispose();
  }
}
