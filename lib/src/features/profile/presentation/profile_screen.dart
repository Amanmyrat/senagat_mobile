import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/about_us/presentation/about_us_screen.dart';
import 'package:senagat_mobile/src/features/identify/presentation/identify_screen.dart';
import 'package:senagat_mobile/src/features/lang_settings/presentation/lang_settings_screen.dart';
import 'package:senagat_mobile/src/features/notifications_settings/presentation/notifications_settings_screen.dart';
import 'package:senagat_mobile/src/features/accounts/presentation/accounts.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';

import '../../../utils/theme/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  static const route = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 40),
                    width: 110.w,
                    height: 110.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.dividerColor, width: 1.w, style: BorderStyle.solid),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.dividerColor,
                          blurRadius: 4.r,
                        ),
                      ],
                      color: AppColors.white,
                    ),
                    child: Image.asset(AppAssets.senagatIcon),
                  ),
                ),
                SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(r'Имя Фамилия'.tr, style: TextStyle(fontSize: 24, color: AppColors.black),),
                    SvgPicture.asset(AppAssets.arrowRightIcon, color: AppColors.black, width: 18.w,)
                  ],
                ),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(IdentifyScreen.route);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium.w, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r),
                          color: AppColors.greyInactive,
                        ),
                        child: Text(r'Not_confirmed'.tr, style: TextStyle(fontSize: 14, color: AppColors.white, fontFamily: AppFonts.secondaryFont),),
                      ),
                      SizedBox(width: 10.w,),
                      Text('+99364626088', style: TextStyle(fontSize: 14, color: AppColors.black,),),
                    ],
                  ),
                ),
                SizedBox(height: 32.h,),
                Text(r'Control'.tr, style: TextStyle(fontSize: 14, color: AppColors.black,),),
                SizedBox(height: 16.h,),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(AccountScreen.route);
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
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
                      color: AppColors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(AppAssets.edit,width: 24.w,),
                            SizedBox(width: 10.w,),
                            Text(r'Accounts'.tr, style: TextStyle(fontSize: 14.sp.sp, color: AppColors.blackText, fontFamily: AppFonts.secondaryFont),),
                          ],
                        ),
                        SvgPicture.asset(AppAssets.arrowRightIcon, color: AppColors.black, width: 16.w,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h,),
                Container(
                  padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
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
                    color: AppColors.white,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.toNamed(NotificationsSettingsScreen.route);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(AppAssets.bellSimpleIcon, color: AppColors.green, width: 24.w,),
                                  SizedBox(width: 10.w,),
                                  Text(r'notifications'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.blackText, fontFamily: AppFonts.secondaryFont),),
                                ],
                              ),
                              SvgPicture.asset(AppAssets.arrowRightIcon, color: AppColors.black, width: 16.w,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 26.h,),
                      GestureDetector(
                        onTap: (){
                          Get.toNamed(LangSettingsScreen.route);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(AppAssets.globeIcon, color: AppColors.green, width: 24.w,),
                                  SizedBox(width: 10.w,),
                                  Text(r'Language'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.blackText, fontFamily: AppFonts.secondaryFont),),
                                ],
                              ),
                              SvgPicture.asset(AppAssets.arrowRightIcon, color: AppColors.black, width: 16.w,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h,),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(AboutUsScreen.route);
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
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
                      color: AppColors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(AppAssets.filledInfo),
                            SizedBox(width: 10.w,),
                            Text(r'About_Us_v2.0'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.blackText, fontFamily: AppFonts.secondaryFont),),
                          ],
                        ),
                        SvgPicture.asset(AppAssets.arrowRightIcon, color: AppColors.black, width: 16.w,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
