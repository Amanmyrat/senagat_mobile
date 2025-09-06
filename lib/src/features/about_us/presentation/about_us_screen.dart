import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/about_us/controller/about_us_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';

import '../../../utils/theme/constants/app_colors.dart';

class AboutUsScreen extends StatefulWidget {
  static const route = '/about';
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GetBuilder<AboutUsController>(
            init: AboutUsController(),
            builder: (controller) {
              return Column(
                children: [
                  CustomAppBar(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                            child: Text(r'About_Us'.tr, style: TextStyle(fontSize: 24.sp, color: AppColors.black),)),
                        SizedBox(height: 32.h,),
                        Column(
                          children: [
                            Image.asset(AppAssets.senagatIcon),
                            SizedBox(height: AppDimensions.paddingMedium,),
                            Text(r'Senagat töleg'.tr, style: TextStyle(fontSize: 24.sp, color: AppColors.black),),
                            SizedBox(height: 4.h,),
                            Text(r'Version_2.0'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.black, fontFamily: AppFonts.secondaryFont),),
                          ],
                        ),
                        SizedBox(height: 18.h,),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r'Recommend_to_your_friends'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.blackText,),),
                              SizedBox(height: 16.h,),
                              SegmentedButton<int>(
                                segments: List.generate(
                                  10,
                                      (i) => ButtonSegment<int>(
                                    value: i + 1,
                                    label: Text("${i + 1}", style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont),),
                                  ),
                                ),
                                style: ButtonStyle(

                                  maximumSize: WidgetStatePropertyAll(Size.fromHeight(34)),
                                    side: WidgetStatePropertyAll(BorderSide(color: AppColors.dividerColor)),
                                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadiusGeometry.circular(AppDimensions.paddingMedium.r),
                                    )
                                  ),
                                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                        (states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return AppColors.green;
                                      }
                                      return AppColors.white;
                                    },
                                  ),
                                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                                        (states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return AppColors.white;
                                      }
                                      return AppColors.blackText;
                                    },
                                  ),
                                ),

                                showSelectedIcon: false,
                                selected: {controller.selected},
                                onSelectionChanged: (newSelection) {
                                  setState(() {
                                    controller.selected = newSelection.first;
                                  });
                                },
                              ),
                              if(controller.selected != 0)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(height: 16.h,),
                                    TextFormField(
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: r'Write_your_review'.tr,
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.borderRadiusMedium,
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.green,
                                          width: 1.w,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.borderRadiusMedium,
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.white,
                                          width: 1.w,
                                        ),
                                      ),
                                      counter: const SizedBox(),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: AppDimensions.paddingExtraLarge.h,
                                        horizontal: AppDimensions.paddingLarge.w,
                                      ),
                                    ),
                                                              ),
                                    SizedBox(height: 16.h,),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: AppDimensions.paddingMedium.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(AppDimensions.paddingMedium.r),
                                        color: AppColors.green
                                      ),
                                      child: Text(r'Send'.tr, style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont, color: AppColors.white),),
                                    ),
                                  ],
                                ),
                            ],
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 10.w,),
                                    Text(r'Application_update_v2.0'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.blackText, fontFamily: AppFonts.secondaryFont),),
                                  ],
                                ),
                                SvgPicture.asset(AppAssets.arrowRightIcon, color: AppColors.black, width: 18.w,)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          )
      ),
    );
  }
}
