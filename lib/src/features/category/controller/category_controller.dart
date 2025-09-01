import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/%20Inquiries/presentation/inquiries_screen.dart';
import 'package:senagat_mobile/src/features/credit/presentation/get_credit_screen.dart';
import 'package:senagat_mobile/src/features/net_and_tv/presentation/net_and_tv_screen.dart';
import 'package:senagat_mobile/src/features/notifications/presentation/notifications_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_screen.dart';
import '../../../utils/constants/app_assets.dart';
import '../../qr_code/presentation/qr_code_screen.dart';

enum CategoryTapType { none, qr, service, fastOperation, notification }

class CategoryController extends GetxController with StateControlMixin {
  CategoryTapType lastTap = CategoryTapType.none;
  int? lastFastServiceTapIndex;
  int? lastServiceTapIndex;


  final List<String> paymentsIcons = [
    AppAssets.deviceMobileIcon,
    AppAssets.globeIcon,
    AppAssets.flameIcon,
    AppAssets.dropIcon,
    AppAssets.stickIcon,
    AppAssets.lightbulbIcon,
    AppAssets.buildingApartmentIcon,
  ];

  final List<String> serviceIcons = [
    AppAssets.beletIcon,
    AppAssets.airTicket,
    AppAssets.railwayTickets,
    AppAssets.awtoTicket,

  ];

  final List<String> paymentsTitle = [
    r'Altyn Asyr'.tr,
    r'Net и Tv'.tr,
    r'gas'.tr,
    r'water'.tr,
    r'state_traffic_safety_inspectorate'.tr,
    r'light'.tr,
    r'communal_apartment'.tr,
  ];

  final List<String> serviceTitle = [
    r'Belet'.tr,
    r'Авиа билеты'.tr,
    r'ЖД билеты'.tr,
    r'Авто билеты'.tr,
  ];

  final List<String> serviceRoute = [
    InquiriesScreen.route,
    InquiriesScreen.route,
    GetCreditScreen.route,
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


  void onServiceTap(int index) {
    lastTap = CategoryTapType.service;
    lastServiceTapIndex = index;
    update();
    Get.toNamed(serviceRoute[index]);
  }

  void onFastServiceTap(int index) {
    lastTap = CategoryTapType.fastOperation;
    lastFastServiceTapIndex = index;
    update();

    if (serviceTitle[index] == r'Net и Tv'.tr) {
      Get.toNamed(NetAndTvScreen.route, arguments: {
        'selectedServiceTitle': serviceTitle[index],
      });
    } else {
      Get.toNamed(PaymentScreen.route, arguments: {
        'selectedServiceTitle': serviceTitle[index],
        'selectedServiceIcon': serviceIcons[index],
      });
    }
  }

}
