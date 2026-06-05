import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/add_card/model/card_model.dart';
import 'package:senagat_mobile/src/features/add_card/presentation/add_card_screen.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/model/alem_get_tariff_model.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/elevated_button_with_state.dart';

import '../controller/alem_payment_controller.dart';

Future<CardModel?> showPaymentCardBottomSheet(PaymentController controller) {
  return showModalBottomSheet<CardModel>(
    isScrollControlled: true,
    context: Get.context!,
    backgroundColor: AppColors.white,
    builder: (_) {
      List<CardModel?> cards = controller.cardBox.values.toList();

      if (controller.isFoundation == false) {
        cards = cards.where((c) => c?.bank != 'rysgal').toList();
      }

      if (controller.isInquiries == false) {
        cards = cards.where((c) => c?.bank == 'senagat').toList();
      }
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
                  itemCount: cards.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final card = cards[index];

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
                              side: BorderSide(
                                width: 1.w,
                                color: AppColors.black,
                              ),
                              onChanged: (_) {
                                controller.selectedCard = card;
                                controller.isTextNotEmpty();
                                Get.back(result: card);
                              },
                            ),
                            SizedBox(width: AppDimensions.paddingSmall.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        card?.name ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.black,
                                          fontFamily: AppFonts.primaryFont,
                                        ),
                                      ),
                                      if (card?.nickName != null &&
                                          card!.nickName.isNotEmpty) ...[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: AppDimensions
                                                    .paddingSmall
                                                    .w,
                                              ),
                                              Text(
                                                '(${card.nickName.tr})',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors.black,
                                                  fontFamily:
                                                      AppFonts.primaryFont,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    controller.hideCardCenter(
                                      card?.cardNumber ?? '',
                                    ),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.black,
                                      fontFamily: AppFonts.secondaryFont,
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

Future<PaymentOption?> showAlemTariffBottomSheet(
    PaymentController controller,
    List<PaymentOption> paymentOptions,
    ) {
  return showModalBottomSheet<PaymentOption>(
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
          height: MediaQuery.of(Get.context!).size.height /2,
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
                    'select_tariff'.tr,
                    style: TextStyle(fontSize: 17.sp, color: AppColors.black),
                  ),
                ),

                SizedBox(height: 22.h),

                Flexible(
                  child: ListView.builder(
                    itemCount: paymentOptions.length,
                    itemBuilder: (context, index) {
                      final option = paymentOptions[index];

                      return GestureDetector(
                        onTap: () {
                          controller.selectedPaymentOption = option;
                          controller.isTextNotEmpty();
                          Get.back(result: option);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: Row(
                            children: [
                              Checkbox(
                                value: controller.selectedPaymentOption == option,
                                onChanged: (_) {
                                  controller.selectedPaymentOption = option;
                                  controller.isTextNotEmpty();
                                  Get.back(result: option);
                                },
                              ),

                              SizedBox(width: 10.w),

                              Expanded(
                                child: Text(
                                  "${option.months} ${'month'.tr} - ${option.amount} TMT",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 5.h),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget paymentAccountWidget(PaymentController controller) {
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
                    '${controller.formattedBalance} ${r'manat'.tr}',
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

Widget alemStatusWidget(PaymentController controller) {
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
                    controller.tariff?.tarif ?? '',
                    style: TextStyle(color: AppColors.green, fontSize: 17.sp),
                  ),
                  Text(
                    controller.tariff?.end ?? '',
                    style: TextStyle(
                      color: AppColors.greyInactive,
                      fontSize: 14.sp,
                    ),
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

Widget paymentPhoneField(PaymentController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        r'phone_number'.tr,
        style: TextStyle(
          color: AppColors.blackText,
          fontSize: 14.sp,
        ),
      ),
      SizedBox(height: 16.h),
      Row(
          children: [
            Container(
              padding: EdgeInsets.all(
                AppDimensions.paddingExtraLarge.w,
              ),
              decoration: BoxDecoration(
                color: AppColors.inputFillBackground,
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
              ),
              child: Text(
                '+993',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(width: AppDimensions.paddingSmall.w),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: controller.phoneController,
                onChanged: (_) => controller.isTextNotEmpty(),
                focusNode: controller.phoneFocus,
                maxLength: 8,
                readOnly: controller.serviceName != 'charitable_foundation' ? true : false,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: AppFonts.primaryFont,
                ),
                decoration: InputDecoration(
                  hintText: r'enter_number'.tr,
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium,
                    ),
                    borderSide: BorderSide(
                      color: controller.status == Status.error
                          ? AppColors.redDark
                          : AppColors.green,
                      width: 1.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium,
                    ),
                    borderSide: BorderSide(
                      color: controller.status == Status.error
                          ? AppColors.redDark
                          : AppColors.transparent,
                      width: 1.w,
                    ),
                  ),
                  counter: const SizedBox(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingExtraLarge.h,
                    horizontal: AppDimensions.paddingLarge.w,
                  ),
                  suffixIcon: controller.serviceName == 'charitable_foundation' ? IconButton(
                    icon: Icon(
                      Icons.contacts,
                      color: AppColors.green,
                      size: 20.w,
                    ),
                    onPressed: () async {
                      controller.contactPicker();
                    },
                  ): null,
                ),
              ),
            ),
          ],
        ),
      SizedBox(height: 22.h),
    ],
  );
}

Widget paymentSumField(PaymentController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        r'sum'.tr,
        style: TextStyle(
          color: AppColors.blackText,
          fontSize: 14.sp,
        ),
      ),
      SizedBox(height: 16.h),
      TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.sumController,
        onChanged: (_) {
          controller.selectedBeletIndex = null;
          controller.isTextNotEmpty();
          controller.update();
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          hintText: r'enter_sum'.tr,
          fillColor: AppColors.inputFillBackground,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusMedium,
            ),
            borderSide: BorderSide(
              color: AppColors.green,
              width: 1.w,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusMedium,
            ),
            borderSide: BorderSide(
              color: controller.isOtherSelected ? AppColors.green : AppColors.white,
              width: 1.w,
            ),
          ),
          counter: const SizedBox(),
          contentPadding: EdgeInsets.symmetric(
            vertical: AppDimensions.paddingExtraLarge.h,
            horizontal: AppDimensions.paddingLarge.w,
          ),
        ),
      ),
    ],
  );
}

