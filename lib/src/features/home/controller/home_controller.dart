import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/%20Inquiries/presentation/inquiries_screen.dart';
import 'package:senagat_mobile/src/features/add_card/controller/add_card_controller.dart';
import 'package:senagat_mobile/src/features/add_card/model/card_model.dart';
import 'package:senagat_mobile/src/features/credit/presentation/get_credit_screen.dart';
import 'package:senagat_mobile/src/features/get_card/presentation/get_card_screen.dart';
import 'package:senagat_mobile/src/features/net_and_tv/presentation/net_and_tv_screen.dart';
import 'package:senagat_mobile/src/features/notifications/presentation/notifications_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_screen.dart';
import 'package:senagat_mobile/src/features/register_confirmation/models/account_model.dart';
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
  AccountModel accountModel = AccountModel();

  late ServiceSettingsController fastServiceController;
  late AddCardController addCardController;

  final cardBox = Hive.box<CardModel>('cardsBox');
  final payBox = Hive.box<PayModel>('payBox');

  String cardKey = 'card';

  bool isProfileRequired = true;

  final List<String> flags = [
    AppAssets.ruIcon,
    AppAssets.enIcon,
    AppAssets.euIcon,
  ];

  final List<String> currency = ['RUB', 'USD', 'EUR'];

  final List<String> serviceTitles = [r'inquiries', r'cards', r'credits'];

  final List<String> serviceSecondaryTitles = [
    r'get_any_type_of_help',
    r'get_a_card_in_just_a_few_seconds',
    r'get_a_credit_in_just_a_few_seconds',
  ];

  final List<String> serviceImage = [
    AppAssets.spreadsheet,
    AppAssets.threeDCard,
    AppAssets.threeDPercent,
  ];

  final List<String> serviceRoute = [
    InquiriesScreen.route,
    GetCardScreen.route,
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

    if (fastServiceController.selectedServiceTitle[index] == r'net_and_TV') {
      Get.offNamed(
        NetAndTvScreen.route,
        arguments: {
          'selectedServiceTitle':
              fastServiceController.selectedServiceTitle[index],
        },
      );
    } else {
      Get.offNamed(
        PaymentScreen.route,
        arguments: {
          'selectedServiceTitle':
              fastServiceController.selectedServiceTitle[index],
          'selectedServiceIcon':
              fastServiceController.selectedServiceIcons[index],
        },
      );
    }
  }

  @override
  void onInit() {
    checkProfile();
    fastServiceController = Get.find<ServiceSettingsController>();
    addCardController = Get.find<AddCardController>();
    super.onInit();
  }

  checkProfile(){
    if(accountModel.profile == null){
      isProfileRequired = true;
    }else{
      isProfileRequired = false;
    }
  }

  getFastOperationsCount() {
    return fastServiceController.selectedServiceTitle.length <= 4
        ? fastServiceController.selectedServiceTitle.length + 1
        : fastServiceController.selectedServiceTitle.length;
  }

  setProfileRequiredFalse(){
    isProfileRequired = false;
    update();
  }
}
