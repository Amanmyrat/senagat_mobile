import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/localization/localization_service.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../../utils/localization/controller/language_controller.dart';
import '../controller/welcome_controller.dart';

class WelcomeScreen extends StatefulWidget {
  static const route = '/welcome';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final WelcomeController _controller = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // First green container (top left, rotated -45°)
          Positioned(
            left: -130,
            top: -160,
            child: Transform.rotate(
              angle: -0.785398, // -45 degrees in radians
              child: Container(
                width: 337.w,
                height: 339.h,
                decoration: BoxDecoration(
                  color: AppColors.green, // Use a green color here
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
          // Second green container (left center, 45% from top)
          Positioned(
            right: -50,
            top: MediaQuery.of(context).size.height * 0.45 - 75,
            child: Transform.rotate(
              angle: -0.785398, // -45 degrees in radians
              child: Container(
                width: 150.w,
                height: 150.h,
                decoration: BoxDecoration(
                  color: AppColors.green, // Use a green color here
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingExtraLarge),
              child: Column(
                children: [
                  // Top right dropdown for language selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GetBuilder<LanguageController>(
                        init: LanguageController(),
                        builder: (controller) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: AppColors.green,
                              cardTheme: const CardThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: AppColors.green,
                              ),
                              child: DropdownButton<String>(
                                value: _controller.getCurrentLanguageCode(),
                                icon: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    AppColors.white,
                                    BlendMode.srcIn,
                                  ),
                                  child: SvgPicture.asset(
                                    AppAssets.caretDownIcon,
                                    width: 18.w,
                                  ),
                                ),
                                underline: SizedBox(),
                                borderRadius: BorderRadius.circular(12),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    _controller.updateLanguage(newValue);
                                  }
                                },
                                items: _controller.langCodes
                                    .map<DropdownMenuItem<String>>((
                                      String code,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: code,
                                        child: Text(
                                          code,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 220.h,
                        padding: EdgeInsets.all(
                          AppDimensions.paddingExtraLarge,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.transparent.withOpacity(0.05),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'Senagat Bank',
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '3576',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: AppColors.greyInactive,
                                  ),
                                ),
                                Text(
                                  '1239',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: AppColors.greyInactive,
                                  ),
                                ),
                                Text(
                                  '1234',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: AppColors.greyInactive,
                                  ),
                                ),
                                Text(
                                  '0689',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: AppColors.greyInactive,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                '08/27',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.greyInactive,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    AppAssets.senagatIcon,
                    width: 134.w,
                    height: 135.h,
                  ),
                  Text(
                    'Senagat töleg',
                    style: TextStyle(
                      color: AppColors.blackText,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Оплатить можно практически всё!',
                    style: TextStyle(
                      color: AppColors.greyInactive,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: AppDimensions.padding60),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButtonWithState(
                      isLoading: _controller.isLoading,
                      isError: _controller.hasError,
                      child: Text('Создать аккаунт'),
                      onPressed: _controller.navigateToCreateAccount,
                    ),
                  ),
                  SizedBox(height: AppDimensions.paddingExtraLarge.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'У вас уже есть аккаунт?',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.greyInactive,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: _controller.navigateToLogin,
                        child: Text(
                          'Войти',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.blackText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
