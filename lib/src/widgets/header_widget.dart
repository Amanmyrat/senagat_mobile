import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../features/home/controller/home_controller.dart';
import '../features/map_search/presentation/map_search_screen.dart';
import '../utils/constants/app_assets.dart';
import '../utils/theme/constants/app_colors.dart';
import '../utils/theme/constants/app_dimensions.dart';
import '../utils/theme/constants/app_fonts.dart';

class HeaderWidget extends StatefulWidget{
  const HeaderWidget({super.key});


  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.only(bottom: 22.h),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  onTap: () {
                    Get.toNamed(MapSearchScreen.route);
                  },
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  maxLength: 8,
                  style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
                  decoration: InputDecoration(
                    hintText: r'find_an_ATM'.tr,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMedium,
                      ),
                      borderSide: BorderSide(color: AppColors.white, width: 1.w),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 20.w,
                      minHeight: 20.h,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: AppDimensions.paddingExtraLarge.w,
                        right: AppDimensions.paddingMedium.w,
                      ),
                      child: SvgPicture.asset(AppAssets.searchIcon, width: 20.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMedium,
                      ),
                      borderSide: BorderSide(color: AppColors.white, width: 1.w),
                    ),

                    counter: const SizedBox(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: AppDimensions.paddingLarge.w,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              GestureDetector(
                onTap: () {
                  controller.onQrScanTap();
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium.r,
                    ),
                    color: controller.lastTap == HomeTapType.qr
                        ? AppColors.green
                        : AppColors.inputFillBackground,
                  ),
                  child: SvgPicture.asset(
                    AppAssets.qrCodeIcon,
                    width: 20.w,
                    color: controller.lastTap == HomeTapType.qr
                        ? AppColors.white
                        : AppColors.black,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              GestureDetector(
                onTap: () {
                  controller.onNotificationScanTap();
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium.r,
                    ),
                    color: controller.lastTap == HomeTapType.notification
                        ? AppColors.green
                        : AppColors.inputFillBackground,
                  ),
                  child: SvgPicture.asset(
                    AppAssets.bellSimpleIcon,
                    width: 20.w,
                    color: controller.lastTap == HomeTapType.notification
                        ? AppColors.white
                        : AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}