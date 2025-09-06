import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/identity_verification/controller/identity_verification_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/check_widget.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class IdentityVerificationScreen extends StatefulWidget {
  static const route = '/identity/verification';
  const IdentityVerificationScreen({super.key,});

  @override
  State<IdentityVerificationScreen> createState() => _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState extends State<IdentityVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: GetBuilder<IdentityVerificationController>(
          init: IdentityVerificationController(),
          builder: (controller) {
            return Column(
              children: [
                CustomAppBar(),
                Expanded(
                  child: Stack(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r'Identity_verification'.tr,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: AppColors.blackText,
                                  ),
                                ),
                                SizedBox(height: 32.h,),
                                ListView.builder(
                                    itemCount: 4,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index){
                                      return  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(controller.textFieldTitle[index], style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                          SizedBox(height: AppDimensions.paddingMedium.h,),
                                          TextFormField(
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.name,
                                            controller: controller.controllers[index],
                                            onChanged:(v) => controller.onTextIsNotEmpty(v),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: controller.textFieldTitle[index],
                                              border: OutlineInputBorder(),
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
                                                vertical: AppDimensions.paddingExtraLarge.h,
                                                horizontal: AppDimensions.paddingLarge.w,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 22.h,),
                                        ],
                                      );
                                    }
                                ),
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
                                        'AS',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                    SizedBox(width: 4.sp,),
                                    Expanded(
                                      child: TextFormField(
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.name,
                                        controller: controller.passportNumberController,
                                        onChanged:(v) => controller.onTextIsNotEmpty(v),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: r'Passport_number',
                                          border: OutlineInputBorder(),
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
                                            vertical: AppDimensions.paddingExtraLarge.h,
                                            horizontal: AppDimensions.paddingLarge.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 22.h,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r'Passport_scan'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                    SizedBox(height: AppDimensions.paddingMedium.h,),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButtonWithState(
                                        customStyle: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.white,
                                            side: BorderSide(color: AppColors.dividerColor),
                                            shadowColor: Colors.transparent
                                        ),
                                        isLoading: false,
                                        isError: false,
                                        onPressed:() {

                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(r'Passport_scan'.tr,style: TextStyle(color: AppColors.greyInactive, fontSize: 14.sp),),
                                            SizedBox(width: AppDimensions.paddingMedium.w,),
                                            SvgPicture.asset(AppAssets.pdfIcon),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      if(controller.check)
                        CheckWidget(isLoading: controller.status == Status.loading, isTitle: true, title: r'Identity_verification'.tr,),
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
