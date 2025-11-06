import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/identity_verification/controller/identity_verification_controller.dart';
import 'package:senagat_mobile/src/features/identity_verification/repository/profile_repository.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/globals.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';

class IdentityVerificationScreen extends StatefulWidget {
  static const route = '/identity/verification';

  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<IdentityVerificationController>(
          init: IdentityVerificationController(
            ProfileRepository(apiService: ApiServices.apiService),
            _key,
          ),
          builder: (controller) {
            return Column(
              children: [
                CustomAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingExtraLarge.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r'identity_verification'.tr,
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: AppColors.blackText,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          ListView.builder(
                            itemCount: controller.controllers.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (controller.controllers[index] ==
                                  controller.passportNumberController) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 22.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.textFieldTitle[index].tr,
                                        style: TextStyle(
                                          color: AppColors.blackText,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: AppDimensions.paddingMedium.h,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 72.w,
                                            height: 62.h,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType: TextInputType.text,
                                              maxLength: 2,
                                              controller:
                                                  controller.asController,
                                              onChanged: (v) => controller
                                                  .onTextIsNotEmpty(v),
                                              style: TextStyle(fontSize: 14.sp),
                                              decoration: InputDecoration(
                                                hintText: 'AS',
                                                border:
                                                    const OutlineInputBorder(),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppDimensions
                                                            .borderRadiusMedium,
                                                      ),
                                                  borderSide: BorderSide(
                                                    color: AppColors.green,
                                                    width: 1.w,
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppDimensions
                                                            .borderRadiusMedium,
                                                      ),
                                                  borderSide: BorderSide(
                                                    color: AppColors.white,
                                                    width: 1.w,
                                                  ),
                                                ),
                                                counter: const SizedBox(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      vertical: AppDimensions
                                                          .paddingExtraLarge
                                                          .h,
                                                      horizontal: AppDimensions
                                                          .paddingLarge
                                                          .w,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: TextFormField(
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 7,
                                              controller: controller
                                                  .passportNumberController,
                                              onChanged: (v) => controller
                                                  .onTextIsNotEmpty(v),
                                              style: TextStyle(fontSize: 14.sp),
                                              decoration: InputDecoration(
                                                hintText: 'passport_number'.tr,
                                                border:
                                                    const OutlineInputBorder(),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppDimensions
                                                            .borderRadiusMedium,
                                                      ),
                                                  borderSide: BorderSide(
                                                    color: AppColors.green,
                                                    width: 1.w,
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppDimensions
                                                            .borderRadiusMedium,
                                                      ),
                                                  borderSide: BorderSide(
                                                    color: AppColors.white,
                                                    width: 1.w,
                                                  ),
                                                ),
                                                counter: const SizedBox(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      vertical: AppDimensions
                                                          .paddingExtraLarge
                                                          .h,
                                                      horizontal: AppDimensions
                                                          .paddingLarge
                                                          .w,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                              if(controller.controllers[index] == controller.asController){
                                return SizedBox.shrink();
                              }
                              // Default text fields
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.textFieldTitle[index].tr,
                                    style: TextStyle(
                                      color: AppColors.blackText,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppDimensions.paddingMedium.h,
                                  ),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    keyboardType:
                                        (controller.controllers[index] ==
                                                controller
                                                    .dateOfBirthController ||
                                            controller.controllers[index] ==
                                                controller
                                                    .dateIssueController ||
                                            controller.controllers[index] ==
                                                controller.homePhoneController)
                                        ? TextInputType.number
                                        : TextInputType.name,
                                    controller: controller.controllers[index],
                                    inputFormatters:
                                        (controller.controllers[index] ==
                                                controller
                                                    .dateOfBirthController ||
                                            controller.controllers[index] ==
                                                controller.dateIssueController)
                                        ? [controller.dateFormatter]
                                        : [],
                                    onChanged: (v) =>
                                        controller.onTextIsNotEmpty(v),
                                    style: TextStyle(fontSize: 14.sp),
                                    decoration: InputDecoration(
                                      hintText:
                                          controller.textFieldTitle[index].tr,
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.borderRadiusMedium,
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.green,
                                          width: 1.w,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.borderRadiusMedium,
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.white,
                                          width: 1.w,
                                        ),
                                      ),
                                      counter: const SizedBox(),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical:
                                            AppDimensions.paddingExtraLarge.h,
                                        horizontal:
                                            AppDimensions.paddingLarge.w,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 22.h),
                                ],
                              );
                            },
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r'passport_scan'.tr,
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: AppDimensions.paddingMedium.h),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButtonWithState(
                                  customStyle: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.white,
                                    side: BorderSide(
                                      color: AppColors.dividerColor,
                                    ),
                                    shadowColor: Colors.transparent,
                                  ),
                                  isLoading: false,
                                  isError: false,
                                  onPressed: () {
                                    controller.pickPdf();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (controller.pdfFile == null) ...[
                                        Text(
                                          r'passport_scan'.tr,
                                          style: TextStyle(
                                            color: AppColors.greyInactive,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ] else ...[
                                        Text(
                                          r'scan_sent'.tr,
                                          style: TextStyle(
                                            color: AppColors.blackText,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                      SizedBox(
                                        width: AppDimensions.paddingMedium.w,
                                      ),
                                      SvgPicture.asset(
                                        controller.pdfFile == null
                                            ? AppAssets.pdfIcon
                                            : AppAssets.checkIcon,
                                        width: 18.w,
                                        color: controller.pdfFile == null
                                            ? AppColors.grey
                                            : AppColors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                  child: Opacity(
                    opacity: controller.continueEnabled ? 1.0 : 0.5,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButtonWithState(
                        isLoading: controller.status == Status.loading,
                        isError: controller.status == Status.error,
                        onPressed: () {
                          if(controller.continueEnabled) {
                            controller.startBankVerification();
                          }
                        },
                        child: Text(
                          r'submit_for_review'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
