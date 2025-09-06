import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:senagat_mobile/src/utils/localization/localization_service.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/localization/controller/language_controller.dart';


class LangSettingsController extends GetxController with StateControlMixin {

  final LanguageController languageController = Get.find<LanguageController>();

  final langCodes = LocalizationService.langs;

  late String currentLang = LocalizationService().getLocale().languageCode.toUpperCase();

  void updateLanguage(String languageCode) {
    try {
      if (langCodes.contains(languageCode)) {
        languageController.updateLanguage(languageCode);
        currentLang = languageCode;
        update();
      }
    } catch (e) {
      status = Status.error;
    }
  }
}

