import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/add_card/controller/add_card_controller.dart';
import 'package:senagat_mobile/src/features/notifications/presentation/notifications_screen.dart';
import '../../add_card/model/card_model.dart';
import '../../qr_code/presentation/qr_code_screen.dart';

enum CardTapType { none, qr, foundation, service, fastOperation, notification }

class CardController extends GetxController with StateControlMixin {
  CardTapType lastTap = CardTapType.none;
  late AddCardController addCardController;
  final cardBox = Hive.box<CardModel>('cardsBox');


  void onQrScanTap() {
    lastTap = CardTapType.qr;
    update();
    Get.toNamed(QrCodeScreen.route);
  }
  void onNotificationScanTap() {
    lastTap = CardTapType.notification;
    update();
    Get.toNamed(NotificationsScreen.route);
  }



  @override
  void onInit() {
    addCardController = Get.find<AddCardController>();
    super.onInit();
  }
}
