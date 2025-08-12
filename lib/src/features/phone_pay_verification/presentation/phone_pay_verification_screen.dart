import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/phone_pay_verification/controller/phone_pay_verification_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/services/show_snack.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/check_widget.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';

class PhonePayVerificationScreen extends StatefulWidget {
  static const route = r'/phone/pay/verification';

  const PhonePayVerificationScreen({super.key});

  @override
  State<PhonePayVerificationScreen> createState() => _PhonePayVerificationScreenState();
}

class _PhonePayVerificationScreenState extends State<PhonePayVerificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<PhonePayVerificationController>(
          init: PhonePayVerificationController(),
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
                          CustomAppBar(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingExtraLarge,
                              ),
                              child: GetBuilder<PhonePayVerificationController>(
                                init: PhonePayVerificationController(),
                                builder: (controller) {
                                  return Form(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r'Подтверждение'.tr,
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
                                                          Container(
                                                            padding:EdgeInsets.all(AppDimensions.paddingMedium.w) ,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: AppColors.white,
                                                            ),
                                                            child: SvgPicture.asset(controller.payBox.get(controller.payKey)?.serviceIcon ?? '', color: AppColors.green,),
                                                          ),
                                                          Text(
                                                            controller.payBox.get(controller.payKey)?.serviceName ?? 'a',
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
                                                            controller.payBox.get(controller.payKey)?.sum ?? '',
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
                                                            r'Информация'.tr,
                                                            style: TextStyle(
                                                              fontSize: 17.sp,
                                                              color: AppColors.blackText,
                                                            ),
                                                          ),
                                                          SizedBox(height: 6.h,),
                                                          Padding(
                                                            padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  r'Номер телефона'.tr,
                                                                  style: TextStyle(
                                                                    fontSize: 14.sp,
                                                                    color: AppColors.blackText,
                                                                    fontFamily: AppFonts.secondaryFont,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  controller.payBox.get(controller.payKey)?.number ?? '',
                                                                  style: TextStyle(
                                                                    fontSize: 14.sp,
                                                                    color: AppColors.blackText,
                                                                    fontFamily: AppFonts.secondaryFont,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(color: AppColors.dividerColor, height: 1,),
                                                          Padding(
                                                            padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  r'Оптала через'.tr,
                                                                  style: TextStyle(
                                                                    fontSize: 14.sp,
                                                                    color: AppColors.blackText,
                                                                    fontFamily: AppFonts.secondaryFont,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  r'xxxx0689'.tr,
                                                                  style: TextStyle(
                                                                    fontSize: 14.sp,
                                                                    color: AppColors.blackText,
                                                                    fontFamily: AppFonts.secondaryFont,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(color: AppColors.dividerColor, height: 1,),
                                                          Padding(
                                                            padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  r'Категория'.tr,
                                                                  style: TextStyle(
                                                                    fontSize: 14.sp,
                                                                    color: AppColors.blackText,
                                                                    fontFamily: AppFonts.secondaryFont,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  r'Услуги'.tr,
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
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                Positioned(
                                                  top: 170,
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
                                                  top: 170,
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
                                  controller.startBankVerification();
                                },
                                isError: false,
                                isLoading: false,
                                child: Text(r'Оплатить'.tr),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if(controller.check == true)
                        CheckWidget(isLoading: controller.status == Status.loading, title: false,),
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
}

