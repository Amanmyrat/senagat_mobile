import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import '../controller/auth_success_controller.dart';

class AuthSuccessScreen extends StatefulWidget {
  static const route = '/auth/success';
  const AuthSuccessScreen({super.key});

  @override
  State<AuthSuccessScreen> createState() => _AuthSuccessScreenState();
}

class _AuthSuccessScreenState extends State<AuthSuccessScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<AuthSuccessController>(
          init: AuthSuccessController(),
          builder: (controller) => Padding(
            padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.senagatIcon, width: 134.w, height: 135.h),
                  Text(
                    'Senagat töleg',
                    style: TextStyle(
                      color: AppColors.blackText,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    r'pay_everything'.tr,
                    style: TextStyle(
                      color: AppColors.greyInactive,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 35.h),

                   SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: controller.status == Status.loading
                          ? CircularProgressIndicator(color: AppColors.green)
                          : SvgPicture.asset(
                              AppAssets.checkIcon,
                              color: AppColors.green,
                            ),
                    ),


                  SizedBox(height: AppDimensions.paddingMedium.h),

                  Text(
                    r'check_bank'.tr,
                    style: TextStyle(color: AppColors.blackText, fontSize: 17.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
