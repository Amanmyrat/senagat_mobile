import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/check_phone_balance/model/check_balance_model.dart';
import 'package:senagat_mobile/src/features/pay/presentation/telecom_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import '../../../utils/api_error_handler.dart';
import '../../pay/presentation/astu_payment_screen.dart';

class CheckPhoneBalanceController extends GetxController with StateControlMixin {
  bool continueEnabled = false;

  late final TextEditingController phoneController;

  String serviceName = '2';
  String serviceIcon = '';
  String type = '';

  late var checkBalanceModel = CheckBalanceModel();

  final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
  late final FocusNode phoneFocus;

  PaymentRepository repository;

  CheckPhoneBalanceController(this.repository);


  @override
  void onInit() {

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      serviceName   = args['selectedServiceTitle'] as String? ?? '';
      serviceIcon   = args['selectedServiceIcon'] as String? ?? '';
    } else {
      debugPrint('No or invalid arguments passed to this page');
    }


    if(serviceName == 'IP TV'){
      type = 'iptv';
    }else if(serviceName == 'home_phone'){
      type = 'phone';
    }else if(serviceName == 'astu_internet'){
      type = 'internet';
    }else if(serviceName == 'CDMA'){
      type = 'cdma';
    }


    phoneController = TextEditingController();
    phoneFocus = FocusNode();

    super.onInit();
  }

  Future<CheckBalanceModel> _getTelecomBalanceModel() async {
    return CheckBalanceModel(
      phone: phoneController.text,
    );
  }
  Future<CheckBalanceModel> _getAstuBalanceModel() async {
    return CheckBalanceModel(
      phone: phoneController.text,
      type: type,
    );
  }

  void onTap() async {
    status = Status.loading;
    update();

    if(serviceName == 'telecom_internet'){
        final requestModel = await _getTelecomBalanceModel();
        await repository.telecomBalance(data: requestModel.toMap()).then((value){
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

            ApiErrorHandler.handleApiError(checkBalanceModel.error?.message);
          }
        }).catchError((e){
          status = Status.error;
          update();
          ApiErrorHandler.handleApiError(e);
          debugPrint(e.toString());
        });

    }else {
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

            ApiErrorHandler.handleApiError(checkBalanceModel.error?.message);
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
    if(serviceName == 'telecom_internet'){
      phoneController.text.length >= 8 ? continueEnabled = true : continueEnabled = false;
      update();
    }else {
      phoneController.text.length >= 6
          ? continueEnabled = true
          : continueEnabled = false;
      update();
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

    super.dispose();
  }
}
