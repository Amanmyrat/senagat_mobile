import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/foundation/presentation/foundation_screen.dart';
import '../features/card/controller/card_controller.dart';
import '../features/dashboard/controller/dashboard_controller.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/dashboard/utils/nested_nav_ids.dart';
import '../features/home/controller/home_controller.dart';
import '../utils/constants/app_assets.dart';
import '../utils/theme/constants/app_colors.dart';
import '../utils/theme/constants/app_dimensions.dart';
import 'elevated_button_with_state.dart';

class CheckWidget extends StatelessWidget {
  final bool isTitle;
  final bool isLoading;
  final String? route;
  final String? buttonTitle;
  final String successTitle;
  final String? title;

  const CheckWidget({
    super.key,
    required this.isTitle,
    required this.isLoading,
    this.route,
    this.buttonTitle,
    required this.successTitle,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: AppColors.black.withOpacity(0.4),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: AppDimensions.padding40.h),
            margin: EdgeInsets.all(AppDimensions.marginExtraLarge.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusExtraLarge.r,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppAssets.senagatIcon),
                if (isTitle == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 22.h),
                      Text(
                        title ?? '',
                        style: TextStyle(
                          color: AppColors.blackText,
                          fontSize: 24.sp,
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 22.h),
                isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          color: AppColors.green,
                        ),
                      )
                    : SvgPicture.asset(
                        AppAssets.checkIcon,
                        color: AppColors.green,
                        width: 24.w,
                      ),

                SizedBox(height: AppDimensions.paddingMedium.h),

                isLoading
                    ? Text(r'check_bank'.tr, textAlign: TextAlign.center)
                    : Text(
                        successTitle.tr,
                        textAlign: TextAlign.center,
                      ),

                if (isTitle == false) SizedBox(height: 22.h),

                if (isTitle == false)
                  isLoading
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingExtraLarge.w,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButtonWithState(
                              onPressed: () {
                                final homeController = Get.find<HomeController>();
                                final cardController = Get.find<CardController>();
                                homeController.paymentTimer = true;
                                homeController.getProfile();
                                cardController.getUserProfileInfo();

                                Get.offAllNamed(DashboardScreen.route);
                              },

                              isError: false,
                              isLoading: false,
                              child: Text(
                                buttonTitle ?? '',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
