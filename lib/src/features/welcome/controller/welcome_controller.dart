import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/register/presentation/register_screen.dart';
import '../../../core/control_state_variable_mixin.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/localization/localization_service.dart';
import '../../../utils/localization/controller/language_controller.dart';

class WelcomeController extends GetxController with StateControlMixin {
  final LanguageController _languageController = Get.find<LanguageController>();

  final List<String> langCodes = LocalizationService.langs;


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

  void navigateToCreateAccount() {
    status = Status.loading;
    try {
      Get.toNamed(RegisterScreen.route, arguments: {'login': false});
    } catch (e) {
      status = Status.error;
    } finally {
      status = Status.completed;
    }
  }

  void navigateToLogin() {
    status = Status.loading;
    try {
      Get.toNamed(RegisterScreen.route, arguments: {'login': true});
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
