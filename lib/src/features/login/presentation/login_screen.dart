import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
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
  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginController(GlobalKey<FormState>()));
  }

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
              child: GetBuilder<LoginController>(
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
                              r'step_3_of_3'.tr,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.blackText,
                              ),
                            ),
                            SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: controller.status == Status.loading
                                  ? CircularProgressIndicator(
                                      color: AppColors.green,
                                    )
                                  : SizedBox.shrink(),
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
                                maxLength: 8,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: AppFonts.primaryFont,
                                ),
                                validator: (_) => controller.validatePhone(),
                                decoration: InputDecoration(
                                  hintText: r'enter_number'.tr,
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusMedium,
                                    ),
                                    borderSide: BorderSide(
                                      color: AppColors.green,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusMedium,
                                    ),
                                    borderSide: BorderSide(
                                      color: AppColors.green,
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
                        Opacity(
                          opacity: controller.continueEnabled ? 1.0 : 0.5,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButtonWithState(
                              isLoading: controller.status == Status.loading,
                              isError: controller.status == Status.error,
                              onPressed: controller.continueEnabled
                                  ? controller.onLoginTap
                                  : null,
                              child: Text(r'send_code'.tr),
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