Widget alemPaymentField(PaymentController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            r'alem_number'.tr,
            style: TextStyle(
              color: AppColors.blackText,
              fontSize: 14.sp,
            ),
          ),

          GetBuilder<PaymentController>(
            id: 'alem_loading',
            init: controller,
            global: false,
            builder: (c) {
              if (!c.isTariffLoading) {
                return const SizedBox();
              }

              return SizedBox(
                width: 15.w,
                height: 15.h,
                child: CircularProgressIndicator(
                  color: AppColors.green,
                ),
              );
            },
          ),
        ],
      ),
      SizedBox(height: 16.h),
      TextFormField(
        keyboardType: TextInputType.text,
        controller: controller.alemAccountController,
        onChanged: (value) {
          final isDeleting = value.length < controller.previousValue.length;

          if (!isDeleting &&
              value.length == 1 &&
              !RegExp(r'^[0-9]$').hasMatch(value)) {
            controller.alemAccountController.value = const TextEditingValue(
              text: 'dalem-',
              selection: TextSelection.collapsed(offset: 6),
            );
          }

          controller.previousValue = controller.alemAccountController.text;

          controller.onAlemChanged(value);
        },
        style: TextStyle(
          fontSize: 14.sp,
          fontFamily: AppFonts.primaryFont,
        ),
        decoration: InputDecoration(
          hintText: r'dalem-xxxx | 2100xxxx',
          fillColor: AppColors.inputFillBackground,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusMedium,
            ),
            borderSide: BorderSide(
              color: AppColors.green,
              width: 1.w,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusMedium,
            ),
            borderSide: BorderSide(
              color: controller.isOtherSelected ? AppColors.green : AppColors.white,
              width: 1.w,
            ),
          ),
          counter: const SizedBox(),
          contentPadding: EdgeInsets.symmetric(
            vertical: AppDimensions.paddingExtraLarge.h,
            horizontal: AppDimensions.paddingLarge.w,
          ),
        ),
      ),
    ],
  );
}

Widget paymentCardPicker(PaymentController controller) {
  if (controller.cardBox.isNotEmpty) {
    return GestureDetector(
      onTap: () async {
        await showPaymentCardBottomSheet(controller);
      },
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.inputFillBackground,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                controller.selectedCard == null
                    ? 'select_a_card'.tr
                    : '${controller.hideCardCenter(controller.selectedCard!.cardNumber)}  ${controller.selectedCard!.name}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: controller.selectedCard == null
                      ? AppColors.grey
                      : AppColors.black,
                ),
              ),
            ),
            SvgPicture.asset(
              AppAssets.caretDownIcon,
              width: 18.w,
            ),
          ],
        ),
      ),
    );
  }

  return GestureDetector(
    onTap: () => Get.toNamed(AddCardScreen.route),
    child: Container(
      width: MediaQuery.of(Get.context!).size.width,
      padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
      decoration: BoxDecoration(
        color: AppColors.inputFillBackground,
        borderRadius: BorderRadius.circular(
          AppDimensions.borderRadiusMedium.r,
        ),
      ),
      child: SvgPicture.asset(
        AppAssets.plusIcon,
        color: AppColors.black,
        width: 24.w,
      ),
    ),
  );
}

Widget alemTariffPicker(PaymentController controller) {
  final selected = controller.selectedPaymentOption;

  return Padding(
    padding:  EdgeInsets.symmetric(vertical: 22.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          r'select_tariff'.tr,
          style: TextStyle(color: AppColors.blackText, fontSize: 14.sp),
        ),
        SizedBox(height: AppDimensions.paddingMedium.h),

        GestureDetector(
          onTap: () async {
            if (controller.tariff == null ||
                controller.tariff!.paymentOptions.isEmpty) {
              return;
            }

            final result = await showAlemTariffBottomSheet(
              controller,
              controller.tariff!.paymentOptions,
            );

            if (result != null) {
              controller.selectedPaymentOption = result;
              controller.isTextNotEmpty();
            }
          },
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.inputFillBackground,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${selected?.months} ${'month'.tr} - ${selected?.amount} TMT",

                    style: TextStyle(
                      fontSize: 14.sp,
                      color: selected == null
                          ? AppColors.grey
                          : AppColors.black,
                    ),
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
  );
}

Widget pyggVideoFields(PaymentController controller) {
  // NOTE: This widget mirrors the existing Pygg fields from the previous
  // unified payment screen, keeping current controllers/validation behavior.
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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

Widget pyggDecisionFields(PaymentController controller) {
  // NOTE: Same as the previous unified payment screen.
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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
            onChanged: (_) => controller.isTextNotEmpty(),
            style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont),
            decoration: InputDecoration(
              hintText: r'enter_name'.tr,
              border: const OutlineInputBorder(),
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

