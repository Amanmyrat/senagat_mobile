import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/fast_operation_settings/controller/fast_operation_settings_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';

class FastOperationSettingsScreen extends StatefulWidget {
  static const route = r'/fast/operation/settings';

  const FastOperationSettingsScreen({super.key});

  @override
  State<FastOperationSettingsScreen> createState() => _FastOperationSettingsScreenState();
}

class _FastOperationSettingsScreenState extends State<FastOperationSettingsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(actionWidget: GestureDetector(
              onTap: (){

              },
              child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.greyInactive,
                    width: 1.w,
                    style: BorderStyle.solid,
                  ),
                ),
                child: SvgPicture.asset(AppAssets.checkIcon, width: 20.w, color: AppColors.greyInactive,),
              ),
            ),),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingExtraLarge,
              ),
              child: GetBuilder<FastOperationSettingsController>(
                init: FastOperationSettingsController(),
                builder: (controller) {
                  return Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r'Кнопки быстрой навигации'.tr,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.blackText,
                          ),
                        ),
                        SizedBox(height: AppDimensions.padding40.h),


                        Text(r'Выбранно 4/4'.tr, style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.grey,
                        ),),
                        SizedBox(height: 16.h,),
                        ListView.builder(
                            itemCount: 4,
                            shrinkWrap: true,
                            itemBuilder: (context, index){
                              return Padding(
                                padding: EdgeInsets.only(bottom: AppDimensions.paddingExtraLarge.h),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppAssets.minusCircleIcon, color: AppColors.redDark,),

                                    SizedBox(width: AppDimensions.paddingMedium.w,),
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.dividerColor, width: 1),
                                          shape: BoxShape.circle,
                                          color: AppColors.white
                                      ),
                                      child: SvgPicture.asset(AppAssets.deviceMobileIcon, color: AppColors.green,width: 30,),
                                    ),
                                    SizedBox(width: AppDimensions.paddingMedium.w,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                            child: Row(
                                              children: [
                                                Expanded(child: Text(r'ГИБДД'.tr,style: TextStyle(color: AppColors.blackText,),)),
                                                SvgPicture.asset(AppAssets.listIcon, color: AppColors.greyInactive, width: 18.w,),
                                              ],
                                            ),
                                          ),
                                          Divider(color: AppColors.dividerColor, height: 1,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(height: AppDimensions.padding40.h,),
                        Text(r'Все'.tr, style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.grey,
                        ),),
                        SizedBox(height: 16.h,),
                        ListView.builder(
                          itemCount: 4,
                            shrinkWrap: true,
                            itemBuilder: (context, index){
                          return Padding(
                            padding: EdgeInsets.only(bottom: AppDimensions.paddingExtraLarge.h),
                            child: Row(
                              children: [
                                SvgPicture.asset(AppAssets.plusCircleIcon, color: AppColors.green,),
                                SizedBox(width: AppDimensions.paddingMedium.w,),
                                Container(
                                  width: 50.w,
                                  height: 50.h,
                                  padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.dividerColor, width: 1),
                                      shape: BoxShape.circle,
                                      color: AppColors.white
                                  ),
                                  child: SvgPicture.asset(AppAssets.deviceMobileIcon, color: AppColors.green,width: 30,),
                                ),
                                SizedBox(width: AppDimensions.paddingMedium.w,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                        child: Expanded(child: Text(r'ГИБДД'.tr,style: TextStyle(color: AppColors.blackText,),)),
                                      ),
                                      Divider(color: AppColors.dividerColor, height: 1,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
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
