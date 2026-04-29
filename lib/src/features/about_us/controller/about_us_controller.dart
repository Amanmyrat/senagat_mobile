import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:senagat_mobile/src/core/control_state_variable_mixin.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_review/in_app_review.dart';


class AboutUsController extends GetxController with StateControlMixin {

  int selected = 0;
  String appVersion = '0';

  final InAppReview _inAppReview = InAppReview.instance;
  final TextEditingController reviewController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    _loadVersion();
  }


  Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('In-app update error: $e');
      }
    }
  }

  Future<void> requestReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    }
  }
  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion = info.version;
    update();
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }

  void clearReview() {
    reviewController.clear();
  }
}

