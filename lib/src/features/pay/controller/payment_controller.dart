import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/pay/presentation/service_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import 'package:senagat_mobile/src/features/service_settings/controller/service_settings_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import '../../add_card/model/card_model.dart';
import '../../payment_verification/presentation/payment_verification_screen.dart';

class PaymentController extends GetxController with StateControlMixin {
  bool continueEnabled = false;
  bool check = false;
  bool isOtherSelected = false;

  late final TextEditingController phoneController;
  late final TextEditingController sumController;
  late final TextEditingController nameController;
  late final TextEditingController lastnameController;
  late final TextEditingController accountController;
  late ServiceSettingsController serviceSettingsController;
  late final PageController pageController;

  final cardBox = Hive.box<CardModel>('cardsBox');

  final PaymentRepository repository;

  PaymentController(this.repository);

  String serviceName = '';
  String serviceIcon = '';
  String number = '';
  String formattedBalance = '';
  bool isInquiries = false;
  bool isFoundation = false;
  late String cardNumber = '';
  late final String maskedNumber;
  final FlutterNativeContactPicker _contactPicker =
      FlutterNativeContactPicker();
  CardModel? selectedCard;
  int? selectedBeletIndex;

  late final FocusNode phoneFocus;

  @override
  void onInit() {
    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      serviceName = args['selectedServiceTitle'] as String? ?? '';
      serviceIcon = args['selectedServiceIcon'] as String? ?? '';
      number = args['number'] as String? ?? '';
      isInquiries = args['isInquiries'] as bool? ?? false;
      isFoundation = args['isFoundation'] as bool? ?? false;

      formattedBalance = args['balance'].toString();

    } else {
      debugPrint('No or invalid arguments passed to this page');
    }

    if (cardBox.isNotEmpty) {
      cardNumber = cardBox.getAt(0)?.cardNumber ?? '';
    }
    maskedNumber = hideCardCenter(cardNumber);

    serviceSettingsController = Get.find<ServiceSettingsController>();

    pageController = PageController();
    phoneController = TextEditingController(text: number);
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
    await Future.delayed(Duration(seconds: 2), () {});
    status = Status.completed;

    update();
    Get.toNamed(
      PaymentVerificationScreen.route,
      arguments: {
        'serviceName': serviceName,
        'serviceIcon': serviceIcon,
        'number': phoneController.text,
        'sum': sumController.text,
        'userName': nameController.text,
        'isInquiries': isInquiries,
        'isFoundation': isFoundation,
      },
    );
  }

  void startBankVerification() {
    check = true;
    status = Status.loading;
    update();
    Future.delayed(Duration(seconds: 3), () {
      status = Status.completed;
      update();
    });
  }

  void isTextNotEmpty() {
    final sumText = sumController.text;

    final int? sum = int.tryParse(sumText);


    final bool isValidSum =
        sum != null &&
            sum > 0 &&
            !(sumText.length > 1 && sumText.startsWith('0'));

    if (serviceIcon == AppAssets.astu) {
      continueEnabled =
          phoneController.text.length >= 6 &&
              isValidSum &&
              selectedCard != null;
    } else {
      continueEnabled =
          phoneController.text.length >= 8 &&
              isValidSum &&
              selectedCard != null;
    }

    update();
  }

  Future<void> onTap() async {
    // Default behavior: simple verification flow; override in specific controllers
     onPayTap();
  }

  @protected
  Future<void> openBankPayment(String url, String orderId) async {
    status = Status.completed;
    update();

    Navigator.of(Get.context!).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) => ServicePaymentScreen(
          orderId: orderId,
          paymentUrl: url,
          selectedCard: selectedCard!,
          phoneNumber: phoneController.text,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
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
    lastnameController.dispose();
    accountController.dispose();
    pageController.dispose();

    super.dispose();
  }
}
