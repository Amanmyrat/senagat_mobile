import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/get_card_details/controller/get_card_details_controller.dart';
import 'package:senagat_mobile/src/features/inquiries/controller/inquiries_controller.dart';
import 'package:senagat_mobile/src/features/pay/presentation/service_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import 'package:senagat_mobile/src/features/service_settings/controller/service_settings_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import '../../add_card/model/card_model.dart';
import '../../payment_verification/presentation/payment_verification_screen.dart';
import '../model/alem_get_tariff_model.dart';

class PaymentController extends GetxController with StateControlMixin {
  bool continueEnabled = false;
  bool check = false;
  bool isOtherSelected = false;

  late final TextEditingController phoneController;
  late final TextEditingController sumController;
  late final TextEditingController nameController;
  late final TextEditingController lastnameController;
  late final TextEditingController accountController;
  late final TextEditingController  alemAccountController;
  late ServiceSettingsController serviceSettingsController;
  late final PageController pageController;

  PaymentOption? selectedPaymentOption;
  final cardBox = Hive.box<CardModel>('cardsBox');

  final PaymentRepository repository;

  PaymentController(this.repository);

  String serviceName = '';
  String serviceIcon = '';
  String number = '';
  String formattedBalance = '';
  bool isInquiries = false;
  bool isFoundation = false;
  bool isGetCard = false;

  late String alemType = '';

  late String cardNumber = '';
  late final String maskedNumber;

  final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();

  CardModel? selectedCard;
  int? selectedBeletIndex;

  late final FocusNode phoneFocus;

  late String previousValue = '';

  AlemGetTariffModel? tariff;
  bool isTariffLoading = false;
  String? lastRequestedAccount;

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
      if (kDebugMode) {debugPrint('No or invalid arguments passed to this page');}
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
    alemAccountController = TextEditingController(text: number);


    if (serviceIcon == AppAssets.alemTv) {
      final account = alemAccountController.text;

      if (alemAccountController.text.startsWith('dalem-')) {
        alemType = 'iptv';
        getAlemTariffs();
      } else if (!alemAccountController.text.startsWith('dalem') && account.length == 10) {
        alemType = 'tv';
        getAlemTariffs();
      }

      if(alemAccountController.text.isNotEmpty && selectedPaymentOption != null && selectedCard != null){
        continueEnabled = true;
      }else{
        continueEnabled = false;
      }
    }
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


  void isTextNotEmpty() async {
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
      update();
    } else {
      continueEnabled =
          phoneController.text.length >= 8 &&
              isValidSum &&
              selectedCard != null;
      update();
    }

    if (serviceIcon == AppAssets.alemTv) {
      final account = alemAccountController.text;

      if (account.startsWith('dalem-')) {
        final suffix = account.substring(6);

        if (suffix.isNotEmpty) {
          alemType = 'iptv';
          getAlemTariffs();
        }
        if(alemAccountController.text.length > 6 && selectedPaymentOption != null && selectedCard != null){
          continueEnabled = true;
        }else{
          continueEnabled = false;
        }
      } else if (!alemAccountController.text.startsWith('dalem') && account.length == 10) {
        alemType = 'tv';
        getAlemTariffs();
        if(alemAccountController.text.isNotEmpty && selectedPaymentOption != null && selectedCard != null){
          continueEnabled = true;
        }else{
          continueEnabled = false;
        }
      }


      update([
        'alem_loading',
        'alem_status',
        'tariff_picker',
      ]);
    }
    if(isGetCard) {
      Get.find<GetCardDetailsController>().onInformationNotEmpty('');
    }

    if(isInquiries) {
      Get.find<InquiriesController>().onInformationNotEmpty('');
    }

    update(['continue_button']);
    update();
  }

  Timer? _debounce;

  void onAlemChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () {
      isTextNotEmpty();
    });
  }

  Future<void> getAlemTariffs() async {
    final account = alemAccountController.text;

    if (alemType != '' &&
        account != lastRequestedAccount &&
        !isTariffLoading) {
      lastRequestedAccount = account;
      isTariffLoading = true;
      update([
        'alem_loading',
        'alem_status',
        'tariff_picker',
      ]);
      try {
        tariff = await repository.alemGetTariff(
          data: {
            "type": alemType,
            "account": account,
          },
        );

        if (tariff != null && tariff!.paymentOptions.isNotEmpty) {
          selectedPaymentOption ??= tariff!.paymentOptions.first;
        }

      } catch (e) {
        tariff = null;
      }

      isTariffLoading = false;
    }
    update([
      'alem_loading',
      'alem_status',
      'tariff_picker',
    ]);  }

  Future<void> onTap() async {
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
        return;
      }

      String? phone = contact.selectedPhoneNumber;

      // If selectedPhoneNumber is null, use the first phone number if available
      if (phone == null && contact.phoneNumbers != null) {
        phone = contact.phoneNumbers?.first ?? '';
      }

      if (phone == null) {
        return;
      }

      // Remove +993 or leading 8
      if (phone.startsWith('+993')) {
        phone = phone.substring(4);
      } else if (phone.startsWith('8')) {
        phone = phone.substring(1);
      }

      phoneController.text = phone;
      update();
    } catch (e) {
      debugPrint(e.toString());
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
    alemAccountController.dispose();

    super.dispose();
  }
}
