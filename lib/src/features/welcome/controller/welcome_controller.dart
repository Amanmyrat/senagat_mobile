import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:senagat_mobile/src/features/category/controller/category_controller.dart';
import 'package:senagat_mobile/src/features/register/presentation/register_screen.dart';
import '../../../core/control_state_variable_mixin.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/localization/localization_service.dart';
import '../../../utils/localization/controller/language_controller.dart';
import '../../add_card/model/card_model.dart';
import '../../card/controller/card_controller.dart';
import '../../category/model/fast_service_model.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/utils/nested_nav_ids.dart';
import '../../home/controller/home_controller.dart';
import '../../identity_verification/models/profile_model.dart';
import '../../pay/model/pay_model.dart';
import '../../profile/controller/profile_controller.dart';
import '../../service_settings/controller/service_settings_controller.dart';

class WelcomeController extends GetxController with StateControlMixin {
  final LanguageController _languageController = Get.find<LanguageController>();

  final List<String> langCodes = LocalizationService.langs;
  final profileBox = Hive.box<ProfileModel>('profileBox');
  final phoneBox = Hive.box<String>('phoneBox');
  final cardsBox = Hive.box<CardModel>('cardsBox');
  final fastOperation = Hive.box('fastOperations');
  final fastService = Hive.box<FastServiceItem>('fastServices');
  final paymentBox = Hive.box<PayModel>('payBox');

  final homeController = Get.find<HomeController>();

  void updateLanguage(String languageCode) {
    try {
      int idx = langCodes.indexOf(languageCode);
      if (idx != -1) {
        _languageController.updateLanguage(LocalizationService.langs[idx]);
      }
    } catch (e) {
      status = Status.error;
    }
  }

  void deleteHive(){
    final dashboardController = Get.find<DashboardController>();
    dashboardController.resetToHome();
    profileBox.clear();
    phoneBox.clear();
    cardsBox.clear();
    fastOperation.clear();
    fastService.clear();
    paymentBox.clear();

    try {
      final serviceSettingsController = Get.find<ServiceSettingsController>();
      serviceSettingsController.reloadFromHive(); // Reload from Hive (which is now empty)
    } catch (e) {
      // ServiceSettingsController might not be initialized yet, ignore
    }

    homeController.lastTap = HomeTapType.none;
    homeController.userInformationModel = null;
    homeController.currentProfile = null;
    homeController.isProfileRequired = false;
    homeController.isServiceRequired = true;
    homeController.update();

    try {
      final cardController = Get.find<CardController>();
      cardController.userInformationModel = null;
      cardController.update();
    } catch (e) {
    }

    try {
      final categoryController = Get.find<CategoryController>();
      categoryController.selected.clear();
      categoryController.update();
    } catch (e) {
    }

    try {
      final profileController = Get.find<ProfileController>();
      profileController.phone = null;
      profileController.update();
    } catch (e) {
    }
  }

  void navigateToCreateAccount() {
    status = Status.loading;
    deleteHive();
    try {
      Get.toNamed(RegisterScreen.route, arguments: {'login': 'register'});
    } catch (e) {
      status = Status.error;
    } finally {
      status = Status.completed;
    }
  }

  void navigateToLogin() {
    status = Status.loading;
    deleteHive();
    try {
      Get.toNamed(RegisterScreen.route, arguments: {'login': 'login'});
    } catch (e) {
      status = Status.error;
    } finally {
      status = Status.completed;
    }
  }

  String getCurrentLanguageCode() {
    return langCodes[_languageController.currentIndex.value];
  }

}
