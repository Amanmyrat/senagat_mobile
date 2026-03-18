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
    return WillPopScope(
      onWillPop: () async{
        final controller = Get.find<ServiceSettingsController>();

        if (controller.hasChanges) {
          controller.onClose();
          Get.delete<ServiceSettingsController>(force: true);
        }

        return true; // allow back
      },
      child: Scaffold(
        body: SafeArea(
          child: GetBuilder<ServiceSettingsController>(
            init: ServiceSettingsController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top bar
                  CustomAppBar(
                    actionWidget: GestureDetector(
                      onTap: controller.hasChanges ? controller.saveData : null,
                      child: Container(
                        padding: EdgeInsets.all(AppDimensions.paddingMedium),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: controller.hasChanges
                                ? AppColors.green
                                : AppColors.greyInactive,
                            width: 1.w,
                          ),
                          color: controller.hasChanges
                              ? AppColors.green
                              : Colors.transparent,
                        ),
                        child: SvgPicture.asset(
                          AppAssets.checkIcon,
                          width: 20.w,
                          color: controller.hasChanges
                              ? AppColors.white
                              : AppColors.greyInactive,
                        ),
                      ),
                    ),
                  ),


                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingExtraLarge.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Title
                            Text(
                              r'payments'.tr,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: AppColors.blackText,
                              ),
                            ),

                            SizedBox(
                                height:
                                controller.selected.isNotEmpty ? 40.h : 0),

                            /// Selected count
                            if (controller.selected.isNotEmpty)
                              Text(
                                '${r"selected".tr} ${controller.selected.length} / 4',
                                style: TextStyle(
                                    fontSize: 14.sp, color: AppColors.grey),
                              ),

                            SizedBox(height: 6.h),

                            /// SELECTED LIST
                            ReorderableListView.builder(
                              itemCount: controller.selected.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              onReorder: controller.changeItemPositions,
                              itemBuilder: (context, index) {
                                final item = controller.selected[index];

                                return GestureDetector(
                                  key: ValueKey(item.title),
                                  onTap: () => controller.removeSelectedService(item),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppDimensions.paddingMedium.h),
                                    color: AppColors.white,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.minusCircleIcon,
                                          color: AppColors.redDark,
                                        ),
                                        SizedBox(width: AppDimensions.paddingMedium.w),

                                        /// Icon
                                        Container(
                                          width: 50.w,
                                          height: 50.h,
                                          padding: EdgeInsets.all(
                                              AppDimensions.paddingSmall.w),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.dividerColor,
                                                width: 1.w),
                                            shape: BoxShape.circle,
                                            color: AppColors.white,
                                          ),
                                          child: Image.asset(item.icon,
                                              width: 30.w),
                                        ),

                                        SizedBox(width: AppDimensions.paddingMedium.w),

                                        /// Title
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    AppDimensions.paddingMedium.w),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        item.title.tr,
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .blackText,
                                                            fontSize: 14.sp),
                                                      ),
                                                    ),
                                                    SvgPicture.asset(
                                                      AppAssets.listIcon,
                                                      color:
                                                      AppColors.greyInactive,
                                                      width: 18.w,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                  height: 1,
                                                  color: AppColors.dividerColor),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: AppDimensions.padding40.h),

                            /// ALL
                            Text(
                              r'all'.tr,
                              style: TextStyle(
                                  fontSize: 14.sp, color: AppColors.grey),
                            ),

                            SizedBox(height: 16.h),

                            /// SERVICES LIST
                            ListView.builder(
                              itemCount: controller.services.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = controller.services[index];

                                return GestureDetector(
                                  onTap: () => controller.addSelectedService(item),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        bottom: AppDimensions.paddingExtraLarge.h),
                                    color: AppColors.white,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.plusCircleIcon,
                                          color: AppColors.green,
                                        ),

                                        SizedBox(
                                            width: AppDimensions.paddingMedium.w),

                                        /// Icon
                                        Container(
                                          width: 50.w,
                                          height: 50.h,
                                          padding: EdgeInsets.all(
                                              AppDimensions.paddingSmall.w),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.dividerColor,
                                                width: 1.w),
                                            shape: BoxShape.circle,
                                            color: AppColors.white,
                                          ),
                                          child: Image.asset(item.icon,
                                              width: 30.w),
                                        ),

                                        SizedBox(
                                            width: AppDimensions.paddingMedium.w),

                                        /// Title
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    AppDimensions.paddingMedium.w),
                                                child: Text(
                                                  item.title.tr,
                                                  style: TextStyle(
                                                    color: AppColors.blackText,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ),
                                              const Divider(
                                                  height: 1,
                                                  color: AppColors.dividerColor),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
