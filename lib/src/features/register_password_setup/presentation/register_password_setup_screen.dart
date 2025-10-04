import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/globals.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../auth/repository/auth_repository.dart';
import '../controller/register_password_setup_controller.dart';

class RegisterPasswordSetupScreen extends StatefulWidget {
  static const route = r'/register/password/setup';

  const RegisterPasswordSetupScreen({super.key});

  @override
  State<RegisterPasswordSetupScreen> createState() => _RegisterPasswordSetupScreenState();
}

class _RegisterPasswordSetupScreenState extends State<RegisterPasswordSetupScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<RegisterPasswordSetupController>(
          init: RegisterPasswordSetupController(
            AuthRepository(apiService: ApiServices.apiService),
          ),
          builder: (controller) => Form(
            key: controller.key,
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
                            r'step_3_of_3'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.blackText,
                            ),
                          ),
                          SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child:
                            CircularProgressIndicator(
                              color: AppColors.green,
                              value: 0.75,
                              backgroundColor: AppColors.dividerColor,
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
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
                          fontSize: 14.sp,
                          color: AppColors.greyInactive,
                          fontFamily: AppFonts.secondaryFont,
                        ),
                      ),
                      SizedBox(height: AppDimensions.padding60.h),

                      TextFormField(
                        controller: controller.passwordController,
                        focusNode: controller.passwordFocus,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !controller.isPasswordVisible,
                        onChanged: controller.onPasswordChanged,
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
                            onTap: controller.togglePasswordVisibility,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingExtraLarge.w,
                              ),
                              child: controller.isPasswordVisible
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

                      Opacity(
                        opacity: controller.isPasswordValid ? 1.0 : 0.5,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButtonWithState(
                            isLoading: controller.status == Status.loading,
                            isError: controller.status == Status.error,
                            onPressed: controller.isPasswordValid
                                ? controller.confirmPassword
                                : null,
                            child: Text(r'confirm'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.white),),
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
