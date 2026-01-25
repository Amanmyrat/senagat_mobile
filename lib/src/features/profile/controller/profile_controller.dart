import 'dart:ui';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/features/auth/controller/account_status_controller.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../add_card/model/card_model.dart';
import '../../home/controller/home_controller.dart';
import '../../identity_verification/models/profile_model.dart';
import '../../pay/model/pay_model.dart';
import '../../service_settings/controller/service_settings_controller.dart';
import '../../welcome/presentation/welcome_screen.dart';

class ProfileController extends GetxController with StateControlMixin, GetSingleTickerProviderStateMixin {

  final profileBox = Hive.box<ProfileModel>('profileBox');
  final phoneBox = Hive.box<String>('phoneBox');
  String appVersion = '';
  String? phone;
  final homeController = Get.find<HomeController>();
  final cardsBox = Hive.box<CardModel>('cardsBox');
  final fastOperation = Hive.box('fastOperations');
  final paymentBox = Hive.box<PayModel>('payBox');
  late AccountLoginStatusController accountLoginStatusController;

  @override
  void onInit() {
    super.onInit();


    accountLoginStatusController = Get.find<AccountLoginStatusController>();
    
    // Listen for login status changes to refresh profile UI
    // This will fire on both login and logout
    ever(accountLoginStatusController.accountLoginStatus, (
      AccountLoginStatus status,
    ) {
      // Refresh UI when login status changes
      // Profile screen reads from Hive, so this ensures UI updates
      update();
    });
    
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion = info.version;
    update();
  }

  void onSignInTap(){

    cardsBox.clear();
    fastOperation.clear(); // Clear all fast operations on login
    paymentBox.clear();

    homeController.lastTap = HomeTapType.none;
    homeController.userInformationModel = null;
    homeController.currentProfile = null;
    homeController.isProfileRequired = false;
    homeController.isServiceRequired = true;
    
    // Reset ServiceSettingsController to reload from empty Hive
    try {
      final serviceSettingsController = Get.find<ServiceSettingsController>();
      serviceSettingsController.reloadFromHive(); // Reload from Hive (which is now empty)
    } catch (e) {
      // ServiceSettingsController might not be initialized yet, ignore
    }
    
    update();
    Get.toNamed(WelcomeScreen.route);
  }

  Color checkProfileStatus()  {
    final savedProfile = profileBox.get('currentProfile');

    if(savedProfile?.status == 'pending'){
      return AppColors.orange;
    }else if(savedProfile?.status == 'rejected'){
      return AppColors.redDark;
    }else if(savedProfile?.status == 'approved'){
      return AppColors.green;
    }else{
      return AppColors.grey;
    }
  }
}
