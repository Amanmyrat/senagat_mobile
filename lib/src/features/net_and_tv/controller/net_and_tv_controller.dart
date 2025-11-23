import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_screen.dart';
import '../../../utils/constants/app_assets.dart';

class NetAndTvController extends GetxController with StateControlMixin {

  late GlobalKey<FormState> key;
  String serviceName = '';


  final List<String> serviceIcons = [
    AppAssets.policeCar,
    AppAssets.policeCar,
  ];

  final List<String> serviceTitle = [
    r'pygg_decision',
    r'pygg_video',
  ];

  void onServiceTap(int index){
    Get.toNamed(PaymentScreen.route, arguments: {
      'selectedServiceTitle': serviceTitle[index],
      'selectedServiceIcon': serviceIcons[index]
    });
  }

  @override
  void onInit() {
    serviceName = Get.arguments['selectedServiceTitle'];

    super.onInit();
  }


}