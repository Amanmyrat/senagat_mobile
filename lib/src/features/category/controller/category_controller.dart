import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
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
    r'Altyn Asyr',
    r'net_and_TV',
    r'gas',
    r'water',
    r'state_traffic_safety_inspectorate',
    r'light',
    r'communal_apartment',
  ];

  final List<String> serviceTitle = [
    r'Belet',
    r'air_tickets',
    r'railway_tickets',
    r'auto_tickets',
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
    Get.toNamed(PaymentScreen.route, arguments: {
      'selectedServiceTitle': serviceTitle[index],
      'selectedServiceIcon': serviceIcons[index],
    });

  }


  void onFastServiceTap(int index) {
    lastTap = CategoryTapType.fastOperation;
    lastFastServiceTapIndex = index;
    update();

    if (paymentsTitle[index] == r'net_and_TV'.tr) {
      Get.toNamed(NetAndTvScreen.route, arguments: {
        'selectedServiceTitle': paymentsTitle[index],
      });
    } else {
      Get.toNamed(PaymentScreen.route, arguments: {
        'selectedServiceTitle': paymentsTitle[index],
        'selectedServiceIcon': paymentsIcons[index],
      });
    }
  }

}
