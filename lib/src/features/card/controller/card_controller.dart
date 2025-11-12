import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/add_card/controller/add_card_controller.dart';
import 'package:senagat_mobile/src/features/notifications/presentation/notifications_screen.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/services/error_utils.dart';
import '../../../utils/services/show_snack.dart';
import '../../add_card/model/card_model.dart';
import '../../auth/repository/auth_repository.dart';
import '../../home/models/user_information_model.dart';
import '../../qr_code/presentation/qr_code_screen.dart';

enum CardTapType { none, qr, foundation, service, fastOperation, notification }

class CardController extends GetxController with StateControlMixin {

  CardTapType lastTap = CardTapType.none;
  late AddCardController addCardController;
  final cardBox = Hive.box<CardModel>('cardsBox');
  UserInformationModel? userInformationModel;
  AuthRepository authRepository;

  late bool isOpen = false;

  CardController(this.authRepository);

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
    super.onInit();
    addCardController = Get.find<AddCardController>();
    getUserProfileInfo();
  }

  void onOpenApplication(){
    if(!isOpen){
      isOpen = true;
      update();
    }else{
      isOpen = false;
      update();
    }
  }

  void getUserProfileInfo() async {

    status = Status.loading;
    update();

    await authRepository
        .getUserInformation()
        .then((value) {
      userInformationModel = value;
      status = Status.completed;

      update();
    }).catchError((e) {
      status = Status.error;
      update();
      final errorText = ErrorUtils.extractErrorText(e);
      ShowSnack.showSnack(errorText ?? r'error'.tr, SnackType.error);
      debugPrint(e.toString());
    });
  }

}
