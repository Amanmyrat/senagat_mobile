import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/check_widget.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../add_card/model/card_model.dart';
import '../../add_card/presentation/add_card_screen.dart';
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
          init: PaymentController(PaymentRepository(apiService: ApiServices.apiService)),
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      controller.status == Status.loading
                          ? Center(
                        child: CircularProgressIndicator(color: AppColors.green),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
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
                                  Padding(
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
                                              if (controller.isFoundation == false) ...[
                                                if(controller.serviceName != r'Belet')...[
                                                  accountWidget(controller),
                                                ],
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      r'phone_number'.tr,
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
                                                            onChanged: (v) =>
                                                                controller
                                                                    .isTextNotEmpty(),
                                                            focusNode:
                                                                controller.phoneFocus,
                                                            maxLength: 8,
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                              fontFamily: AppFonts
                                                                  .primaryFont,
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
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: controller.status == Status.error ? AppColors.redDark : AppColors.green,
                                                                      width: 1.w,
                                                                    ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      AppDimensions
                                                                          .borderRadiusMedium,
                                                                    ),
                                                                borderSide:
                                                                BorderSide(
                                                                  color: controller.status == Status.error ? AppColors.redDark : AppColors.transparent,
                                                                  width: 1.w,
                                                                ),
                                                              ),
                                                              counter:
                                                                  const SizedBox(),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                    vertical:
                                                                        AppDimensions
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
                                                                  color:
                                                                      AppColors.green,
                                                                  size: 20.w,
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
                                              if (controller.isFoundation) ...[
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
                                                          controller.isTextNotEmpty(),
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontFamily:
                                                            AppFonts.primaryFont,
                                                      ),
                                                      decoration: InputDecoration(
                                                        hintText: r'name'.tr,
                                                        border: OutlineInputBorder(),
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
                                                      controller: controller
                                                          .lastnameController,
                                                      onChanged: (value) =>
                                                          controller.isTextNotEmpty(),
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontFamily:
                                                            AppFonts.primaryFont,
                                                      ),
                                                      decoration: InputDecoration(
                                                        hintText: r'last_name'.tr,
                                                        border: OutlineInputBorder(),
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
                                              if (controller.serviceName == 'Belet') ...[
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      r'top_up_the_balance'.tr,
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: AppColors.blackText,
                                                      ),
                                                    ),
                                                    SizedBox(height: 16.h),
                                                    GridView.builder(
                                                      itemCount: controller.beletBalances.length,
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing: 10,
                                                        mainAxisSpacing: 10,
                                                        childAspectRatio: 3.5,
                                                      ),
                                                      itemBuilder: (context, index) {
                                                        final item = controller.beletBalances[index];
                                                        final isSelected = controller.selectedBeletIndex == index;

                                                        return InkWell(
                                                          borderRadius: BorderRadius.circular(
                                                            AppDimensions.borderRadiusMedium.r,
                                                          ),
                                                          onTap: () {
                                                            controller.selectedBeletIndex = index;
                                                            controller.sumController.text = item.value.toString();
                                                            controller.isTextNotEmpty();
                                                            controller.update();
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: isSelected
                                                                  ? AppColors.green
                                                                  : AppColors.inputFillBackground,
                                                              borderRadius: BorderRadius.circular(
                                                                AppDimensions.borderRadiusMedium.r,
                                                              ),
                                                              border: Border.all(
                                                                color: isSelected
                                                                    ? AppColors.green
                                                                    : Colors.transparent,
                                                                width: 1.2,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                item.title ?? '',
                                                                style: TextStyle(
                                                                  fontSize: 14.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: isSelected
                                                                      ? Colors.white
                                                                      : AppColors.blackText,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },

                                                    ),
                                                  ],
                                                ),
                                              ],

                                              SizedBox(
                                                height: 22.h,
                                              ),
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
                                                    onChanged: (value) {
                                                      controller.selectedBeletIndex = null;
                                                      controller.isTextNotEmpty();
                                                      controller.update();
                                                    },
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
                                                              color: AppColors.green,
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
                                                            horizontal: AppDimensions
                                                                .paddingLarge
                                                                .w,
                                                          ),
                                                    ),
                                                  ),
                                                ],
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
                                        GestureDetector(
                                          onTap: () async {
                                            if(controller.cardBox.isNotEmpty) {
                                              final selected = await bottomSheet(
                                                controller,
                                              );
                                              if (selected != null) {
                                                setState(() {}); // refresh UI
                                              }
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(20.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: AppColors.inputFillBackground,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  controller.selectedCard == null
                                                      ? 'select_a_card'.tr
                                                      : '${controller.hideCardCenter(controller.selectedCard!.cardNumber)}  ${controller.selectedCard!.name}',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color:
                                                        controller.selectedCard ==
                                                            null
                                                        ? AppColors.grey
                                                        : AppColors.black,
                                                  ),
                                                ),
                                                SvgPicture.asset(
                                                  AppAssets.caretDownIcon,
                                                  width: 18.w,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            
                                ],
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
                                          : controller.onTap();
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

Future<CardModel?> bottomSheet(PaymentController controller) {
  return showModalBottomSheet<CardModel>(
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
                    final card = controller.cardBox.getAt(index);

                    return GestureDetector(
                      onTap: () {
                        controller.selectedCard = card;
                        controller.isTextNotEmpty();
                        Get.back(result: card);
                      },
                      child: Container(
                        color: AppColors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: controller.selectedCard == card,
                              side: BorderSide(width: 1.w, color: AppColors.black),
                              onChanged: (_) {
                                controller.selectedCard = card;
                                controller.isTextNotEmpty();
                                Get.back(result: card);
                              },
                            ),
                            SizedBox(width: AppDimensions.paddingSmall.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      card?.name ??
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
                                    if(card?.nickName != '')...[
                                      Text(
                                        '(${card?.nickName})',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.black,
                                          fontFamily: AppFonts.primaryFont,
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                                Text(
                                  controller.hideCardCenter(
                                    card
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
                    onPressed: () {
                      Get.toNamed(AddCardScreen.route);
                    },
                    child: Text(
                      r'add_a_card'.tr,
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
