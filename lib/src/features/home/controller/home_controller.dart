import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/add_card/controller/add_card_controller.dart';
import 'package:senagat_mobile/src/features/add_card/model/card_model.dart';
import 'package:senagat_mobile/src/features/phone_pay/presentation/phone_pay_screen.dart';
import '../../../utils/constants/app_assets.dart';
import '../../service_settings/controller/service_settings_controller.dart';

class HomeController extends GetxController with StateControlMixin {

  late GlobalKey<FormState> key;


  late ServiceSettingsController serviceController;
  late AddCardController addCardController;
  final cardBox = Hive.box<CardModel>('cardsBox');

  String cardKey = 'card';

  final List<String> flags = [
    AppAssets.ruIcon,
    AppAssets.enIcon,
    AppAssets.euIcon,
  ];

  final List<String> currency = [
    'RUB',
    'USD',
    'EUR',
  ];

  void onServiceTap(int index){
    Get.toNamed(PhonePayScreen.route, arguments: {
      'selectedServiceTitle': serviceController.selectedServiceTitle[index],
      'selectedServiceIcon': serviceController.selectedServiceIcons[index]
    });
  }

  @override
  void onInit() {
    serviceController = Get.find<ServiceSettingsController>();
    addCardController = Get.find<AddCardController>();
    super.onInit();
  }


}