import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/notifications/presentation/notifications_screen.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../add_card/model/card_model.dart';
import '../../auth/repository/auth_repository.dart';
import '../../home/models/user_information_model.dart';
import '../../qr_code/presentation/qr_code_screen.dart';

enum CardTapType { none, qr, foundation, service, fastOperation, notification }

class CardController extends GetxController with StateControlMixin {
  CardTapType lastTap = CardTapType.none;
  final cardBox = Hive.box<CardModel>('cardsBox');
  UserInformationModel? userInformationModel;
  AuthRepository authRepository;

  List<bool> isOpenList = [];

  CardController(this.authRepository);

  @override
  void onInit() {
    super.onInit();
    getUserProfileInfo();
  }

  void onOpenApplication(int index) {
    isOpenList[index] = !isOpenList[index];
    update();
  }

  void initOpenStates(int length) {
    isOpenList = List.generate(length, (_) => false);
    update();
  }

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

  void getUserProfileInfo() async {
    status = Status.loading;
    update();

    await authRepository
        .getUserInformation()
        .then((value) {
          userInformationModel = value;
          status = Status.completed;

          initOpenStates(userInformationModel?.cards?.length ?? 0);

          update();
        })
        .catchError((e) {
          status = Status.error;
          update();
          ApiErrorHandler.handleApiError(e);
          debugPrint(e.toString());
        });
  }

  Color checkCardStatus(int index) {
    if (userInformationModel?.cards?[index].status == 'pending') {
      return AppColors.orange;
    } else if (userInformationModel?.cards?[index].status == 'rejected') {
      return AppColors.redDark;
    } else if (userInformationModel?.cards?[index].status == 'approved') {
      return AppColors.green;
    } else {
      return AppColors.grey;
    }
  }

  String hideCardCenter(String number) {
    if (number.length < 8) return number;

    final start = number.substring(0, 4);
    final end = number.substring(number.length - 4);
    final hiddenCount = number.length - 7;
    final hidden = '*' * hiddenCount;
    final masked = '$start$hidden$end';

    final buffer = StringBuffer();
    for (int i = 0; i < masked.length; i++) {
      buffer.write(masked[i]);
      if ((i + 1) % 4 == 0 && i != masked.length - 1) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }
}
