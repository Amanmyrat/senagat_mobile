import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
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
  late final TextEditingController lastnameController;
  late final TextEditingController accountController;
  late ServiceSettingsController serviceSettingsController;
  late final PageController pageController;

  final cardBox = Hive.box<CardModel>('cardsBox');


  String serviceName = '';
  String serviceIcon = '';
  bool isInquiries = false;
  bool isFoundation = false;
  late String cardNumber = '';
  late final String maskedNumber;
  final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
  CardModel? selectedCard;


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

    pageController = PageController();
    phoneController = TextEditingController();
    phoneFocus = FocusNode();
    sumController = TextEditingController();
    nameController = TextEditingController();
    lastnameController = TextEditingController();
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
    sumController.text.isNotEmpty && nameController.text.isNotEmpty && lastnameController.text.isNotEmpty && selectedCard != null ? continueEnabled = true: continueEnabled = false:
    phoneController.text.length >= 8 && sumController.text.isNotEmpty && selectedCard != null ? continueEnabled = true : continueEnabled = false;
    update();
  }

  String hideCardCenter(String number) {
    if (number.length < 8) return number;

    final start = number.substring(0, 4);
    final end = number.substring(number.length - 4);
    final hiddenCount = number.length - 11;

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

  Future<void> contactPicker() async {
    try {
      final Contact? contact = await _contactPicker.selectContact();
      if (contact == null) {
        print('No contact selected');
        return;
      }

      String? phone = contact.selectedPhoneNumber;

      // If selectedPhoneNumber is null, use the first phone number if available
      if (phone == null && contact.phoneNumbers != null) {
        phone = contact.phoneNumbers?.first ?? '';
      }

      if (phone == null) {
        print('Contact has no phone number');
        return;
      }

      // Remove +993 or leading 8
      if (phone.startsWith('+993')) {
        phone = phone.substring(4);
      } else if (phone.startsWith('8')) {
        phone = phone.substring(1);
      }

      print('Phone after formatting: $phone');
      phoneController.text = phone;
      update();
    } catch (e) {
      print('Contact picker cancelled or failed: $e');
    }
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
