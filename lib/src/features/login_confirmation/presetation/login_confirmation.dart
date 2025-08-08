import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/login_confirmation_controller.dart';

class LoginConfiramationScreen extends StatefulWidget {
  static const route = r'/login_confirmation';

  const LoginConfiramationScreen({super.key});

  @override
  State<LoginConfiramationScreen> createState() =>
      _LoginConfiramationScreenState();
}

class _LoginConfiramationScreenState extends State<LoginConfiramationScreen> {
  late final LoginConfirmationController _controller;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    _controller = Get.put(LoginConfirmationController(args['phone']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<LoginConfirmationController>(
          builder: (_) => Form(
            key: _controller.formKey,
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
                      /// Step and loader
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            r'step_2_of_3'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.blackText,
                            ),
                          ),
                          SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: _controller.status == Status.loading
                                ? CircularProgressIndicator(
                                    color: AppColors.green,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.padding40.h),

                      /// Title and subtitle
                      Text(
                        r'OTP'.tr,
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: AppColors.blackText,
                        ),
                      ),
                      Text(
                        r'code_was_sent_to '
                                '${_controller.phoneNumber}'
                            .tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.greyInactive,
                          fontFamily: AppFonts.secondaryFont,
                        ),
                      ),
                      SizedBox(height: AppDimensions.padding60.h),

                      _controller.isPinFull || !_controller.pinLengthError
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                r'incorrectly_entered_OTP'.tr,
                                style: TextStyle(
                                  color: AppColors.redDark,
                                  fontSize: 15.sp,
                                  fontFamily: AppFonts.secondaryFont,
                                ),
                              ),
                            ),

                      /// PIN input
                      PinCodeTextField(
                        controller: _controller.otpController,
                        focusNode: _controller.otpFocus,
                        length: 5,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        cursorColor: AppColors.green,
                        backgroundColor: Colors.transparent,
                        cursorWidth: 3,
                        hintCharacter: '-',

                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10.r),
                          fieldHeight: 64.h,
                          fieldWidth: 74.w,
                          activeColor:
                              (_controller.isPinFull || _controller.timerEnded)
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
                          _controller.update();
                        },
                      ),

                      /// Apply button
                      Opacity(
                        opacity: _controller.isPinFull ? 1.0 : 0.5,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 64.h,
                          child: ElevatedButtonWithState(
                            isLoading: _controller.status == Status.loading,
                            isError:
                                _controller.status == Status.error ||
                                _controller.timerEnded,
                            onPressed: _controller.isPinFull
                                ? _controller.applyOtpCode
                                : null,
                            child: Text(
                              r'apply'.tr,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// Timer / resend
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
                          _controller.secondsLeft > 0
                              ? Text(
                                  '00:${_controller.secondsLeft.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    color: AppColors.blackText,
                                    fontSize: 15.sp,
                                    fontFamily: AppFonts.secondaryFont,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: _controller.status == Status.loading
                                      ? null
                                      : _controller.resendOtpCode,
                                  child: Text(
                                    r'send'.tr,
                                    style: TextStyle(
                                      color:
                                          _controller.status == Status.loading
                                          ? AppColors.greyInactive
                                          : AppColors.blackText,
                                      fontSize: 15.sp,
                                      fontWeight:
                                          _controller.status == Status.loading
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
