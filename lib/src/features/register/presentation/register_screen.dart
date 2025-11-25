import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/globals.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/register_controller.dart';
import '../../auth/repository/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  static const route = r'/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();

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
              child: GetBuilder<RegisterController>(
                init: RegisterController(
                  AuthRepository(apiService: ApiServices.apiService),
                  _key,
                ),
                builder: (controller) {
                  return Form(
                    key: controller.key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.login == 'login'
                                  ? r'step_1_of_2'.tr
                                  : r'step_1_of_3'.tr,
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
                                value: 0.25,
                                backgroundColor: AppColors.lightGrey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimensions.padding40.h),
                        Text(
                          r'phone'.tr,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.blackText,
                          ),
                        ),
                        Text(
                          r'send_sms'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.greyInactive,
                            fontFamily: AppFonts.secondaryFont,
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
                                border: Border.all(
                                  color: controller.status == Status.error
                                      ? AppColors.redDark
                                      : AppColors.transparent,
                                  width: 1,
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
                                controller: controller.phoneController,
                                focusNode: controller.phoneFocus,
                                keyboardType: TextInputType.phone,
                                onChanged: controller.onPhoneTextChanged,
                                onTapOutside: (_) =>
                                    controller.phoneFocus.unfocus(),
                                maxLength: 8,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: AppFonts.primaryFont,
                                ),
                                decoration: InputDecoration(
                                  hintText: r'enter_number'.tr,

                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: controller.status == Status.error
                                          ? AppColors.redDark
                                          : AppColors.green,
                                      width: 1,
                                    ),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusMedium,
                                    ),
                                    borderSide: BorderSide(
                                      color: controller.status == Status.error
                                          ? AppColors.redDark
                                          : AppColors.green,
                                      width: 1,
                                    ),
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusMedium,
                                    ),
                                    borderSide: BorderSide(
                                      color: controller.status == Status.error
                                          ? AppColors.redDark
                                          : AppColors.transparent,
                                      width: 1,
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

                        SizedBox(height: AppDimensions.paddingMedium.h),

                        if (controller.login == 'login') ...[
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
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium,
                                ),
                                borderSide: BorderSide(
                                  color: controller.status == Status.error
                                      ? AppColors.redDark
                                      : AppColors.green,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium,
                                ),
                                borderSide: BorderSide(
                                  color: controller.status == Status.error
                                      ? AppColors.redDark
                                      : AppColors.transparent,
                                  width: 1,
                                ),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: controller.togglePasswordVisibility,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        AppDimensions.paddingExtraLarge.w,
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                controller.onForgetPasswordTap();
                              },
                              child: Text(
                                r'forget password'.tr,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.green,
                                  fontFamily: AppFonts.primaryFont,
                                ),
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: AppDimensions.paddingExtraLarge.h),
                        Opacity(
                          opacity: controller.login == 'login'
                              ? controller.continueEnabled &&
                                        controller.isPasswordValid
                                    ? 1.0
                                    : 0.5
                              : controller.continueEnabled
                              ? 1.0
                              : 0.5,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButtonWithState(
                              isLoading: controller.status == Status.loading,
                              isError: controller.status == Status.error,
                              onPressed: controller.login == 'login'
                                  ? controller.continueEnabled &&
                                            controller.isPasswordValid
                                        ? controller.onLoginTap
                                        : null
                                  : controller.continueEnabled
                                  ? controller.onRegisterTap
                                  : null,
                              child: Text(
                                r'send_code'.tr,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
