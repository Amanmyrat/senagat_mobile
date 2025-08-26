import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_screen.dart';
import '../../../utils/constants/app_assets.dart';

class NetAndTvController extends GetxController with StateControlMixin {

  late GlobalKey<FormState> key;
  String serviceName = '';


  final List<String> serviceIcons = [
    AppAssets.globeIcon,
    AppAssets.globeIcon,
    AppAssets.tvIcon,
    AppAssets.cabelTvIcon,
  ];

  final List<String> serviceTitle = [
    r'telecom_internet'.tr,
    r'AŞTU_internet'.tr,
    r'AŞTU_IPTV'.tr,
    r'cable_TV'.tr,
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