import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'app_text_theme.dart';

import 'constants/app_colors.dart';
import 'constants/app_dimensions.dart';

class AppTheme {
  static const _singleton = AppTheme._();

  factory AppTheme() => _singleton;

  const AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      color: AppColors.green,
      centerTitle: true,
      elevation: 1.0,
      iconTheme: IconThemeData(color: AppColors.grey),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    brightness: Brightness.light,
    canvasColor: AppColors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.green,
      onPrimary: AppColors.white,
      background: AppColors.white,
      surface: AppColors.lighterGrey,
      secondary: AppColors.redLight,
      tertiary: AppColors.lightGrey,
      shadow: AppColors.blueLight,
      primaryContainer: AppColors.lightBlack,
      secondaryContainer: AppColors.white,
      tertiaryContainer: AppColors.mediumGrey,
      surfaceVariant: AppColors.blue,
      outline: AppColors.blue,
      surfaceTint: AppColors.white,
    ),
    dividerColor: AppColors.dividerColor,
    dividerTheme: const DividerThemeData(color: AppColors.lightGrey),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.extraLightGrey,
        fixedSize: const Size.fromHeight(AppDimensions.buttonHeight),
        elevation: 1.0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
      ),
      filled: true,
      fillColor: AppColors.inputFillBackground,
      labelStyle: AppTextTheme.instance.lightTheme.bodySmall?.copyWith(
        color: AppColors.blackText,
        fontWeight: FontWeight.w400,
        fontSize: 14.0.sp,
        fontFamily: AppFonts.primaryFont,
      ),
      hintStyle: AppTextTheme.instance.lightTheme.bodySmall?.copyWith(
        color: AppColors.greyInactive,
        fontWeight: FontWeight.w400,
        fontSize: 14.0.sp,
        fontFamily: AppFonts.primaryFont,
      ),
      prefixStyle: AppTextTheme.instance.lightTheme.bodySmall?.copyWith(
        color: AppColors.grey,
        fontWeight: FontWeight.w300,
        fontSize: 12.0.sp,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        borderSide: const BorderSide(color: AppColors.green),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        borderSide: const BorderSide(color: AppColors.inputFillBackground),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        borderSide: const BorderSide(color: AppColors.inputFillBackground),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.green),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        fixedSize: Size.fromHeight(AppDimensions.buttonHeight.h),
        foregroundColor: AppColors.green,
        side: const BorderSide(color: AppColors.redMedium),
      ),
    ),
    textTheme: AppTextTheme.instance.lightTheme,
    fontFamily: AppFonts.primaryFont,
  );
}
