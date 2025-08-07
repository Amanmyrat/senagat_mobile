import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/password_controller.dart';

class PasswordScreen extends StatefulWidget {
  static const route = r'/passsword';

  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final PasswordController _controller = Get.put(PasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<PasswordController>(
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
                      /// Шаг и индикатор
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            r'step_3_of_3'.tr,
                            style: TextStyle(
                              fontSize: 14,
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

                      SizedBox(height: 40.h),

                      /// Заголовок
                      Text(
                        r'new_password'.tr,
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.blackText,
                        ),
                      ),
                      Text(
                        r'create_password'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.greyInactive,
                          fontFamily: AppFonts.secondaryFont,
                        ),
                      ),
                      SizedBox(height: AppDimensions.padding60.h),

                      /// Поле ввода пароля
                      TextFormField(
                        controller: _controller.passwordController,
                        focusNode: _controller.passwordFocus,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_controller.isPasswordVisible,
                        onChanged: _controller.onPasswordChanged,
                        validator: _controller.validatePassword,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: AppFonts.primaryFont,
                        ),
                        decoration: InputDecoration(
                          hintText: r'password'.tr,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 17.h,
                            horizontal: AppDimensions.paddingLarge.w,
                          ),
                          suffixIconConstraints: BoxConstraints(
                            minHeight: 20.h,
                            minWidth: 20.w,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: _controller.togglePasswordVisibility,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingExtraLarge.w,
                              ),
                              child: _controller.isPasswordVisible
                                  ? SvgPicture.asset(
                                      AppAssets.eyeIcon,
                                      color: AppColors.grey,
                                      width: 24.w,
                                      height: 24.h,
                                    )
                                  : SvgPicture.asset(
                                      AppAssets.eyeSlashIcon,
                                      color: AppColors.grey,
                                      width: 24.w,
                                      height: 24.h,
                                    ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppDimensions.paddingMedium.h),

                      /// Кнопка "Подтвердить"
                      Opacity(
                        opacity: _controller.isPasswordValid ? 1.0 : 0.5,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButtonWithState(
                            isLoading: _controller.status == Status.loading,
                            isError: _controller.status == Status.error,
                            onPressed: _controller.isPasswordValid
                                ? _controller.confirmPassword
                                : null,
                            child: Text(r'confirm'.tr),
                          ),
                        ),
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
