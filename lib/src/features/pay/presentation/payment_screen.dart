import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/check_widget.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../add_card/presentation/add_card_screen.dart';
import '../../card_settings/presentation/card_settings_screen.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class PaymentScreen extends StatefulWidget {
  static const route = r'/payment';

  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<PaymentController>(
          init: PaymentController(),
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomAppBar(),
                              if (controller.serviceName.isEmpty)
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: AppDimensions.paddingExtraLarge,
                                    top: 22.h,
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      'step_5_of_5'.tr,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingExtraLarge.w,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (controller.serviceName.isNotEmpty)
                                      Column(
                                        children: [
                                          Text(
                                            controller.serviceName.tr,
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              color: AppColors.blackText,
                                            ),
                                          ),
                                          SizedBox(
                                            height: AppDimensions.padding40.h,
                                          ),
                                        ],
                                      ),
                                    if (controller.serviceName.isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (controller.isFoundation ==
                                              false) ...[
                                            accountWidget(controller),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  r'phone_number'.tr,
                                                  style: TextStyle(
                                                    color: AppColors.blackText,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                  AppDimensions.paddingMedium.h,
                                                ),

                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                        AppDimensions
                                                            .paddingExtraLarge
                                                            .w,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .inputFillBackground,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                          AppDimensions
                                                              .borderRadiusMedium,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        '+993',
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: AppDimensions
                                                          .paddingSmall
                                                          .w,
                                                    ),
                                                    Expanded(
                                                      child: TextFormField(
                                                        keyboardType:
                                                        TextInputType.phone,
                                                        controller: controller
                                                            .phoneController,
                                                        onChanged: (v) => controller
                                                            .isTextNotEmpty(),
                                                        focusNode:
                                                        controller.phoneFocus,
                                                        maxLength: 8,
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontFamily:
                                                          AppFonts.primaryFont,
                                                        ),
                                                        decoration: InputDecoration(
                                                          hintText:
                                                          r'enter_number'.tr,
                                                          border:
                                                          OutlineInputBorder(),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                              AppDimensions
                                                                  .borderRadiusMedium,
                                                            ),
                                                            borderSide: BorderSide(
                                                              color: AppColors.green,
                                                              width: 1.w,
                                                            ),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                              AppDimensions
                                                                  .borderRadiusMedium,
                                                            ),
                                                            borderSide: BorderSide(
                                                              color: AppColors.white,
                                                              width: 1.w,
                                                            ),
                                                          ),
                                                          counter: const SizedBox(),
                                                          contentPadding:
                                                          EdgeInsets.symmetric(
                                                            vertical: AppDimensions
                                                                .paddingExtraLarge
                                                                .h,
                                                            horizontal:
                                                            AppDimensions
                                                                .paddingLarge
                                                                .w,
                                                          ),
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              Icons.contacts,
                                                              color: AppColors.green,
                                                            ),
                                                            onPressed: () async {
                                                              controller
                                                                  .contactPicker();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 22.h),
                                              ],
                                            ),
                                          ],

                                          if (controller.serviceName ==
                                              'pygg_video') ...[
                                            isPyggVideo(controller),
                                          ],
                                          if (controller.serviceName ==
                                              'pygg_decision') ...[
                                            isPyggDecision(controller),
                                          ],
                                          if (controller.isFoundation)...[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  r'name'.tr,
                                                  style: TextStyle(
                                                    color: AppColors.blackText,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: AppDimensions
                                                      .paddingMedium
                                                      .h,
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.name,
                                                  controller:
                                                      controller.nameController,
                                                  onChanged: (value) =>
                                                      controller
                                                          .isTextNotEmpty(),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily:
                                                        AppFonts.primaryFont,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: r'name'.tr,
                                                    border:
                                                        OutlineInputBorder(),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            AppDimensions
                                                                .borderRadiusMedium,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color: AppColors.green,
                                                        width: 1.w,
                                                      ),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            AppDimensions
                                                                .borderRadiusMedium,
                                                          ),
                                                      borderSide: BorderSide(
                                                        color: AppColors.white,
                                                        width: 1.w,
                                                      ),
                                                    ),
                                                    counter: const SizedBox(),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                          vertical: AppDimensions
                                                              .paddingExtraLarge
                                                              .h,
                                                          horizontal:
                                                              AppDimensions
                                                                  .paddingLarge
                                                                  .w,
                                                        ),
                                                  ),
                                                ),

                                                SizedBox(height: 22.h),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  r'last_name'.tr,
                                                  style: TextStyle(
                                                    color: AppColors.blackText,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: AppDimensions
                                                      .paddingMedium
                                                      .h,
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                  TextInputType.name,
                                                  controller:
                                                  controller.lastnameController,
                                                  onChanged: (value) =>
                                                      controller
                                                          .isTextNotEmpty(),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily:
                                                    AppFonts.primaryFont,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: r'last_name'.tr,
                                                    border:
                                                    OutlineInputBorder(),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                        AppDimensions
                                                            .borderRadiusMedium,
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: AppColors.green,
                                                        width: 1.w,
                                                      ),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                        AppDimensions
                                                            .borderRadiusMedium,
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: AppColors.white,
                                                        width: 1.w,
                                                      ),
                                                    ),
                                                    counter: const SizedBox(),
                                                    contentPadding:
                                                    EdgeInsets.symmetric(
                                                      vertical: AppDimensions
                                                          .paddingExtraLarge
                                                          .h,
                                                      horizontal:
                                                      AppDimensions
                                                          .paddingLarge
                                                          .w,
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(height: 22.h),
                                              ],
                                            ),

                                          ],
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                r'sum'.tr,
                                                style: TextStyle(
                                                  color: AppColors.blackText,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    controller.sumController,
                                                onChanged: (value) =>
                                                    controller.isTextNotEmpty(),
                                                style: TextStyle(
                                                  fontSize: 24.sp,
                                                  fontFamily:
                                                      AppFonts.primaryFont,
                                                  color: AppColors.blackText,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: r'enter_sum'.tr,
                                                  fillColor: AppColors.white,
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          strokeAlign: BorderSide
                                                              .strokeAlignOutside,
                                                          color:
                                                              AppColors.green,
                                                          width: 1.w,
                                                        ),
                                                      ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          strokeAlign: BorderSide
                                                              .strokeAlignOutside,
                                                          color: AppColors
                                                              .dividerColor,
                                                          width: 1.w,
                                                        ),
                                                      ),
                                                  counter: const SizedBox(),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        vertical: AppDimensions
                                                            .paddingLarge
                                                            .h,
                                                        horizontal:
                                                            AppDimensions
                                                                .paddingLarge
                                                                .w,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width:
                                                AppDimensions.paddingMedium.h,
                                          ),
                                        ],
                                      ),

                                    SizedBox(height: AppDimensions.padding40.h),
                                    Text(
                                      r'select_a_card'.tr,
                                      style: TextStyle(
                                        fontSize:
                                            controller.serviceName.isNotEmpty
                                            ? 14.sp
                                            : 24.sp,
                                        color: AppColors.blackText,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    if (controller.cardBox.isNotEmpty) ...[
                                      SizedBox(
                                        height: 109.h,
                                        child: PageView.builder(
                                          controller: controller.pageController,
                                          itemCount: controller.cardBox.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                        CardSettingsScreen
                                                            .route,
                                                        arguments: {
                                                          'index': index,
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      width: MediaQuery.of(
                                                        context,
                                                      ).size.width,
                                                      padding: EdgeInsets.all(
                                                        AppDimensions
                                                            .paddingExtraLarge,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.r,
                                                            ),
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                            controller.cardBox
                                                                .getAt(index)!
                                                                .cardDesign,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${controller.cardBox.getAt(index)?.name} ',
                                                                style: TextStyle(
                                                                  color: AppColors
                                                                      .white,
                                                                  fontSize: 14.sp,
                                                                ),
                                                              ),
                                                              SizedBox(width: 10.w,),
                                                              if(controller.cardBox.getAt(index)?.nickName != '')...[
                                                              Text(
                                                                '(${controller.cardBox.getAt(index)?.nickName})',
                                                                style: TextStyle(
                                                                  color: AppColors
                                                                      .white,
                                                                  fontSize: 14.sp,
                                                                ),
                                                              ),
                                                              ]
                                                            ],
                                                          ),

                                                          SizedBox(
                                                            height: 20.h,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              controller.hideCardCenter(
                                                                controller
                                                                        .cardBox
                                                                        .getAt(
                                                                          index,
                                                                        )
                                                                        ?.cardNumber ??
                                                                    '',
                                                              ),
                                                              style: TextStyle(
                                                                wordSpacing:
                                                                    10.sp,
                                                                fontSize: 17.sp,
                                                                color: AppColors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12.w),
                                                if (controller.cardBox.length ==
                                                    1)
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(
                                                        AddCardScreen.route,
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 109.h,
                                                      width: 90.w,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .inputFillBackground,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              AppDimensions
                                                                  .borderRadiusMedium
                                                                  .r,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          AppAssets.plusIcon,
                                                          width: 30.w,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      if (controller.cardBox.length > 1) ...[
                                        SizedBox(
                                          height: AppDimensions.paddingMedium.h,
                                        ),
                                        Center(
                                          child: SmoothPageIndicator(
                                            count: controller.cardBox.length,
                                            controller:
                                                controller.pageController,
                                            effect: WormEffect(
                                              dotHeight: 10.h,
                                              dotWidth: 10.w,
                                              spacing: 4,
                                              activeDotColor: AppColors.green,
                                              dotColor: AppColors.green
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ] else ...[
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(AddCardScreen.route);
                                        },
                                        child: Expanded(
                                          child: Container(
                                            height: 120.h,
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.inputFillBackground,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppDimensions
                                                        .borderRadiusMedium
                                                        .r,
                                                  ),
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                AppAssets.plusIcon,
                                                width: 32.w,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              AppDimensions.paddingExtraLarge.w,
                            ),
                            child: Opacity(
                              opacity: controller.serviceName.isNotEmpty
                                  ? controller.continueEnabled
                                        ? 1.0
                                        : 0.5
                                  : 1,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButtonWithState(
                                  isLoading:
                                      controller.status == Status.loading,
                                  isError: controller.status == Status.error,
                                  onPressed: () {
                                    if (controller.serviceName.isNotEmpty) {
                                      controller.continueEnabled == false
                                          ? null
                                          : controller.onPayTap();
                                    } else {
                                      controller.startBankVerification();
                                    }
                                  },
                                  child: Text(
                                    r'pay'.tr,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (controller.check == true)
                        CheckWidget(
                          isLoading: controller.status == Status.loading,
                          isTitle: false,
                          route: DashboardScreen.route,
                          buttonTitle: r'home_page'.tr,
                          successTitle: 'payment_was_successful',
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future bottomSheet(PaymentController controller) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: Get.context!,
    backgroundColor: AppColors.white,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        child: SizedBox(
          width: MediaQuery.of(Get.context!).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(color: AppColors.grey, width: 24.w, height: 2.h),
                SizedBox(height: 22.h),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'select_a_card'.tr,
                    style: TextStyle(fontSize: 17.sp, color: AppColors.black),
                  ),
                ),
                SizedBox(height: 22.h),

                ListView.builder(
                  itemCount: controller.cardBox.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        color: AppColors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              onChanged: (value) {},
                              value: true,
                              side: BorderSide(width: 1),
                            ),
                            SizedBox(width: AppDimensions.paddingSmall.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      controller.cardBox.getAt(index)?.name ??
                                          '',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                        fontFamily: AppFonts.primaryFont,
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppDimensions.paddingSmall.w,
                                    ),
                                    Text(
                                      '(${controller.cardBox.getAt(index)?.nickName})',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                        fontFamily: AppFonts.primaryFont,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  controller.hideCardCenter(
                                    controller.cardBox
                                            .getAt(index)
                                            ?.cardNumber ??
                                        '',
                                  ),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.black,
                                    fontFamily: AppFonts.secondaryFont,
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

                SizedBox(height: 22.h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButtonWithState(
                    isLoading: false,
                    isError: false,
                    onPressed: () {},
                    child: Text(
                      r'select'.tr,
                      style: TextStyle(color: AppColors.white, fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget accountWidget(PaymentController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        r'your_account'.tr,
        style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
      ),
      SizedBox(height: AppDimensions.paddingMedium.h),
      Container(
        width: MediaQuery.of(Get.context!).size.width,
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r'balance'.tr,
                    style: TextStyle(
                      color: AppColors.greyInactive,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    '40 ${r'manat'.tr}',
                    style: TextStyle(color: AppColors.green, fontSize: 17.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: AppDimensions.paddingExtraLarge.w),
    ],
  );
}

Widget isPyggVideo(PaymentController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'name'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'surname'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'fine_number'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'number_of_car'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'fine_date'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
      Text(
        'bank_commission'.tr,
        style: TextStyle(color: AppColors.blackText, fontSize: 17.sp),
      ),
      SizedBox(height: AppDimensions.padding40.h),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'penalty_fee'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'amount_fine_penalty'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
    ],
  );
}

Widget isPyggDecision(PaymentController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'name'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'surname'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'fine_number'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'fine_date'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
      Text(
        'bank_commission'.tr,
        style: TextStyle(color: AppColors.blackText, fontSize: 17.sp),
      ),
      SizedBox(height: AppDimensions.padding40.h),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'penalty_fee'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r'amount_fine_penalty'.tr,
            style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.nameController,
            onChanged: (value) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.green, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                borderSide: BorderSide(color: AppColors.white, width: 1.w),
              ),
              counter: const SizedBox(),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppDimensions.paddingExtraLarge.h,
                horizontal: AppDimensions.paddingLarge.w,
              ),
            ),
          ),
          SizedBox(height: 22.h),
        ],
      ),
    ],
  );
}
