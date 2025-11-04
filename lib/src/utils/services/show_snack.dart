import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/constants/app_colors.dart';
import '../theme/constants/app_dimensions.dart';

@immutable
class ShowSnack {
  static const _duration = Duration(milliseconds: 2500);
  static const _margin = EdgeInsets.all(AppDimensions.paddingLarge);
  static const _border = AppDimensions.borderRadiusLarge;

  static void showSnack(String message, SnackType snackType) async {
    late final String title;
    late final Color color;
    late final Color bcColor;

    switch (snackType) {
      case SnackType.error:
        title = 'error'.tr;
        color = AppColors.redMedium;
        bcColor = const Color(0xFFF8EFED);
        break;
      case SnackType.warning:
        title = 'warning'.tr;
        color = AppColors.orangeLight;
        bcColor = const Color(0xFFFFFFFF);
        break;
      case SnackType.success:
        title = 'success'.tr;
        color = AppColors.blue;
        bcColor = const Color(0xFFFFFFFF);
        break;
    }
    final snack = GetSnackBar(
      // title: title,
      // titleText: Text(title,
      //     style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      message: message,
      messageText: Text(message,
          style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      backgroundColor: bcColor,
      borderColor: color,
      borderWidth: 2,
      duration: _duration,
      margin: _margin,
      borderRadius: _border,
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.closeCurrentSnackbar();
    Get.showSnackbar(snack);
  }
}

enum SnackType {
  error,
  warning,
  success,
}
