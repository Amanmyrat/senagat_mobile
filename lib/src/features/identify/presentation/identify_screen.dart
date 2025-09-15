import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/identity_verification/presentation/identity_verification_screen.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';

import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';

class IdentifyScreen extends StatefulWidget {
  static const route = '/identify';
  const IdentifyScreen({super.key});

  @override
  State<IdentifyScreen> createState() => _IdentifyScreenState();
}

class _IdentifyScreenState extends State<IdentifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(),
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 40.h),
                    width: 80.w,
                    height: 80.h,
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
                Positioned(
                  left: 210,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(1.w),
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
                        child: SvgPicture.asset(AppAssets.edit, width: 20.w,color: AppColors.greyInactive,),
                      ),
                    ),
                )
              ],
            ),
            SizedBox(height: AppDimensions.padding40.h,),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingExtraLarge.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r'phone_number'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                    SizedBox(height: 16.h,),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            AppDimensions.paddingExtraLarge.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.inputFillBackground,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusMedium,
                            ),
                          ),
                          child: Text(
                            '+993',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                        SizedBox(width: AppDimensions.paddingSmall.w),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            maxLength: 8,
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: r'enter_number'.tr,
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
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h,),
                    GestureDetector(
                      onTap: (){
                        Get.offNamed(IdentityVerificationScreen.route);
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
                            Expanded(child: Text(r'identity_verification'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.blackText, fontFamily: AppFonts.secondaryFont),)),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium.w, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r),
                                    color: AppColors.greyInactive,
                                  ),
                                  child: Text(r'not_confirmed'.tr, style: TextStyle(fontSize: 14, color: AppColors.white, fontFamily: AppFonts.secondaryFont),),
                                ),
                                SizedBox(width: 10.w,),
                                SvgPicture.asset(AppAssets.arrowRightIcon, color: AppColors.black, width: 16.sp,),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButtonWithState(
                  customStyle: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: BorderSide(color: AppColors.dividerColor),
                    shadowColor: Colors.transparent
                  ),
                  isLoading: false,
                  isError: false,
                  onPressed:() {

                  },
                  child: Text(r'logout'.tr,style: TextStyle(color: AppColors.black, fontSize: 14.sp),),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
