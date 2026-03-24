import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/check_phone_balance/model/check_balance_model.dart';
import 'package:senagat_mobile/src/features/pay/presentation/belet_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/telecom_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/tmcell_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import '../../../utils/api_error_handler.dart';
import '../../pay/presentation/astu_payment_screen.dart';

class CheckPhoneBalanceController extends GetxController with StateControlMixin {
  bool continueEnabled = false;

  late final TextEditingController phoneController;

  String serviceName = '';
  String serviceIcon = '';
  String type = '';

  late var checkBalanceModel = CheckBalanceModel();

  final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
  late final FocusNode phoneFocus;

  PaymentRepository repository;

  CheckPhoneBalanceController(this.repository);

  late MaskTextInputFormatter currentMask = telecomMaskOther;


  final beletMask = MaskTextInputFormatter(
    mask: '########',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final cdmaMask = MaskTextInputFormatter(
    mask: '60 ######',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final telecomMaskOther = MaskTextInputFormatter(
    mask: '### ######',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final defaultMask = MaskTextInputFormatter(
    mask: '12 ######',
    filter: { "#": RegExp(r'[0-9]') },
    initialText: "12 ",

  );

  @override
  void onInit() {

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      serviceName   = args['selectedServiceTitle'] as String? ?? '';
      serviceIcon   = args['selectedServiceIcon'] as String? ?? '';
    } else {
      debugPrint('No or invalid arguments passed to this page');
    }

    print(serviceName);

    if(serviceName == 'IP TV'){
      type = 'iptv';
    }else if(serviceName == 'astu_phone'){
      type = 'phone';
    }else if(serviceName == 'astu_internet'){
      type = 'internet';
    }else if(serviceName == 'CDMA'){
      type = 'cdma';
    }else if(serviceName == 'Belet'){
      type = 'belet';
    }


    phoneController = TextEditingController();
    phoneFocus = FocusNode();
    super.onInit();
  }

  String _cleanSpaces(String phoneNumber) {
    return phoneNumber.replaceAll(' ', '');
  }
  String _clean12(String phoneNumber) {
    return phoneNumber.replaceAll('12 ', '').replaceAll(' ', '');
  }
  Future<CheckBalanceModel> _getTelecomBalanceModel() async {
    return CheckBalanceModel(
      phone: _cleanSpaces(phoneController.text),
    );
  }

  Future<CheckBalanceModel> _getAstuBalanceModel() async {
    return CheckBalanceModel(
      phone: _clean12(phoneController.text),
      type: type,
    );
  }

  Future<CheckBalanceModel> _getBeletBalanceModel() async {
    return CheckBalanceModel(
      phone: _clean12('993${phoneController.text}'),
    );
  }

  void onTap() async {
    status = Status.loading;
    update();

    if (serviceName == 'telecom_internet') {
      final requestModel = await _getTelecomBalanceModel();
      await repository.telecomBalance(data: requestModel.toMap()).then((value) {
        checkBalanceModel = value;
        if (checkBalanceModel.success == true) {
          status = Status.completed;
          update();

          Get.toNamed(TelecomPaymentScreen.route, arguments: {
            'balance': checkBalanceModel.balance,
            'selectedServiceTitle': serviceName,
            'number': phoneController.text,
          });
        } else {
          status = Status.error;
          update();

          ApiErrorHandler.handleApiError(checkBalanceModel.message);
        }
      }).catchError((e) {
        status = Status.error;
        update();
        ApiErrorHandler.handleApiError(e);
        debugPrint(e.toString());
      });
    }
    else if (serviceName == 'Belet') {
      final requestModel = await _getBeletBalanceModel();
      await repository.beletBalance(data: requestModel.toMap()).then((value) {
        checkBalanceModel = value;
        if (checkBalanceModel.success == true) {
          status = Status.completed;
          update();

          Get.toNamed(BeletPaymentScreen.route, arguments: {
            'balance': checkBalanceModel.balance,
            'selectedServiceTitle': serviceName,
            'number': phoneController.text,
          });
        } else {
          status = Status.error;
          update();

          ApiErrorHandler.handleApiError(checkBalanceModel.message);
        }
      }).catchError((e) {
        status = Status.error;
        update();
        ApiErrorHandler.handleApiError(e);
        debugPrint(e.toString());
      });
    }else if (serviceName == 'TM CELL') {
      final requestModel = await _getTelecomBalanceModel();
      await repository.tmcellBalance(data: requestModel.toMap()).then((value) {
        checkBalanceModel = value;
        if (checkBalanceModel.success == true) {
          status = Status.completed;
          update();

          Get.toNamed(TmcellPaymentScreen.route, arguments: {
            'balance': checkBalanceModel.balance,
            'selectedServiceTitle': serviceName,
            'number': phoneController.text,
          });
        } else {
          status = Status.error;
          update();

          ApiErrorHandler.handleApiError(checkBalanceModel.message);
        }
      }).catchError((e) {
        status = Status.error;
        update();
        ApiErrorHandler.handleApiError(e);
        debugPrint(e.toString());
      });
    }else if (serviceName == 'CDMA') {
      final requestModel = await _getTelecomBalanceModel();
      await repository.cdmaBalance(data: requestModel.toMap()).then((value) {
        checkBalanceModel = value;
        if (checkBalanceModel.success == true) {
          status = Status.completed;
          update();

          Get.toNamed(AstuPaymentScreen.route, arguments: {
            'balance': checkBalanceModel.balance,
            'selectedServiceTitle': serviceName,
            'number': phoneController.text,
          });
        } else {
          status = Status.error;
          update();

          ApiErrorHandler.handleApiError(checkBalanceModel.message);
        }
      }).catchError((e) {
        status = Status.error;
        update();
        ApiErrorHandler.handleApiError(e);
        debugPrint(e.toString());
      });
    }
    else {
      final requestModel = await _getAstuBalanceModel();

      await repository.astuBalance(data: requestModel.toMap()).then((value) {
        checkBalanceModel = value;

        if (checkBalanceModel.success == true) {
          status = Status.completed;
          update();

          Get.toNamed(AstuPaymentScreen.route, arguments: {
            'selectedServiceTitle': serviceName,
            'selectedServiceIcon': serviceIcon,
            'number': phoneController.text,
            'balance': checkBalanceModel.balance,
          });
        } else {
          status = Status.error;
          update();

          ApiErrorHandler.handleApiError(checkBalanceModel.message);
        }
      }).catchError((e) {
        status = Status.error;
        update();

        ApiErrorHandler.handleApiError(e);
        debugPrint(e.toString());
      });
    }
  }


  void isTextNotEmpty(){
    if(serviceName == 'Belet' || serviceName == 'TM CELL'){
      phoneController.text.length >= 8 ? continueEnabled = true : continueEnabled = false;
      update();
    }else {
      phoneController.text.length >= 9
          ? continueEnabled = true
          : continueEnabled = false;
      update();
    }
  }

  String hintText(){
    if( serviceName == 'telecom_internet'){
      return '12 xxxxxx / xxx xxxxxx';
    }else if(serviceName == 'Belet' || serviceName == 'TM CELL'){
     return 'xxxxxxxx';
     }else if( serviceName == 'CDMA'){
      return '60 xxxxxx';
    }else{
      return '12 xxxxxx';
    }

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

      if(phone.length >= 6){
       phone = '12 $phone';
      }

      print('Phone after formatting: $phone');
      phoneController.text = phone;
      isTextNotEmpty();
      update();
    } catch (e) {
      print('Contact picker cancelled or failed: $e');
    }
  }


  @override
  void dispose() {
    phoneController.dispose();
    phoneFocus.dispose();

    super.dispose();
  }
}
