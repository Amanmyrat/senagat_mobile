import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/globals.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  static const route = r'/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = Get.put(LoginController());

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
                            value: _controller.isLoading ? null : 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppDimensions.padding40.h),

                  Text(
                    'Телефон',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: AppColors.blackText,
                    ),
                  ),
                  Text(
                    'Мы отправим СМС с кодом подтверждения.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.greyInactive,
                      fontFamily: 'Gliroy',
                    ),
                  ),
                  SizedBox(height: AppDimensions.padding60.h),

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
                          _controller.countryCode,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                      SizedBox(width: AppDimensions.paddingSmall.w),
                      Expanded(
                        child: Obx(
                          () => TextField(
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              _controller.updatePhoneNumber(value);
                            },
                            maxLength: 8,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: AppFonts.primaryFont,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Введите номер',
                              errorText:
                                  _controller.phoneNumberError.value.isEmpty
                                  ? null
                                  : _controller.phoneNumberError.value,
                              counter: const SizedBox(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: AppDimensions.paddingExtraLarge.h,
                                horizontal: AppDimensions.paddingLarge.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppDimensions.paddingMedium.h),

                  Obx(
                    () => SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButtonWithState(
                        isLoading: _controller.isLoading,
                        isError: _controller.hasError,
                        child: Text('Отправить код'),
                        onPressed: _controller.sendVerificationCode,
                      ),
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
