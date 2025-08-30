import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/%20Inquiries/presentation/inquiries_screen.dart';
import 'package:senagat_mobile/src/features/add_card/controller/add_card_controller.dart';
import 'package:senagat_mobile/src/features/add_card/model/card_model.dart';
import 'package:senagat_mobile/src/features/credit/presentation/get_credit_screen.dart';
import 'package:senagat_mobile/src/features/net_and_tv/presentation/net_and_tv_screen.dart';
import 'package:senagat_mobile/src/features/notifications/presentation/notifications_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_screen.dart';
import '../../../utils/constants/app_assets.dart';
import '../../foundation/presentation/foundation_screen.dart';
import '../../pay/model/pay_model.dart';
import '../../qr_code/presentation/qr_code_screen.dart';
import '../../service_settings/controller/service_settings_controller.dart';

enum HomeTapType { none, qr, foundation, service, fastOperation, notification }

class HomeController extends GetxController with StateControlMixin {
  HomeTapType lastTap = HomeTapType.none;
  int? lastFastServiceTapIndex;
  int? lastServiceTapIndex;

  late ServiceSettingsController fastServiceController;
  late AddCardController addCardController;

  final cardBox = Hive.box<CardModel>('cardsBox');
  final payBox = Hive.box<PayModel>('payBox');

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

  final List<String> serviceTitle = [
    r'inquiries'.tr,
    'Карты',
    'Кредит',
  ];

  final List<String> serviceImage = [
    AppAssets.spreadsheet,
    AppAssets.threeDCard,
    AppAssets.threeDPercent,
  ];

  final List<String> serviceRoute = [
    InquiriesScreen.route,
    InquiriesScreen.route,
    GetCreditScreen.route,
  ];

  void onQrScanTap() {
    lastTap = HomeTapType.qr;
    update();
    Get.toNamed(QrCodeScreen.route);
  }
  void onNotificationScanTap() {
    lastTap = HomeTapType.notification;
    update();
    Get.toNamed(NotificationsScreen.route);
  }

  void onFoundationTap() {
    lastTap = HomeTapType.foundation;
    update();
    Get.toNamed(FoundationScreen.route);
  }

  void onServiceTap(int index) {
    lastTap = HomeTapType.service;
    lastServiceTapIndex = index;
    update();
    Get.toNamed(serviceRoute[index]);
  }

  void onFastServiceTap(int index) {
    lastTap = HomeTapType.fastOperation;
    lastFastServiceTapIndex = index;
    update();

    if (fastServiceController.selectedServiceTitle[index] == r'Net и Tv'.tr) {
      Get.toNamed(NetAndTvScreen.route, arguments: {
        'selectedServiceTitle': fastServiceController.selectedServiceTitle[index],
      });
    } else {
      Get.toNamed(PaymentScreen.route, arguments: {
        'selectedServiceTitle': fastServiceController.selectedServiceTitle[index],
        'selectedServiceIcon': fastServiceController.selectedServiceIcons[index],
      });
    }
  }

  @override
  void onInit() {
    fastServiceController = Get.find<ServiceSettingsController>();
    addCardController = Get.find<AddCardController>();
    super.onInit();
  }
}
