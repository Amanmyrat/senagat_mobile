import 'package:flutter/material.dart';
import 'constants/app_fonts.dart';

class AppTextTheme {
  const AppTextTheme._();

  static const AppTextTheme _singleton = AppTextTheme._();

  factory AppTextTheme() {
    return _singleton;
  }

  static final AppTextTheme instance = AppTextTheme();

  TextTheme get lightTheme {
    final base = ThemeData.light().textTheme;
    return base.apply(fontFamily: AppFonts.primaryFont,);
  }

  TextTheme get darkTheme {
    final base = ThemeData.dark().textTheme;
    return base.apply(fontFamily: AppFonts.primaryFont);
  }
}
