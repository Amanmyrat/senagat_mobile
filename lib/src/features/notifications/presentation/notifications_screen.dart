import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/notification_controller.dart';

class NotificationsScreen extends StatefulWidget {
  static const route = r'/notifications';

  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(actionWidget: Container(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.greyInactive,
                  width: 1.w,
                  style: BorderStyle.solid,
                ),
              ),
              child: SvgPicture.asset(AppAssets.broomIcon, width: 20.w, color: AppColors.greyInactive,),
            ),),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingExtraLarge,
              ),
              child: GetBuilder<NotificationController>(
                init: NotificationController(),
                builder: (controller) {
                  return Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppDimensions.padding40.h),
                        Text(
                          r'notifications'.tr,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.blackText,
                          ),
                        ),

                        SizedBox(height: AppDimensions.paddingMedium.h),
                          Container(
                            padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                            height: 224.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusMedium.r,
                              ),
                              border: Border.all(color: AppColors.dividerColor, width: 1.w, style: BorderStyle.solid),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.dividerColor,
                                  blurRadius: 4.r,
                                ),
                              ],
                              color: AppColors.inputFillBackground,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(AppAssets.magnIcon, width: 60,),
                                Text(r'no_notifications'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 17.sp),),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButtonWithState(
                                    onPressed: (){

                                    },
                                    isError: false,
                                    isLoading: false,
                                    child: Text(r'go_to_catologist'.tr),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
