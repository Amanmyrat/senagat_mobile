import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/service_settings/controller/service_settings_controller.dart';
import '../../payment_verification/presentation/payment_verification_screen.dart';

class PaymentController extends GetxController with StateControlMixin {
  final GlobalKey<FormState> key;
  bool continueEnabled = false;
  bool check = false;

  PaymentController(this.key);

  late final TextEditingController phoneController;
  late final TextEditingController sumController;
  late final TextEditingController nameController;
  late ServiceSettingsController serviceSettingsController;

  String serviceName = '';
  String serviceIcon = '';
  bool isInquiries = true;


  late final FocusNode phoneFocus;

  @override
  void onInit() {
    try{
      serviceName = Get.arguments['selectedServiceTitle'];
      serviceIcon = Get.arguments['selectedServiceIcon'];
      isInquiries = Get.arguments['isInquiries'];
    }catch(e){
      print(e);
    }


    serviceSettingsController = Get.find<ServiceSettingsController>();

    phoneController = TextEditingController();
    phoneFocus = FocusNode();
    sumController = TextEditingController();
    nameController = TextEditingController();

    super.onInit();
  }

  void onPayTap() async {
    status = Status.loading;
      update();
      await Future.delayed( Duration(seconds: 2), (){
      });
      status = Status.completed;

      update();
      Get.offNamed(PaymentVerificationScreen.route,
          arguments:
          {'serviceName': serviceName,
            'serviceIcon': serviceIcon,
            'number': phoneController.text,
            'sum': sumController.text,
            'userName': nameController.text,
            'isInquiries': isInquiries,
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

  // Future<void> saveCard() async {
  //   final box = Hive.box<PayModel>('payBox');
  //   final pay = PayModel(
  //     serviceName: serviceName,
  //     serviceIcon: serviceIcon,
  //     number: phoneController.text,
  //     sum: sumController.text,
  //     userName: nameController.text,
  //   );
  //   await box.put('pay', pay);
  // }

  void isTextNotEmpty(){
    serviceIcon.isEmpty?
    phoneController.text.length >= 8 && sumController.text.isNotEmpty && nameController.text.isNotEmpty ? continueEnabled = true: continueEnabled = false:
    phoneController.text.length >= 8 && sumController.text.isNotEmpty ? continueEnabled = true : continueEnabled = false;
    update();
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
