import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();

  bool isDarkMode = false;

  void changeMode() {
    isDarkMode = !isDarkMode;
    _box.write(r'theme', isDarkMode);
    Get.changeThemeMode(!isDarkMode ? ThemeMode.light : ThemeMode.dark);

    update();
  }

  void _init() async {
    bool? isDarkMode = _box.read<bool>(r'theme');
    if (isDarkMode == null) {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      isDarkMode = brightness == Brightness.dark;
    }

    this.isDarkMode = isDarkMode;
  }

  @override
  void onInit() {
    _init();
    super.onInit();
  }
}
