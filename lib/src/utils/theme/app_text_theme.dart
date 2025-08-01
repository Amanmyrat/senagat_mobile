import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  const AppTextTheme._();

  static const AppTextTheme _singleton = AppTextTheme._();

  factory AppTextTheme() {
    return _singleton;
  }

  static final AppTextTheme instance = AppTextTheme();

  TextTheme get lightTheme {
    final textTheme = GoogleFonts.robotoTextTheme(ThemeData.light().textTheme);

    return textTheme;
  }

  TextTheme get darkTheme {
    final textTheme = GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme);

    return textTheme;
  }
}
