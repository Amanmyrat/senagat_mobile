import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import '../../pay/presentation/astu_payment_screen.dart';

class CheckPhoneBalanceController extends GetxController with StateControlMixin {
  bool continueEnabled = false;

  late final TextEditingController phoneController;

  String serviceName = '2';
  String serviceIcon = '';

  final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
  late final FocusNode phoneFocus;

  @override
  void onInit() {

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      serviceName   = args['selectedServiceTitle'] as String? ?? '';
      serviceIcon   = args['selectedServiceIcon'] as String? ?? '';
    } else {
      debugPrint('No or invalid arguments passed to this page');
    }


    phoneController = TextEditingController();
    phoneFocus = FocusNode();

    super.onInit();
  }

  void onTap() async {
    status = Status.loading;
    update();
    await Future.delayed( Duration(seconds: 2), (){
    });
    status = Status.completed;

    update();
    Get.toNamed(AstuPaymentScreen.route,
        arguments:
        {'selectedServiceTitle': serviceName,
          'selectedServiceIcon': serviceIcon,
          'number': phoneController.text,
        });

  }


  void isTextNotEmpty(){

    phoneController.text.length >= 8 ? continueEnabled = true : continueEnabled = false;
    update();
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
