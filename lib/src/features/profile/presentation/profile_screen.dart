import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/about_us/presentation/about_us_screen.dart';
import 'package:senagat_mobile/src/features/identify/presentation/identify_screen.dart';
import 'package:senagat_mobile/src/features/lang_settings/presentation/lang_settings_screen.dart';
import 'package:senagat_mobile/src/features/notifications_settings/presentation/notifications_settings_screen.dart';
import 'package:senagat_mobile/src/features/accounts/presentation/accounts_screen.dart';
import 'package:senagat_mobile/src/features/profile/controller/profile_controller.dart';
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
          child: GetBuilder<ProfileController>(
            builder: (controller) {
              return Padding(
                padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(IdentifyScreen.route);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 40.h),
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
                              Text('${controller.profileBox
                                  .get('currentProfile')
                                  ?.firstName ?? r'name'.tr}  ${controller
                                  .profileBox
                                  .get('currentProfile')
                                  ?.lastName ?? r'last_name'.tr}',
                                maxLines: 1 ,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 24.sp, color: AppColors.black),),
                              SvgPicture.asset(AppAssets.arrowRightIcon, color: AppColors.black, width: 18.w,)
                            ],
                          ),
                          Column(
                            children: [

                              Text('+993 ${controller.phoneBox.get('phone')}', style: TextStyle(fontSize: 17.sp, color: AppColors.black,),),
                              SizedBox(height: 5.h,),

                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                  AppDimensions.paddingMedium.w,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusMedium.r,
                                  ),
                                  color: controller.checkProfileStatus(),
                                ),
                                child: Text(
                                  controller.profileBox.get('currentProfile')?.status?.tr ?? 'not_confirmed'.tr,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.white,
                                    fontFamily: AppFonts.secondaryFont,
                                  ),
                                ),
                              ),


                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h,),
                    Text(r'control'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.black,),),
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
                              Get.toNamed(AccountScreen.route);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium.h),
                              color: AppColors.white,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppAssets.edit,width: 24.w,),
                                      SizedBox(width: 10.w,),
                                      Text(r'accounts'.tr, style: TextStyle(fontSize: 14.sp.sp, color: AppColors.blackText, fontFamily: AppFonts.secondaryFont),),
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
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium.h),
                              color: AppColors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppAssets.globeIcon, color: AppColors.green, width: 24.w,),
                                      SizedBox(width: 10.w,),
                                      Text(r'language'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.blackText, fontFamily: AppFonts.secondaryFont),),
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
                              Get.toNamed(AboutUsScreen.route);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium.h),
                              color: AppColors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(AppAssets.filledInfo),
                                      SizedBox(width: 10.w,),
                                      Text(r'about_Us_v1.0'.trParams({'version': controller.appVersion}).tr, style: TextStyle(fontSize: 14.sp, color: AppColors.blackText, fontFamily: AppFonts.secondaryFont),),
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

                  ],
                ),
              );
            }
          )
      ),
    );
  }
}
