import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/auth/repository/auth_repository.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/register_confirmation_controller.dart';

class RegisterConfirmationScreen extends StatefulWidget {
  static const route = r'/register/confirmation';

  const RegisterConfirmationScreen({super.key});

  @override
  State<RegisterConfirmationScreen> createState() =>
      _RegisterConfirmationScreenState();
}

class _RegisterConfirmationScreenState extends State<RegisterConfirmationScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: GetBuilder<RegisterConfirmationController>(
          init: RegisterConfirmationController(AuthRepository(apiService: ApiServices.apiService)),
          builder: (controller) => Form(
            key: controller.formKey,
            child: Column(
              children: [
                const CustomAppBar(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingExtraLarge,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.login ? r'step_1_of_2'.tr :r'step_2_of_3'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.blackText,
                            ),
                          ),
                          SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: CircularProgressIndicator(
                              color: AppColors.green,
                              backgroundColor: AppColors.dividerColor,
                              value: controller.login ? 0.75 : 0.5,
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.padding40.h),

                      Text(
                        r'confirmation'.tr,
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: AppColors.blackText,
                        ),
                      ),
                      Text(
                        '${r'code_was_sent_to'.tr} ${controller.phoneNumber}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.greyInactive,
                          fontFamily: AppFonts.secondaryFont,
                        ),
                      ),
                      SizedBox(height: AppDimensions.padding60.h),

                      PinCodeTextField(
                        controller: controller.otpController,
                        focusNode: controller.otpFocus,
                        length: 5,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        cursorColor: AppColors.green,
                        backgroundColor: Colors.transparent,
                        cursorWidth: 3,
                        hintCharacter: '-',

                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r),
                          fieldHeight: 64.h,
                          fieldWidth: 74.w,
                          activeColor:
                              ( controller.status != Status.error)
                              ? AppColors.green
                              : AppColors.redDark,
                          activeFillColor: AppColors.inputFillBackground,
                          selectedColor: AppColors.green,
                          selectedFillColor: AppColors.inputFillBackground,
                          inactiveColor: AppColors.inputFillBackground,
                          inactiveFillColor: AppColors.inputFillBackground,
                        ),
                        textStyle: TextStyle(
                          color: AppColors.blackText,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        appContext: context,
                        autoDisposeControllers: false,
                        onChanged: (_) {
                          controller.update();
                        },
                      ),

                      Opacity(
                        opacity: controller.isPinFull ? 1.0 : 0.5,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 64.h,
                          child: ElevatedButtonWithState(
                            isLoading: controller.status == Status.loading,
                            isError: controller.status == Status.error,
                            onPressed:(){
                              if(controller.login && controller.isPinFull){
                                controller.applyOtpCode();
                              }else if(controller.login == false && controller.isPinFull){
                               controller.verifyOtp();
                              }
                            },
                            child: Text(
                              r'confirmation'.tr,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            r'send_code_again'.tr,
                            style: TextStyle(
                              color: AppColors.greyInactive,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppFonts.secondaryFont,
                            ),
                          ),
                          controller.secondsLeft > 0
                              ? Text(
                                  '00:${controller.secondsLeft.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    color: AppColors.blackText,
                                    fontSize: 15.sp,
                                    fontFamily: AppFonts.secondaryFont,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: controller.status == Status.loading
                                      ? null
                                      : controller.resendOtpCode,
                                  child: Text(
                                    r'send'.tr,
                                    style: TextStyle(
                                      color:
                                          controller.status == Status.loading
                                          ? AppColors.greyInactive
                                          : AppColors.blackText,
                                      fontSize: 15.sp,
                                      fontWeight:
                                          controller.status == Status.loading
                                          ? FontWeight.w400
                                          : FontWeight.bold,
                                      fontFamily: AppFonts.secondaryFont,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
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
