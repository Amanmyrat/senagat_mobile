import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/welcome_controller.dart';


class WelcomeScreen extends StatefulWidget {
  static const route = '/welcome';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<WelcomeController>(
        init: WelcomeController(),
        builder: (controller){
          return  Stack(
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
              SafeArea(
                child: Padding(
                  padding:  EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: AppColors.green,
                              cardTheme: CardThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.r),
                                  ),
                                ),
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r),
                                color: AppColors.green,
                              ),
                              child: DropdownButton<String>(
                                value: controller.getCurrentLanguageCode(),
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
                                borderRadius: BorderRadius.circular(12.r),
                                onChanged: (String? newValue) {
                                  controller.updateLanguage(newValue ?? '');
                                },

                                items: controller.langCodes
                                    .map<DropdownMenuItem<String>>((
                                    String code,
                                    ) {
                                  return DropdownMenuItem<String>(
                                    value: code,
                                    child: Text(
                                      code,
                                      style:  TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  );
                                })
                                    .toList(),
                              ),
                            ),
                          )
                        ],
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 32.h),
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(AppDimensions.borderRadiusExtraLarge.r),
                                //   child: BackdropFilter(
                                //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                //
                                //     child: Container(
                                //       width: MediaQuery.of(context).size.width,
                                //       height: 220.h,
                                //       padding: EdgeInsets.all(
                                //         AppDimensions.paddingExtraLarge,
                                //       ),
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r),
                                //         color: Colors.transparent.withOpacity(0.05),
                                //       ),
                                //       child: Column(
                                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //         children: [
                                //           Align(
                                //             alignment: Alignment.topRight,
                                //             child: Text(
                                //               'Senagat Bank',
                                //               style: TextStyle(
                                //                 color: AppColors.blackText,
                                //                 fontSize: 14.sp,
                                //                 fontFamily: AppFonts.XoloniumFont,
                                //               ),
                                //             ),
                                //           ),
                                //           Row(
                                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //             children: [
                                //               Text(
                                //                 '3576',
                                //                 style: TextStyle(
                                //                   fontSize: 20.sp,
                                //                   color: AppColors.greyInactive,
                                //                   fontFamily: AppFonts.XoloniumFont,
                                //                 ),
                                //               ),
                                //               Text(
                                //                 '1239',
                                //                 style: TextStyle(
                                //                   fontSize: 20.sp,
                                //                   color: AppColors.greyInactive,
                                //                   fontFamily: AppFonts.XoloniumFont,
                                //                 ),
                                //               ),
                                //               Text(
                                //                 '1234',
                                //                 style: TextStyle(
                                //                   fontSize: 20.sp,
                                //                   color: AppColors.greyInactive,
                                //                   fontFamily: AppFonts.XoloniumFont,
                                //                 ),
                                //               ),
                                //               Text(
                                //                 '0689',
                                //                 style: TextStyle(
                                //                   fontSize: 20.sp,
                                //                   color: AppColors.greyInactive,
                                //                   fontFamily: AppFonts.XoloniumFont,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //           Align(
                                //             alignment: Alignment.bottomLeft,
                                //             child: Text(
                                //               '08/27',
                                //               style: TextStyle(
                                //                 fontSize: 14.sp,
                                //                 color: AppColors.greyInactive,
                                //                 fontFamily: AppFonts.XoloniumFont,
                                //               ),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // Spacer(),
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
                                  r'pay_everything'.tr,
                                  style: TextStyle(
                                    color: AppColors.greyInactive,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppDimensions.padding60,),
                        
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButtonWithState(
                              isLoading: controller.status == Status.loading,
                              isError: controller.status == Status.error,
                              onPressed: controller.navigateToCreateAccount,
                              child: Text(r'create_account'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.white),),
                            ),
                          ),
                          SizedBox(height: AppDimensions.paddingExtraLarge.h),
                          GestureDetector(
                            onTap: () => controller.navigateToLogin(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  r'do_you_have_account'.tr,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.greyInactive,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  r'sign_in'.tr,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.blackText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },

      ),
    );
  }
}
