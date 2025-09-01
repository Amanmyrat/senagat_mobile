import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/map_search/presentation/map_search_screen.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
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
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onTap: () {
                                  Get.toNamed(MapSearchScreen.route);
                                },
                                readOnly: true,
                                keyboardType: TextInputType.text,
                                maxLength: 8,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: AppFonts.primaryFont,
                                ),
                                decoration: InputDecoration(
                                  hintText: r'find_an_ATM'.tr,
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusMedium,
                                    ),
                                    borderSide: BorderSide(
                                      color: AppColors.white,
                                      width: 1.w,
                                    ),
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 20.w,
                                    minHeight: 20.h,
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(left: AppDimensions.paddingExtraLarge.w, right: AppDimensions.paddingMedium.w),
                                    child: SvgPicture.asset(
                                      AppAssets.searchIcon,
                                      width: 20.w,
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
                                    vertical: 16.h,
                                    horizontal: AppDimensions.paddingLarge.w,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            GestureDetector(
                              onTap: (){
                                controller.onQrScanTap();
                              },
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusMedium.r,
                                  ),
                                  color: controller.lastTap == CategoryTapType.qr ? AppColors.green : AppColors.inputFillBackground,
                                ),
                                child: SvgPicture.asset(
                                  AppAssets.qrCodeIcon,
                                  width: 20.w,
                                  color: controller.lastTap == CategoryTapType.qr ? AppColors.white : AppColors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            GestureDetector(
                              onTap: () {
                                controller.onNotificationScanTap();
                              },
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusMedium.r,
                                  ),
                                  color: controller.lastTap == CategoryTapType.notification ? AppColors.green : AppColors.inputFillBackground,
                                ),
                                child: SvgPicture.asset(
                                  AppAssets.bellSimpleIcon,
                                  width: 20.w,
                                  color: controller.lastTap == CategoryTapType.notification ? AppColors.white : AppColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22.h),
                        Text(r'payments'.tr, style: TextStyle(color: AppColors.blackText, fontSize: 17.sp),),
                        SizedBox(height: 16.h),
                        GridView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.paymentsTitle.length,
                          itemBuilder: (context, index) {

                            final isSelected = controller.lastTap == CategoryTapType.service &&
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
                                        controller.paymentsTitle[index],
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
                                    Image.asset(
                                      controller.serviceIcons[index], width: 50.w,),
                                    SizedBox(width: AppDimensions.paddingMedium.w,),
                                    Expanded(
                                      child: Text(
                                        controller.serviceTitle[index],
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
