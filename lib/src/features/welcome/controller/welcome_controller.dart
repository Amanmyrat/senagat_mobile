import 'package:get/get.dart';
import '../../../utils/localization/localization_service.dart';
import '../../../utils/localization/controller/language_controller.dart';

class WelcomeController extends GetxController {
  final LanguageController _languageController = Get.find<LanguageController>();

  // Language codes for dropdown
  final List<String> langCodes = ['ru', 'en', 'tm'];

  // Observable for loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Observable for error state
  final RxBool _hasError = false.obs;
  bool get hasError => _hasError.value;

  @override
  void onInit() {
    super.onInit();
    // Initialize any required setup
  }

  /// Update language selection
  void updateLanguage(String languageCode) {
    try {
      int idx = langCodes.indexOf(languageCode);
      if (idx != -1) {
        _languageController.updateLanguage(LocalizationService.langs[idx]);
      }
    } catch (e) {
      _hasError.value = true;
      print('Error updating language: $e');
    }
  }

  /// Navigate to create account screen
  void navigateToCreateAccount() {
    _isLoading.value = true;
    try {
      Get.toNamed('/login');
    } catch (e) {
      _hasError.value = true;
      print('Error navigating to create account: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Navigate to login screen
  void navigateToLogin() {
    _isLoading.value = true;
    try {
      Get.toNamed('/login');
    } catch (e) {
      _hasError.value = true;
      print('Error navigating to login: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Reset error state
  void resetError() {
    _hasError.value = false;
  }

  /// Get current language code
  String getCurrentLanguageCode() {
    return langCodes[_languageController.currentIndex.value];
  }
}
