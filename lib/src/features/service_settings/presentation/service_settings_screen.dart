import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../controller/service_settings_controller.dart';

class ServiceSettingsScreen extends StatefulWidget {
  static const route = r'/fast/operation/settings';

  const ServiceSettingsScreen({super.key});

  @override
  State<ServiceSettingsScreen> createState() => _ServiceSettingsScreenState();
}

class _ServiceSettingsScreenState extends State<ServiceSettingsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder(
            init: ServiceSettingsController(),
            builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(actionWidget: GestureDetector(
                  onTap: (){
                    controller.saveData();
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppDimensions.paddingMedium),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: controller.selectedServiceTitle.isEmpty ? AppColors.greyInactive : AppColors.green,
                        width: 1.w,
                        style: BorderStyle.solid,
                      ),
                      color: controller.selectedServiceTitle.isEmpty ? Colors.transparent : AppColors.green,
                    ),
                    child: SvgPicture.asset(AppAssets.checkIcon, width: 20.w, color: controller.selectedServiceTitle.isNotEmpty ? AppColors.white : AppColors.greyInactive,),
                  ),
                ),),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingExtraLarge,
                  ),
                  child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r'quick_navigation_buttons'.tr,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: AppColors.blackText,
                              ),
                            ),
                            SizedBox(height: controller.selectedServiceTitle.isNotEmpty ? AppDimensions.padding40.h : 0),

                            if(controller.selectedServiceTitle.isNotEmpty)
                              Text('${r'selected '.tr}${controller.selectedServiceTitle.length} ${'/'} 4', style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.grey,
                              ),),

                            SizedBox(height: 6.h,),
                            ReorderableListView.builder(
                                itemCount: controller.selectedServiceTitle.length,
                                shrinkWrap: true,

                                itemBuilder: (context, index){
                                  return GestureDetector(
                                    key: ValueKey(controller.selectedServiceTitle[index]),
                                    onTap: (){
                                      controller.removeSelectedService(controller.selectedServiceTitle[index], controller.selectedServiceIcons[index]);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium.h),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(AppAssets.minusCircleIcon, color: AppColors.redDark,),

                                          SizedBox(width: AppDimensions.paddingMedium.w,),
                                          Container(
                                            width: 50.w,
                                            height: 50.h,
                                            padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: AppColors.dividerColor, width: 1.w),
                                                shape: BoxShape.circle,
                                                color: AppColors.white
                                            ),
                                            child: SvgPicture.asset(controller.selectedServiceIcons[index], color: AppColors.green, width: 30.w,),
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
                                                      Expanded(child: Text(controller.selectedServiceTitle[index].tr,
                                                        style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),
                                                      ),),
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
                                    ),
                                  );
                                },
                              onReorder: (int oldIndex, int newIndex) {
                                  controller.changeItemPositions(oldIndex, newIndex);
                              },
                            ),
                            SizedBox(height: AppDimensions.padding40.h,),
                            Text(r'all'.tr, style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.grey,
                            ),),
                            SizedBox(height: 16.h,),
                            ListView.builder(
                              itemCount: controller.serviceTitle.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: (){
                                  controller.addSelectedService(controller.serviceTitle[index], controller.serviceIcons[index]);
                                },
                                child: Padding(
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
                                          border: Border.all(color: AppColors.dividerColor, width: 1.w),
                                            shape: BoxShape.circle,
                                            color: AppColors.white
                                        ),
                                        child: SvgPicture.asset(controller.serviceIcons[index], color: AppColors.green, width: 30.w,),
                                      ),
                                      SizedBox(width: AppDimensions.paddingMedium.w,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                              child: Text(controller.serviceTitle[index],
                                                style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
                                              ),
                                            ),
                                            Divider(color: AppColors.dividerColor, height: 1.h,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
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
