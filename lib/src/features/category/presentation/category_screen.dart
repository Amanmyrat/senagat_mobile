import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/map_search/presentation/map_search_screen.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/header_widget.dart';
import '../controller/category_controller.dart';

class CategoryScreen extends StatefulWidget {
  static const route = '/category';

  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: GetBuilder<CategoryController>(
              init: CategoryController(),
              builder: (controller) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w, vertical: AppDimensions.paddingMedium.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderWidget(),
                        Text(r'payments'.tr, style: TextStyle(color: AppColors.blackText, fontSize: 17.sp),),
                        SizedBox(height: 16.h),
                        GridView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.paymentsTitle.length,
                          itemBuilder: (context, index) {

                            final isSelected = controller.lastTap == CategoryTapType.fastOperation &&
                                controller.lastFastServiceTapIndex == index;

                            return GestureDetector(
                              onTap: () {
                                controller.onFastServiceTap(index);
                              },
                              child: Container(
                                width: 190.w,
                                height: 70.h,
                                padding: EdgeInsets.all(
                                  AppDimensions.paddingMedium.h,
                                ),
                                margin: EdgeInsets.only(
                                  right: AppDimensions.marginMedium.w,
                                ),
                                decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusMedium.r,
                                  ),
                                  border: Border.all(color: AppColors.dividerColor, width: 1.w, style: BorderStyle.solid),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.dividerColor,
                                      blurRadius: 4.r,
                                    ),
                                  ],
                                  color: isSelected ? AppColors.green : AppColors.white,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      padding: EdgeInsets.all(AppDimensions.paddingMedium.w),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.dividerColor, width: 1.w),
                                          shape: BoxShape.circle,
                                          color: isSelected ? AppColors.white : AppColors.green
                                      ),
                                      child: SvgPicture.asset(
                                        controller.paymentsIcons[index],
                                        color: isSelected ? AppColors.green : AppColors.white, width: 30.w,),
                                    ),
                                    SizedBox(width: AppDimensions.paddingMedium.w,),
                                    Expanded(
                                      child: Text(
                                        controller.paymentsTitle[index].tr,
                                        style: TextStyle(
                                          color: isSelected ? AppColors.white : AppColors.blackText,
                                          fontSize: 14.sp,
                                          fontFamily: AppFonts.secondaryFont,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3, mainAxisSpacing: 10),
                        ),
                        SizedBox(height: AppDimensions.padding40,),
                        Text(r'services'.tr, style: TextStyle(color: AppColors.blackText, fontSize: 17.sp),),
                        SizedBox(height: 16.h),
                        GridView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.serviceTitle.length,
                          itemBuilder: (context, index) {

                            final isSelected = controller.lastTap == CategoryTapType.service &&
                                controller.lastServiceTapIndex == index;

                            return GestureDetector(
                              onTap: () {
                                controller.onServiceTap(index);
                              },
                              child: Container(
                                width: 190.w,
                                height: 70.h,
                                padding: EdgeInsets.all(
                                  AppDimensions.paddingMedium.h,
                                ),
                                margin: EdgeInsets.only(
                                  right: AppDimensions.marginMedium.w,
                                ),
                                decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusMedium.r,
                                  ),
                                  border: Border.all(color: AppColors.dividerColor, width: 1.w, style: BorderStyle.solid),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.dividerColor,
                                      blurRadius: 4.r,
                                    ),
                                  ],
                                  color: isSelected ? AppColors.green : AppColors.white,
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      controller.serviceIcons[index], width: 50.w,),
                                    SizedBox(width: AppDimensions.paddingMedium.w,),
                                    Expanded(
                                      child: Text(
                                        controller.serviceTitle[index].tr,
                                        style: TextStyle(
                                          color: isSelected ? AppColors.white : AppColors.blackText,
                                          fontSize: 14.sp,
                                          fontFamily: AppFonts.secondaryFont,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3, mainAxisSpacing: 10),
                        ),

                      ],
                    ),
                  ),
                ],
              )

          ),
        ),
      ),
    );
  }
}
