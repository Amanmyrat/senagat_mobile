import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:senagat_mobile/src/features/home/controller/home_controller.dart';
import '../../../core/control_state_variable_mixin.dart';
import '../../../core/local/key_value_storage_service.dart';
import '../../../core/networking/custom_exception.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../add_card/model/card_model.dart';
import '../../auth/controller/account_status_controller.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../identity_verification/models/profile_model.dart';
import '../../pay/model/pay_model.dart';
import '../../register_confirmation/models/account_model.dart';

class IdentificationController extends GetxController with StateControlMixin {
  final profileBox = Hive.box<ProfileModel>('profileBox');
  final phoneBox = Hive.box<String>('phoneBox');
  final cardsBox = Hive.box<CardModel>('cardsBox');
  final fastOperation = Hive.box('fastOperations');
  final paymentBox = Hive.box<PayModel>('payBox');

  final _keyValueStorageService = KeyValueStorageService();
  final _accountLoginStatusController = Get.put(
    AccountLoginStatusController(),
    permanent: true,
  );

  AccountModel? currentUser;
  final homeController = Get.find<HomeController>();

  String? get phone => phoneBox.get('phone');
  String? get profileStatus => profileBox.get('currentProfile')?.status;

  Future<void> logout() async {
    _keyValueStorageService.resetKeys();
    _accountLoginStatusController.getAccountStatus(
      StatefulData.error(ExceptionType.UnauthorizedException),
    );
    profileBox.clear();
    phoneBox.clear();
    cardsBox.clear();
    fastOperation.clear();
    paymentBox.clear();

    homeController.lastTap = HomeTapType.none;
    homeController.userInformationModel = null;
    homeController.currentProfile = null;
    homeController.isProfileRequired = false;
    homeController.isServiceRequired = true;
    update();

    final dashboardController = Get.find<DashboardController>();
    dashboardController.resetToHome();
    Navigator.of(Get.context!).pushNamedAndRemoveUntil(
      DashboardScreen.route,
      (Route<dynamic> route) => false,
    );
  }

  Color checkProfileStatus() {
    final currentProfile = profileBox.get('currentProfile');

    if (currentProfile?.status == 'pending') {
      return AppColors.orange;
    } else if (currentProfile?.status == 'rejected') {
      return AppColors.redDark;
    } else if (currentProfile?.status == 'approved') {
      return AppColors.green;
    } else {
      return AppColors.grey;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
