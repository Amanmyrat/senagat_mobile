import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/add_card/presentation/add_card_screen.dart';
import 'package:senagat_mobile/src/features/card_expenses/presentation/card_expenses_screen.dart';
import 'package:senagat_mobile/src/features/credit_list/presentation/credit_list.dart';
import 'package:senagat_mobile/src/features/inquiries_list/presentation/inquiries_list.dart';
import 'package:senagat_mobile/src/features/service_settings/presentation/service_settings_screen.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/states/stateful_data.dart';
import '../../../widgets/header_widget.dart';
import '../../auth/repository/auth_repository.dart';
import '../../card_settings/presentation/card_settings_screen.dart';
import '../../identity_verification/presentation/identity_verification_screen.dart';
import '../../pay/repository/payment_repository.dart';
import '../controller/home_controller.dart';
import '../repository/exchage_rate_repository.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return showBackDialog(context);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: GetBuilder<HomeController>(
              init: HomeController(
                ExchangeRateRepository(apiService: ApiServices.apiService),
                AuthRepository(apiService: ApiServices.apiService),
                PaymentRepository(apiService: ApiServices.apiService),
              ),
              builder: (controller) {
                return controller.status == Status.loading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.green,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingExtraLarge.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeaderWidget(),

                                if (controller.isProfileRequired == true) ...[
                                  profileIsRequiredWidget(controller),
                                ],
                              ],
                            ),
                          ),
                          cardsWidget(controller),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingExtraLarge.w,
                              vertical: AppDimensions.paddingMedium.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                fastOperationsWidget(controller),
                                charityFoundationWidget(controller),

                                if (controller
                                        .userInformationModel
                                        ?.certificates !=
                                    null) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        r'inquiries'.tr,
                                        style: TextStyle(
                                          color: AppColors.blackText,
                                          fontSize: 17.sp,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(InquiriesList.route);
                                        },
                                        child: Text(
                                          r'all'.tr,
                                          style: TextStyle(
                                            color: AppColors.green,
                                            fontFamily: AppFonts.secondaryFont,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  ListView.builder(
                                    itemCount: 1,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(InquiriesList.route);
                                        },
                                        child: inquiriesWidget(
                                          controller,
                                          index,
                                        ),
                                      );
                                    },
                                  ),
                                ] else ...[
                                  SizedBox.shrink(),
                                ],

                                if (controller.userInformationModel?.loan !=
                                    null) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        r'credits'.tr,
                                        style: TextStyle(
                                          color: AppColors.blackText,
                                          fontSize: 17.sp,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(CreditList.route);
                                        },
                                        child: Text(
                                          r'all'.tr,
                                          style: TextStyle(
                                            color: AppColors.green,
                                            fontFamily: AppFonts.secondaryFont,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),

                                  ListView.builder(
                                    itemCount: 1,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(CreditList.route);
                                        },
                                        child: creditsWidget(controller, index),
                                      );
                                    },
                                  ),
                                ] else ...[
                                  SizedBox.shrink(),
                                ],

                                Text(
                                  r'services'.tr,
                                  style: TextStyle(
                                    color: AppColors.blackText,
                                    fontSize: 17.sp,
                                  ),
                                ),

                                SizedBox(height: 16.h),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 232.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingExtraLarge,
                              ),
                              itemCount: controller.serviceTitles.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final isSelected =
                                    controller.lastTap == HomeTapType.service &&
                                    controller.lastServiceTapIndex == index;

                                return GestureDetector(
                                  onTap: () {
                                    controller.onServiceTap(index);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: AppDimensions.marginMedium,
                                    ),
                                    width: 290.w,
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
                                        BoxShadow(
                                          color: AppColors.dividerColor,
                                          blurRadius: 4.r,
                                        ),
                                      ],
                                      color: isSelected
                                          ? AppColors.green
                                          : AppColors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                  AppDimensions
                                                      .paddingExtraLarge
                                                      .w,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      controller
                                                          .serviceTitles[index]
                                                          .tr,
                                                      style: TextStyle(
                                                        color: isSelected
                                                            ? AppColors.white
                                                            : AppColors
                                                                  .blackText,
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Center(
                                                child:
                                                    controller
                                                        .serviceImage[index]
                                                        .endsWith('.svg')
                                                    ? SvgPicture.asset(
                                                        controller
                                                            .serviceImage[index],
                                                        width: 150.w,
                                                        height: 150.h,
                                                      color: isSelected ? AppColors.white : null ,
                                                      )
                                                    : Image.asset(
                                                        controller
                                                            .serviceImage[index],
                                                        width: 200.w,
                                                        height: 180.h,
                                                      ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 20,
                                                  right: 20,
                                                ),
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: SvgPicture.asset(
                                                    AppAssets.arrowRightIcon,
                                                    color: isSelected
                                                        ? AppColors.white
                                                        : AppColors.black,
                                                    width: 14.w,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingExtraLarge.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (controller.history.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            r'history'.tr,
                                            style: TextStyle(
                                              color: AppColors.blackText,
                                              fontSize: 17.sp,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                CardExpensesScreen.route,
                                              );
                                            },
                                            child: Text(
                                              r'view_all'.tr,
                                              style: TextStyle(
                                                color: AppColors.green,
                                                fontSize: 14.sp,
                                                fontFamily:
                                                    AppFonts.secondaryFont,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6.h),

                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: controller.history.length > 3
                                            ? 3
                                            : controller.history.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: MediaQuery.of(
                                              context,
                                            ).size.width,
                                            padding: EdgeInsets.all(
                                              AppDimensions.paddingExtraLarge.w,
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              vertical: 5.h,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppDimensions
                                                        .borderRadiusMedium
                                                        .r,
                                                  ),
                                              border: Border.all(
                                                color: AppColors.dividerColor,
                                                width: 1.w,
                                                style: BorderStyle.solid,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.dividerColor,
                                                  blurRadius: 4.r,
                                                ),
                                              ],
                                              color: AppColors.white,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal:
                                                                AppDimensions
                                                                    .paddingMedium
                                                                    .w,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              AppDimensions
                                                                  .borderRadiusMedium
                                                                  .r,
                                                            ),
                                                        color: controller
                                                            .checkPaymentsStatus(
                                                              index,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        controller
                                                            .history[index]
                                                            .status
                                                            .tr,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              AppColors.white,
                                                          fontFamily: AppFonts
                                                              .secondaryFont,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      controller
                                                          .history[index]
                                                          .createdAt,
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.blackText,
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: AppDimensions
                                                      .paddingMedium
                                                      .h,
                                                ),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      controller.iconByType(
                                                        controller
                                                            .history[index]
                                                            .type,
                                                      ),
                                                      width: 50.w,
                                                    ),

                                                    SizedBox(
                                                      width: AppDimensions
                                                          .paddingMedium
                                                          .w,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            controller
                                                                .history[index]
                                                                .type
                                                                .tr,
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .blackText,
                                                              fontSize: 14.sp,
                                                            ),
                                                          ),
                                                          Text(
                                                            controller
                                                                .history[index]
                                                                .paymentTarget
                                                                .value,
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .blackText,
                                                              fontSize: 14.sp,
                                                              fontFamily: AppFonts
                                                                  .secondaryFont,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      '-${controller.history[index].amount}',
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.blackText,
                                                        fontSize: 17.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                SizedBox(height: AppDimensions.padding40.h),

                                if (controller.exchange.isNotEmpty) ...[
                                  Text(
                                    r'exchange_rates'.tr,
                                    style: TextStyle(
                                      color: AppColors.blackText,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),

                                  Container(
                                    padding: EdgeInsets.all(
                                      AppDimensions.paddingExtraLarge.w,
                                    ),
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
                                        BoxShadow(
                                          color: AppColors.dividerColor,
                                          blurRadius: 4.r,
                                        ),
                                      ],
                                      color: AppColors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                r'currency'.tr,
                                                style: TextStyle(
                                                  color: AppColors.blackText,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  r'purchase'.tr,
                                                  style: TextStyle(
                                                    color: AppColors.blackText,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: AppDimensions
                                                      .paddingExtraLarge
                                                      .w,
                                                ),
                                                Text(
                                                  r'sale'.tr,
                                                  style: TextStyle(
                                                    color: AppColors.blackText,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: controller.exchange.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                top: AppDimensions
                                                    .paddingExtraLarge
                                                    .h,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.network(
                                                        controller
                                                                .exchange[index]
                                                                .flag ??
                                                            '',
                                                        width: 28.w,
                                                        height: 20.h,
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      Text(
                                                        controller
                                                                .exchange[index]
                                                                .currency ??
                                                            '',
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .blackText,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: AppDimensions
                                                            .padding60
                                                            .w,
                                                        child: Text(
                                                          textAlign:
                                                              TextAlign.end,
                                                          controller
                                                                  .exchange[index]
                                                                  .purchase ??
                                                              '',
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .blackText,
                                                            fontSize: 14.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: AppDimensions
                                                            .paddingSuperExtraLarge
                                                            .w,
                                                      ),
                                                      SizedBox(
                                                        width: AppDimensions
                                                            .padding60
                                                            .w,
                                                        child: Text(
                                                          textAlign:
                                                              TextAlign.end,
                                                          controller
                                                                  .exchange[index]
                                                                  .sale ??
                                                              '',
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .blackText,
                                                            fontSize: 14.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget profileIsRequiredWidget(HomeController controller) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(IdentityVerificationScreen.route);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 22.h),
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
          color: AppColors.black,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(AppAssets.infoIcon, color: AppColors.greyInactive),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                r'most_functions'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.white,
                  fontFamily: AppFonts.secondaryFont,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardsWidget(HomeController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.padding40.h),
      child: Column(
        children: [
          if (controller.cardBox.isNotEmpty) ...[
            SizedBox(
              height: 240.h,
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.cardBox.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final item = controller.cardBox.getAt(index);
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        CardSettingsScreen.route,
                        arguments: {'index': index},
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(AppDimensions.paddingExtraLarge),
                      margin: EdgeInsets.symmetric(
                        horizontal: AppDimensions.marginExtraLarge,
                      ),
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
                              item?.nickName ?? '',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 72.h),
                          Text(
                            controller.hideCardCenter(
                              item?.cardNumber ?? '',
                            ),
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
                                item?.name ?? '',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                item?.expiryDate ??
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
            ),
            if (controller.cardBox.length > 1) ...[
              SizedBox(height: AppDimensions.paddingMedium.h),
              Center(
                child: SmoothPageIndicator(
                  count: controller.cardBox.length,
                  controller: controller.pageController,
                  effect: WormEffect(
                    dotHeight: 10.h,
                    dotWidth: 10.w,
                    spacing: 4,
                    activeDotColor: AppColors.green,
                    dotColor: AppColors.green.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ] else ...[
            Padding(
              padding: EdgeInsets.only(left: AppDimensions.paddingExtraLarge.w),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AddCardScreen.route);
                },
                child: Container(
                  width: 390.w,
                  height: 220.h,
                  decoration: BoxDecoration(
                    color: AppColors.inputFillBackground,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium.r,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppAssets.plusIcon, width: 32.w),

                      SizedBox(height: AppDimensions.paddingMedium),

                      Text(
                        r'add_a_card'.tr,
                        style: TextStyle(
                          color: AppColors.blackText,
                          fontSize: 17.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget fastOperationsWidget(HomeController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  r'fast_operations'.tr,
                  style: TextStyle(color: AppColors.blackText, fontSize: 17.sp),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(ServiceSettingsScreen.route);
                  },
                  child: Text(
                    r'tune'.tr,
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 14.sp,
                      fontFamily: AppFonts.secondaryFont,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.getFastOperationsCount(),
              itemBuilder: (context, index) {
                final fastCtrl = controller.fastServiceController;
                final selected = fastCtrl.selected;

                /// ADD BUTTON — appears only when selected.length < 4
                if (selected.length <= 4 && index == selected.length) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(ServiceSettingsScreen.route);
                    },
                    child: Container(
                      width: 90.w,
                      height: 78.h,
                      margin: EdgeInsets.only(
                        right: AppDimensions.marginMedium.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusMedium.r,
                        ),
                        border: Border.all(
                          color: AppColors.dividerColor,
                          width: 1.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.dividerColor,
                            blurRadius: 4.r,
                          ),
                        ],
                        color: AppColors.green,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.plusIcon,
                          width: 30.w,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  );
                }

                /// FAST SERVICE ITEM
                final item = selected[index];

                return GestureDetector(
                  onTap: () => controller.onFastServiceTap(index),
                  child: Container(
                    width: 90.w,
                    height: 78.h,
                    padding: EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingMedium.h,
                    ),
                    margin: EdgeInsets.only(
                      right: AppDimensions.marginMedium.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMedium.r,
                      ),
                      border: Border.all(
                        color: AppColors.dividerColor,
                        width: 1.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.dividerColor,
                          blurRadius: 4.r,
                        ),
                      ],
                      color: AppColors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.h,
                          padding: EdgeInsets.all(AppDimensions.paddingSmall.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.dividerColor,
                              width: 1.w,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(item.icon, width: 70.w),
                        ),
                        Text(
                          item.title.tr,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.blackText,
                            fontSize: 14.sp,
                            fontFamily: AppFonts.secondaryFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget charityFoundationWidget(HomeController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 40.h),
      child: GestureDetector(
        onTap: () {
          controller.onFoundationTap();
        },
        child: Container(
          height: 158.h,
          padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
          width: MediaQuery.of(context).size.width,
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
            color: controller.lastTap == HomeTapType.foundation
                ? AppColors.green
                : AppColors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      r'charitable_foundation'.tr,
                      style: TextStyle(
                        color: controller.lastTap == HomeTapType.foundation
                            ? AppColors.white
                            : AppColors.blackText,
                        fontSize: 20.sp,
                      ),
                    ),

                    Row(
                      children: [
                        Text(
                          r'donate'.tr,
                          style: TextStyle(
                            color: controller.lastTap == HomeTapType.foundation
                                ? AppColors.white
                                : AppColors.green,
                            fontSize: 14.sp,
                          ),
                        ),
                        SvgPicture.asset(
                          AppAssets.arrowRightIcon,
                          color: controller.lastTap == HomeTapType.foundation
                              ? AppColors.white
                              : AppColors.green,
                          width: 14.w,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.h),
                child: Image.asset(AppAssets.foundation, width: 125.w),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inquiriesWidget(HomeController controller, int index) {
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
              color: AppColors.orange,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller
                                .userInformationModel
                                ?.certificates
                                ?.first
                                .certificateName ??
                            '',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          controller
                                  .userInformationModel
                                  ?.certificates
                                  ?.first
                                  .createdAt ??
                              '',
                          style: TextStyle(
                            color: AppColors.orangeLight,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        SvgPicture.asset(
                          AppAssets.arrowRightIcon,
                          width: 14.w,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget creditsWidget(HomeController controller, int index) {
    final loan = controller.userInformationModel?.loan?[0];
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
              color: AppColors.blue,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loan?.creditName ?? '',
                      style: TextStyle(color: AppColors.white, fontSize: 14.sp),
                    ),
                    Row(
                      children: [
                        Text(
                          controller
                                  .userInformationModel
                                  ?.loan
                                  ?.first
                                  .createdAt ??
                              '',
                          style: TextStyle(
                            color: AppColors.blueLight,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        SvgPicture.asset(
                          AppAssets.arrowRightIcon,
                          width: 14.w,
                          color: AppColors.white,
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
                              color: AppColors.white,
                              fontSize: 14.sp,
                              fontFamily: AppFonts.secondaryFont,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            loan?.amount.toString() ?? '',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 17.sp,
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
                      color: AppColors.white,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r'monthly_payment2'.tr,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14.sp,
                              fontFamily: AppFonts.secondaryFont,
                            ),
                            maxLines: 1,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            loan?.monthlyPayment.toString() ?? '',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 17.sp,
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
  }

  Future<bool> showBackDialog(BuildContext context) async {
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("exit_app?".tr),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text("no".tr),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            child: Text("yes".tr),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }
}
