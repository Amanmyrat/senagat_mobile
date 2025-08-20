import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/add_card/controller/add_card_controller.dart';
import 'package:senagat_mobile/src/features/add_card/model/card_model.dart';
import 'package:senagat_mobile/src/features/phone_pay/presentation/pay_screen.dart';
import '../../../utils/constants/app_assets.dart';
import '../../phone_pay/model/pay_model.dart';
import '../../service_settings/controller/service_settings_controller.dart';

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
    'Telekom internet',
    'AŞTU internet',
    'AŞTU IPTV',
    'Кабельное ТВ',
  ];

  void onServiceTap(int index){
    Get.toNamed(PayScreen.route, arguments: {
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