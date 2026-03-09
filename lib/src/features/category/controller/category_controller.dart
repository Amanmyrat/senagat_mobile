import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/check_phone_balance/presentation/check_phone_balance.dart';
import 'package:senagat_mobile/src/features/net_and_tv/presentation/net_and_tv_screen.dart';
import 'package:senagat_mobile/src/features/notifications/presentation/notifications_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/astu_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/belet_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/tmcell_payment_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/telecom_payment_screen.dart';
import '../../../utils/constants/app_assets.dart';
import '../../foundation/presentation/foundation_screen.dart';
import '../../qr_code/presentation/qr_code_screen.dart';

enum CategoryTapType { none, qr, service, fastOperation, notification, foundation }

class CategoryController extends GetxController with StateControlMixin {
  CategoryTapType lastTap = CategoryTapType.none;
  int? lastFastServiceTapIndex;
  int? lastServiceTapIndex;


  final List<String> paymentsIcons = [
    AppAssets.tmCell,
    AppAssets.astu,
    AppAssets.astu,
    AppAssets.astu,
    AppAssets.astu,
    AppAssets.telecom,
  ];

  final List<String> serviceIcons = [
    AppAssets.beletIcon,
    AppAssets.policeCar,
    AppAssets.alemTv,
  ];

  final List<String> paymentsTitle = [
    r'TM CELL',
    r'CDMA',
    r'IP TV',
    r'home_phone',
    r'astu_internet',
    r'telecom_internet',
  ];

  final List<String> serviceTitle = [
    r'Belet',
    r'state_traffic_safety_inspectorate',
    r'ÄlemTv',
  ];



  void onQrScanTap() {
    lastTap = CategoryTapType.qr;
    update();
    Get.toNamed(QrCodeScreen.route);
  }
  void onNotificationScanTap() {
    lastTap = CategoryTapType.notification;
    update();
    Get.toNamed(NotificationsScreen.route);
  }

  void onServiceTap(int index){
    lastTap = CategoryTapType.service;
    lastServiceTapIndex = index;
    update();

    if(serviceTitle[index] == r'state_traffic_safety_inspectorate'){
      Get.toNamed(NetAndTvScreen.route, arguments: {
        'selectedServiceTitle': serviceTitle[index],
      });
    } else {
      final route = serviceTitle[index] == 'Belet'
          ? BeletPaymentScreen.route
          : AstuPaymentScreen.route;

      Get.toNamed(route, arguments: {
        'selectedServiceTitle': serviceTitle[index],
        'selectedServiceIcon': serviceIcons[index],
      });
    }
  }

  void onFoundationTap() {
    lastTap = CategoryTapType.foundation;
    update();
    Get.toNamed(FoundationScreen.route);
  }

  void onFastServiceTap(int index) {
    lastTap = CategoryTapType.fastOperation;
    lastFastServiceTapIndex = index;
    update();

    if (paymentsTitle[index] == r'state_traffic_safety_inspectorate'.tr) {
      Get.toNamed(NetAndTvScreen.route, arguments: {
        'selectedServiceTitle': paymentsTitle[index],
      });
    } else if (paymentsTitle[index] == 'TM CELL') {
      Get.toNamed(TmcellPaymentScreen.route, arguments: {
        'selectedServiceTitle': paymentsTitle[index],
        'selectedServiceIcon': paymentsIcons[index],
      });
    } else if (paymentsTitle[index] == 'telecom_internet') {
      Get.toNamed(CheckPhoneBalanceScreen.route, arguments: {
        'selectedServiceTitle': paymentsTitle[index],
        'selectedServiceIcon': paymentsIcons[index],
      });
    } else if(paymentsIcons[index] == AppAssets.astu){
      Get.toNamed(CheckPhoneBalanceScreen.route, arguments: {
        'selectedServiceTitle': paymentsTitle[index],
        'selectedServiceIcon': paymentsIcons[index],
      });
    } else {
      Get.toNamed(AstuPaymentScreen.route, arguments: {
        'selectedServiceTitle': paymentsTitle[index],
        'selectedServiceIcon': paymentsIcons[index],
      });
    }
  }

}
