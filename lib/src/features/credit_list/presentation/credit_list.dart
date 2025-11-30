import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/auth/repository/auth_repository.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../controller/credit_list_controller.dart';

class CreditList extends StatefulWidget {
  static const route = '/credit/list';

  const CreditList({super.key});

  @override
  State<CreditList> createState() => _CreditListState();
}

class _CreditListState extends State<CreditList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<CreditListController>(
            init: CreditListController(AuthRepository(apiService: ApiServices.apiService)),
            builder: (controller) {
              return controller.status == Status.loading
                  ? Center(
                child: CircularProgressIndicator(color: AppColors.green),
              )
                  : Column(
                children: [
                  CustomAppBar(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r'credits'.tr,
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: AppColors.blackText,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller
                                  .userInformationModel
                                  ?.loan
                                  ?.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final loan = controller.userInformationModel?.loan?[index];
                                return Padding(
                                  padding: EdgeInsetsGeometry.only(bottom: AppDimensions.padding40.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.borderRadiusMedium.r,
                                          ),
                                          border: Border.all(
                                            color: AppColors.dividerColor,
                                            width: 1.w,
                                            style: BorderStyle.solid,
                                          ),
                                          boxShadow: [
                                            BoxShadow(color: AppColors.dividerColor, blurRadius: 4.r),
                                          ],
                                          color: AppColors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                AppDimensions.paddingMedium.w,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                  AppDimensions.borderRadiusMedium.r,
                                                ),
                                                color: controller.checkCreditStatus(index),
                                              ),
                                              child: Text(
                                                loan?.status?.tr ?? '',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors.white,
                                                  fontFamily: AppFonts.secondaryFont,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.h,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  loan?.creditName?.tr ?? '',
                                                  style: TextStyle(color: AppColors.black, fontSize: 14.sp),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      r'01 Августа, 10:15'.tr,
                                                      style: TextStyle(
                                                        color: AppColors.grey,
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                    SizedBox(width: 6.w),
                                                    SvgPicture.asset(
                                                      AppAssets.arrowRightIcon,
                                                      width: 14.w,
                                                      color: AppColors.grey,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: AppDimensions.paddingExtraLarge.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        r'sum'.tr,
                                                        style: TextStyle(
                                                          color: AppColors.grey,
                                                          fontSize: 14.sp,
                                                          fontFamily: AppFonts.secondaryFont,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      Text(
                                                        loan?.amount.toString() ??
                                                        '',
                                                        style: TextStyle(
                                                          color: AppColors.black,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Container(
                                                  width: 1.w,
                                                  height: 44.h,
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal: AppDimensions.paddingExtraLarge.w,
                                                  ),
                                                  color: AppColors.dividerColor,
                                                ),

                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        r'monthly_payment2'.tr,
                                                        style: TextStyle(
                                                          color: AppColors.grey,
                                                          fontSize: 14.sp,
                                                          fontFamily: AppFonts.secondaryFont,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      Text(
                                                        loan?.monthlyPayment.toString() ??
                                                        '',
                                                        style: TextStyle(
                                                          color: AppColors.black,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ],
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
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}
