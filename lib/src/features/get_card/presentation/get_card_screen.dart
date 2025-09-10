import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/get_card/controller/get_card_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';

class GetCardScreen extends StatefulWidget {
  static const route ='/get/card';
  const GetCardScreen({super.key});

  @override
  State<GetCardScreen> createState() => _GetCardScreenState();
}

class _GetCardScreenState extends State<GetCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GetBuilder<GetCardController>(
            init: GetCardController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                          child: Text(r'select_a_card'.tr, style: TextStyle(color: AppColors.black, fontSize: 24.sp),),
                        ),
                        SizedBox(height: 16.h,),
                        Container(
                          height: 44.h,
                          // width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusMedium.r,
                            ),
                            color: AppColors.green,
                          ),
                          child: TabBar(
                            controller: controller.tabController,
                            dividerHeight: 0,
                            labelColor: AppColors.white,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            unselectedLabelColor: AppColors.white,
                            labelStyle: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont,),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium.r,
                                ),
                                color: AppColors.blackText
                            ),
                            tabs:controller.tabLabels
                                .map((label) => Tab(text: label.tr))
                                .toList(),
                          ),
                        ),
                        SizedBox(height: 22.h,),
                        Expanded(
                          child: TabBarView(
                              controller: controller.tabController,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 1,
                                        child: Image.asset(AppAssets.paymentCardImage, width: 343.w, height: 220.h,),
                                      ),
                                      SizedBox(height: 16.h,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppAssets.infoIcon, color: AppColors.green,),
                                          SizedBox(width: 6.w,),
                                          Flexible(
                                            child: Text(r'Replenishment_bank'.tr,
                                              style: TextStyle(fontSize: 14.sp, color: AppColors.black,),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16.h,),
                                      Container(
                                        padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
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
                                          color: AppColors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(r'Cash_withdrawal_fee'.tr,
                                                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey,),
                                                ),
                                                Text(r'1%'.tr,
                                                  style: TextStyle(fontSize: 14.sp, color: AppColors.blackText,),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: AppDimensions.paddingExtraLarge.h,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(r'Annual_interest_rate'.tr,
                                                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey,),
                                                ),
                                                Text(r'0.65%'.tr,
                                                  style: TextStyle(fontSize: 14.sp, color: AppColors.blackText,),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: AppDimensions.paddingExtraLarge.h,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(r'Daily_limit_of_non_cash_transactionsv'.tr,
                                                  style: TextStyle(fontSize: 14.sp, color: AppColors.grey,),
                                                ),
                                                Text(r'20000'.tr,
                                                  style: TextStyle(fontSize: 14.sp, color: AppColors.blackText,),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 1,
                                        child: Image.asset(AppAssets.paymentCardImage2, width: 343.w, height: 220.h,),
                                      ),
                                      SizedBox(height: 16.h,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppAssets.infoIcon, color: AppColors.green,),
                                          SizedBox(width: 6.w,),
                                          Flexible(
                                            child: Text(r'Replenishment_bank'.tr,
                                              style: TextStyle(fontSize: 14.sp, color: AppColors.black,),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 99.h,),
                                      Text(r'Deposit_card'.tr, style: TextStyle(fontSize: 24.w, color: AppColors.black),)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 1,
                                        child: Image.asset(AppAssets.paymentCardImage2, width: 343.w, height: 220.h,),
                                      ),
                                      SizedBox(height: 16.h,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppAssets.infoIcon, color: AppColors.green,),
                                          SizedBox(width: 6.w,),
                                          Flexible(
                                            child: Text(r'Replenishment_bank'.tr,
                                              style: TextStyle(fontSize: 14.sp, color: AppColors.black,),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 99.h,),
                                      Text(r'Deposit_card'.tr, style: TextStyle(fontSize: 24.w, color: AppColors.black),)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 1,
                                        child: Image.asset(AppAssets.paymentCardImage2, width: 343.w, height: 220.h,),
                                      ),
                                      SizedBox(height: 16.h,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(AppAssets.infoIcon, color: AppColors.green,),
                                          SizedBox(width: 6.w,),
                                          Flexible(
                                            child: Text(r'Replenishment_bank'.tr,
                                              style: TextStyle(fontSize: 14.sp, color: AppColors.black,),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 99.h,),
                                      Text(r'Deposit_card'.tr, style: TextStyle(fontSize: 24.w, color: AppColors.black),)
                                    ],
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButtonWithState(
                        isLoading: controller.status == Status.loading,
                        isError: controller.status == Status.error,
                        onPressed:() {
                          controller.onTap();
                        },
                        child: Text(r'Apply_for_a_card'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.white),),
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
