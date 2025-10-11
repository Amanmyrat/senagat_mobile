import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:senagat_mobile/src/features/foundation/presentation/foundation_screen.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_screen.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/check_widget.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import 'package:universal_image/universal_image.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/payment_verification_controller.dart';

class PaymentVerificationScreen extends StatefulWidget {
  static const route = r'/payment/verification';

  const PaymentVerificationScreen({super.key});

  @override
  State<PaymentVerificationScreen> createState() => _PaymentVerificationScreenState();
}

class _PaymentVerificationScreenState extends State<PaymentVerificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<PaymentVerificationController>(
          init: PaymentVerificationController(),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomAppBar(),
                              if(controller.isInquiries)
                                Padding(
                                  padding: EdgeInsets.only(right: AppDimensions.paddingExtraLarge, top: 22.h),
                                  child: Align(alignment: Alignment.bottomRight,child:
                                  Text('step_4_of_5'.tr, style: TextStyle(fontSize: 14.sp), )),
                                ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingExtraLarge,
                              ),
                              child: GetBuilder<PaymentVerificationController>(
                                init: PaymentVerificationController(),
                                builder: (controller) {
                                  return Form(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r'confirmation'.tr,
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            color: AppColors.blackText,
                                          ),
                                        ),

                                        SizedBox(height: AppDimensions.padding40.h),
                                        Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.green,
                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(AppDimensions.borderRadiusMedium.r,), topLeft: Radius.circular(AppDimensions.borderRadiusMedium.r,),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          if(controller.isFoundation == false && controller.isInquiries == false)
                                                            Container(
                                                              width: 50.w,
                                                              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium.w, horizontal: 10),
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: AppColors.white,
                                                              ),
                                                              child: UniversalImage(controller.serviceIcon ?? '', width: 30.w,),
                                                            ),
                                                          SizedBox(height: 6.h,),
                                                          Text(
                                                            controller.serviceName?.tr ?? '',
                                                            style: TextStyle(
                                                              fontSize: 17.sp,
                                                              color: AppColors.white,
                                                            ),
                                                          ),
                                                          SizedBox(height: 6.h,),
                                                          Text(
                                                            r'01 Августа, 10:15'.tr,
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                              color: AppColors.lightGreen,
                                                            ),
                                                          ),
                                                          SizedBox(height: 6.h,),
                                                          Text(

                                                            controller.sum ?? '',
                                                            style: TextStyle(
                                                              fontSize: 40.sp,
                                                              color: AppColors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.inputFillBackground,
                                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(AppDimensions.borderRadiusMedium.r,), bottomLeft: Radius.circular(AppDimensions.borderRadiusMedium.r,),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            r'information'.tr,
                                                            style: TextStyle(
                                                              fontSize: 17.sp,
                                                              color: AppColors.blackText,
                                                            ),
                                                          ),
                                                          SizedBox(height: 6.h,),
                                                          // Padding(
                                                          //   padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                                          //   child: Row(
                                                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //     children: [
                                                          //       Text(
                                                          //         r'phone_number'.tr,
                                                          //         style: TextStyle(
                                                          //           fontSize: 14.sp,
                                                          //           color: AppColors.blackText,
                                                          //           fontFamily: AppFonts.secondaryFont,
                                                          //         ),
                                                          //       ),
                                                          //       Text(
                                                          //         controller.number ?? '',
                                                          //         style: TextStyle(
                                                          //           fontSize: 14.sp,
                                                          //           color: AppColors.blackText,
                                                          //           fontFamily: AppFonts.secondaryFont,
                                                          //         ),
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                          // Divider(color: AppColors.dividerColor, height: 1.h,),
                                                          // controller.isInquiries ?
                                                          // Column(
                                                          //   children: [
                                                          //     Padding(
                                                          //       padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                                          //       child: Row(
                                                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //         children: [
                                                          //           Text(
                                                          //             r'name'.tr,
                                                          //             style: TextStyle(
                                                          //               fontSize: 14.sp,
                                                          //               color: AppColors.blackText,
                                                          //               fontFamily: AppFonts.secondaryFont,
                                                          //             ),
                                                          //           ),
                                                          //           Text(
                                                          //             controller.userName ?? '',
                                                          //             style: TextStyle(
                                                          //               fontSize: 14.sp,
                                                          //               color: AppColors.blackText,
                                                          //               fontFamily: AppFonts.secondaryFont,
                                                          //             ),
                                                          //           ),
                                                          //         ],
                                                          //       ),
                                                          //     ),
                                                          //     Divider(color: AppColors.dividerColor, height: 1.h,),
                                                          //   ],
                                                          // ): SizedBox(),
                                                          //
                                                          // Padding(
                                                          //   padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                                          //   child: Row(
                                                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //     children: [
                                                          //       Text(
                                                          //         r'payment_via'.tr,
                                                          //         style: TextStyle(
                                                          //           fontSize: 14.sp,
                                                          //           color: AppColors.blackText,
                                                          //           fontFamily: AppFonts.secondaryFont,
                                                          //         ),
                                                          //       ),
                                                          //       Text(
                                                          //         r'xxxx0689'.tr,
                                                          //         style: TextStyle(
                                                          //           fontSize: 14.sp,
                                                          //           color: AppColors.blackText,
                                                          //           fontFamily: AppFonts.secondaryFont,
                                                          //         ),
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                          // Divider(color: AppColors.dividerColor, height: 1.h,),
                                                          // Padding(
                                                          //   padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                                          //   child: Row(
                                                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //     children: [
                                                          //       Text(
                                                          //         r'category'.tr,
                                                          //         style: TextStyle(
                                                          //           fontSize: 14.sp,
                                                          //           color: AppColors.blackText,
                                                          //           fontFamily: AppFonts.secondaryFont,
                                                          //         ),
                                                          //       ),
                                                          //       Text(
                                                          //         r'services2'.tr,
                                                          //         style: TextStyle(
                                                          //           fontSize: 14.sp,
                                                          //           color: AppColors.blackText,
                                                          //           fontFamily: AppFonts.secondaryFont,
                                                          //         ),
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                          inquiriesInformation(controller),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                Positioned(
                                                  top: controller.isInquiries || controller.isFoundation ? 130 : 170,
                                                  left: -10,
                                                  child: Container(
                                                    width: 30.w,
                                                    height: 30.h,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors.white
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: controller.isInquiries || controller.isFoundation ? 130 : 170,
                                                  right: -10,
                                                  child: Container(
                                                    width: 30.w,
                                                    height: 30.h,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors.white
                                                    ),
                                                  ),
                                                ),
                                              ],),

                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButtonWithState(
                                onPressed: (){
                                  if(controller.isInquiries){
                                    Get.toNamed(PaymentScreen.route);
                                  }else {
                                    controller.startBankVerification();
                                  }
                                },
                                isError: controller.status == Status.error,
                                isLoading: controller.status == Status.loading,
                                child: Text(controller.isInquiries ? r'next'.tr : r'pay'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.white),),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if(controller.check == true)
                        CheckWidget(isLoading: controller.status == Status.loading,
                          isTitle: false, route: controller.isInquiries ? FoundationScreen.route : DashboardScreen.route,
                          buttonTitle:controller.isFoundation ? r'fund_page'.tr : r'home_page'.tr,
                        ),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
  Widget inquiriesInformation(PaymentVerificationController controller){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r'name'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
              Text(
                controller.firstName ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.dividerColor, height: 1.h,),
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r'lastName'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
              Text(
                controller.lastName ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.dividerColor, height: 1.h,),
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r'surname'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
              Text(
                controller.surname ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.dividerColor, height: 1.h,),
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r'date_birth'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
              Text(
                controller.birthDate ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.dividerColor, height: 1.h,),
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r'passport_number'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
              Text(
                controller.passportNumber ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.dividerColor, height: 1.h,),
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r'date_issue'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
              Text(
                controller.issuedDate ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.dividerColor, height: 1.h,),
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r'place_of_issue'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
              Text(
                controller.issuedBy ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.blackText,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

