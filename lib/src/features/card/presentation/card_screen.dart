import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/add_card/presentation/add_card_screen.dart';
import 'package:senagat_mobile/src/features/auth/repository/auth_repository.dart';
import 'package:senagat_mobile/src/features/card/controller/card_controller.dart';
import 'package:senagat_mobile/src/features/card_expenses/presentation/card_expenses_screen.dart';
import 'package:senagat_mobile/src/features/card_settings/presentation/card_settings_screen.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/header_widget.dart';
import '../../../core/states/stateful_data.dart';
import '../../../widgets/elevated_button_with_state.dart';

class CardScreen extends StatefulWidget {
  static const route = '/card';

  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<CardController>(
          init: CardController(AuthRepository(apiService: ApiServices.apiService)),
          builder: (controller) => controller.status == Status.loading
              ? Center(child: CircularProgressIndicator(color: AppColors.green))
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingExtraLarge.w,
                      vertical: AppDimensions.paddingMedium,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderWidget(),

                        GestureDetector(
                          onTap: () {
                            Get.toNamed(CardExpensesScreen.route);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                              color: AppColors.black,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '200,00 ${r'manat'.tr}',
                                      style: TextStyle(fontSize: 24.sp, color: AppColors.white),
                                    ),
                                    Text(
                                      r'expenses_per_month'.tr,
                                      style: TextStyle(fontSize: 14.sp, color: AppColors.greyInactive),
                                    )
                                  ],
                                ),
                                SvgPicture.asset(AppAssets.diagram),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 40.h),

                        Text(r'cards'.tr,
                            style: TextStyle(fontSize: 17.sp, color: AppColors.black)),
                        SizedBox(height: 16.h),

                        controller.cardBox.length == 0
                            ? GestureDetector(
                            onTap: () {
                              Get.toNamed(AddCardScreen.route);
                            },
                            child: Container(
                              height: 220.h,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(bottom: 10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusMedium.r),
                                color: AppColors.inputFillBackground,
                              ),
                              child: Center(
                                child: SvgPicture.asset(AppAssets.plusIcon,
                                    width: 30.w, color: AppColors.black),
                              ),
                            ))
                            : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.cardBox.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(CardSettingsScreen.route,
                                    arguments: {'index': index});
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(AppDimensions.paddingExtraLarge),
                                margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      controller.cardBox.getAt(index)!.cardDesign,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        controller.cardBox.getAt(index)?.nickName ?? '',
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 72.h),
                                    Text(
                                      controller.hideCardCenter(controller.cardBox.getAt(index)?.cardNumber ?? ''),
                                      style: TextStyle(
                                        wordSpacing: 10.sp,
                                        fontSize: 24.sp,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    SizedBox(height: 41.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          controller.cardBox.getAt(index)?.name ?? '',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        Text(
                                          controller.cardBox.getAt(index)?.expiryDate ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 40.h),

                        if (controller.userInformationModel?.cards != null) ...[
                          Text(r'open_applications'.tr,
                              style: TextStyle(fontSize: 17.sp, color: AppColors.black)),
                          SizedBox(height: 16.h),

                          ListView.builder(
                            itemCount:
                            controller.userInformationModel?.cards?.length ?? 0,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final card =
                              controller.userInformationModel?.cards?[index];

                              return Padding(
                                padding: EdgeInsets.only(bottom: 40.h),
                                child: Container(
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputFillBackground,
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.borderRadiusMedium.r
                                    ),
                                    border: Border.all(
                                      color: AppColors.dividerColor,
                                      width: 1.w,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.dividerColor,
                                          blurRadius: 4.r
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              color: controller.checkCardStatus(index),
                                            ),
                                            child: Text(
                                              card?.status?.tr ?? '',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: AppColors.white,
                                                fontFamily: AppFonts.secondaryFont,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            card?.createdAt ?? '',
                                            style: TextStyle(
                                                color: AppColors.grey,
                                                fontSize: 14.sp),
                                          ),
                                        ],
                                      ),

                                        SizedBox(height: 20.h),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(r'card'.tr,
                                                      style: TextStyle(
                                                          color: AppColors.grey,
                                                          fontSize: 14.sp)),
                                                  SizedBox(height: 4.h),
                                                  Text(card?.cardTitle ?? "",
                                                      style: TextStyle(
                                                          color: AppColors.black,
                                                          fontSize: 14.sp)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 1.w,
                                              height: 44.h,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20.w),
                                              color: AppColors.dividerColor,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(r'payment_amount'.tr,
                                                      style: TextStyle(
                                                          color: AppColors.grey,
                                                          fontSize: 14.sp)),
                                                  SizedBox(height: 4.h),
                                                  Text(card?.cardPrice.toString() ?? '',
                                                      style: TextStyle(
                                                          color: AppColors.black,
                                                          fontSize: 14.sp)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 20.h),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(r'bank_branch'.tr,
                                                      style: TextStyle(
                                                          color: AppColors.grey,
                                                          fontSize: 14.sp)),
                                                  SizedBox(height: 4.h),
                                                  Text(card?.bankBranch ?? "",
                                                      style: TextStyle(
                                                          color: AppColors.black,
                                                          fontSize: 14.sp)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 1.w,
                                              height: 44.h,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20.w),
                                              color: AppColors.dividerColor,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(r'delivery'.tr,
                                                      style: TextStyle(
                                                          color: AppColors.grey,
                                                          fontSize: 14.sp)),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    (card?.delivery ?? false)
                                                        ? r'delivery_service_available'
                                                        .tr
                                                        : r'no_delivery_service'.tr,
                                                    style: TextStyle(
                                                        color:
                                                        AppColors.black,
                                                        fontSize: 14.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              if (controller.cardBox.length >= 1)
                Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingExtraLarge),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButtonWithState(
                      isLoading: false,
                      isError: false,
                      onPressed: () {
                        Get.toNamed(AddCardScreen.route);
                      },
                      child: Text(
                        r'add_a_card'.tr,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
