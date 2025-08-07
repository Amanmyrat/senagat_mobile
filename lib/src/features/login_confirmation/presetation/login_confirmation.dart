import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
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
  final LoginConfirmationController _controller = Get.put(
    LoginConfirmationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(),

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
                      Obx(
                        () => Text(
                          'Шаг ${_controller.currentStep} из 3',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.blackText,
                          ),
                        ),
                      ),

                      Obx(
                        () => SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: CircularProgressIndicator(
                            color: AppColors.green,
                            value: _controller.isLoading ? null : 0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppDimensions.padding40.h),

                  Text(
                    'OTP',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: AppColors.blackText,
                    ),
                  ),
                  Obx(
                    () => Text(
                      'Код был отправлен на ${_controller.phoneNumber}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.greyInactive,
                        fontFamily: 'Gliroy',
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.padding60.h),

                  Obx(
                    () => _controller.isPinFull || !_controller.pinLengthError
                        ? SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Неправильно введен OTP',
                              style: TextStyle(
                                color: AppColors.redDark,
                                fontSize: 15.sp,
                                fontFamily: AppFonts.secondaryFont,
                              ),
                            ),
                          ),
                  ),

                  PinCodeTextField(
                    length: 5,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    cursorColor: AppColors.green,
                    backgroundColor: Colors.transparent,
                    cursorWidth: 3,
                    hintCharacter: '-',
                    onChanged: (value) {
                      _controller.updateOtpCode(value);
                      if (_controller.hasError || _controller.pinLengthError)
                        debugPrint("aaaa");
                      _controller.resetError();
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10.r),
                      fieldHeight: 64.h,
                      fieldWidth: 74.w,
                      selectedFillColor: AppColors.inputFillBackground,
                      selectedColor: AppColors.green,
                      activeColor:
                          (_controller.hasError ||
                              _controller.isPinFull ||
                              _controller.timerEnded)
                          ? AppColors.green
                          : AppColors.redDark,

                      activeFillColor: AppColors.inputFillBackground,
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
                  ),

                  Obx(
                    () => Opacity(
                      opacity: _controller.isPinFull ? 1.0 : 0.5,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 64.h,
                        child: ElevatedButtonWithState(
                          isLoading: _controller.isLoading,
                          isError:
                              _controller.hasError || _controller.timerEnded,
                          onPressed: _controller.isPinFull
                              ? _controller.applyOtpCode
                              : null,
                          child: Text(
                            'Применить',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Отправить код повторно'.tr,
                          style: TextStyle(
                            color: AppColors.greyInactive,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppFonts.secondaryFont,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingMedium.h,
                          ),
                          child: _controller.secondsLeft > 0
                              ? Text(
                                  '00:${_controller.secondsLeft.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    color: AppColors.blackText,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: AppFonts.secondaryFont,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: _controller.isLoading
                                      ? null
                                      : _controller.resendOtpCode,
                                  child: Text(
                                    'Отправить',
                                    style: TextStyle(
                                      color: _controller.isLoading
                                          ? AppColors.greyInactive
                                          : AppColors.blackText,
                                      fontSize: 15.sp,
                                      fontWeight: _controller.isLoading
                                          ? FontWeight.w400
                                          : FontWeight.bold,
                                      fontFamily: AppFonts.secondaryFont,
                                    ),
                                  ),
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
      ),
    );
  }
}
