import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/states/stateful_data.dart';
import 'package:senagat_mobile/src/features/add_card/controller/add_card_controller.dart';
import 'package:senagat_mobile/src/features/add_card/model/bank_model.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/check_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../../widgets/text_input_masks.dart';

class AddCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddCardController());
  }
}

class AddCardScreen extends StatelessWidget {
  static const route = r'/add/card';

  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final controller = Get.find<AddCardController>();
        controller.deleteAddController();
        controller.selectedDropdownBank = null;
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: GetBuilder<AddCardController>(
            builder: (controller) {
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap:(){
                          final controller = Get.find<AddCardController>();
                          controller.deleteAddController();
                          controller.selectedDropdownBank = null;
                          Get.back();
                          },
                        child: Container(
                          padding: EdgeInsets.all(AppDimensions.paddingMedium),
                          margin: EdgeInsets.all(AppDimensions.paddingExtraLarge),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: AppColors.greyInactive,
                                width: 1.w,
                                style: BorderStyle.solid,
                              ),
                              color: AppColors.white
                          ),
                          child: SvgPicture.asset(AppAssets.arrowLeftIcon, width: 20.w),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              buildCardSection(controller),

                              SizedBox(height: 26.h),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingExtraLarge.w,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r'card_details'.tr,
                                      style: TextStyle(
                                        color: AppColors.blackText,
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                    SizedBox(height: 22.h),
                                    Text(
                                      r'select_bank'.tr,
                                      style: TextStyle(
                                        color: AppColors.blackText,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppDimensions.paddingMedium.h,
                                    ),
                                    DropdownButtonFormField2<BankModel>(
                                      value: controller.selectedDropdownBank,
                                      isExpanded: true,
                                      hint: Text(
                                        r"select_bank".tr,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.greyInactive,
                                        ),
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(
                                          0,
                                          AppDimensions.paddingExtraLarge.w,
                                          AppDimensions.paddingExtraLarge.w,
                                          AppDimensions.paddingMedium,
                                        ),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions
                                                .borderRadiusMedium
                                                .r,
                                          ),
                                        ),
                                        elevation: 2,
                                      ),
                                      iconStyleData: IconStyleData(
                                        icon: SvgPicture.asset(
                                          AppAssets.caretDownIcon,
                                          width: 18.w,
                                        ),
                                      ),
                                      onChanged: (v) =>
                                          controller.setDropdownBank(v),
                                      items: controller.bankList
                                          .map(
                                            (item) =>
                                            DropdownMenuItem<BankModel>(
                                              value: item,
                                              child: Text(
                                                item.name.tr,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                      )
                                          .toList(),
                                    ),
                                    SizedBox(height: 22.h),

                                    Text(
                                      r'card_number'.tr,
                                      style: TextStyle(
                                        color: AppColors.blackText,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppDimensions.paddingMedium.h,
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      onChanged: controller.onTextChanged,
                                      controller: controller.cardNumberController,
                                      inputFormatters: [
                                        controller.cardNumberFormatter,
                                      ],
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: AppFonts.primaryFont,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: r'card_number'.tr,
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.borderRadiusMedium,
                                          ),
                                          borderSide: BorderSide(
                                            color: controller.isValidCardNumber(controller.cardNumberController.text)? AppColors.green : AppColors.redDark,
                                            width: 1.w,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.borderRadiusMedium,
                                          ),
                                          borderSide: BorderSide(
                                            color: controller.isValidCardNumber(controller.cardNumberController.text)? AppColors.white : AppColors.redDark,
                                            width: 1.w,
                                          ),
                                        ),
                                        suffixIconConstraints: BoxConstraints(
                                          maxHeight: 40.h,
                                          maxWidth: 40.w,
                                        ),
                                        suffixIcon:
                                            controller
                                                .cardNumberController
                                                .text
                                                .isNotEmpty
                                            ? GestureDetector(
                                                onTap: () {
                                                  controller.onClearTextField(
                                                    controller
                                                        .cardNumberController,
                                                  );
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    right: AppDimensions
                                                        .paddingExtraLarge
                                                        .w,
                                                  ),
                                                  child: SvgPicture.asset(
                                                    AppAssets.deleteIcon,
                                                    width: 18.w,
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                              )
                                            : null,
                                        counter: const SizedBox(),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical:
                                              AppDimensions.paddingExtraLarge.h,
                                          horizontal:
                                              AppDimensions.paddingLarge.w,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 22.h),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r'name_on_the_card'.tr,
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
                                        TextField(
                                          keyboardType:
                                          TextInputType.text,
                                          textCapitalization: TextCapitalization.characters,
                                          controller:
                                          controller.nameController,
                                          onChanged: (value) =>
                                              controller.update(),
                                          inputFormatters: [
                                            TextInputFormatter.withFunction((oldValue, newValue) {
                                              return newValue.copyWith(
                                                text: newValue.text.toUpperCase(),
                                              );
                                            }),
                                          ],
                                          textInputAction:
                                          TextInputAction.next,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontFamily:
                                            AppFonts.primaryFont,
                                          ),
                                          decoration: InputDecoration(
                                            hintText:
                                            r'name_on_the_card'.tr,
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
                                            suffixIconConstraints:
                                            BoxConstraints(
                                              maxHeight: 40.h,
                                              maxWidth: 40.w,
                                            ),
                                            suffixIcon:
                                            controller
                                                .nameController
                                                .text
                                                .isNotEmpty
                                                ? GestureDetector(
                                              onTap: () {
                                                controller
                                                    .onClearTextField(
                                                  controller
                                                      .nameController,
                                                );
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: AppDimensions
                                                      .paddingExtraLarge
                                                      .w,
                                                ),
                                                child: SvgPicture.asset(
                                                  AppAssets
                                                      .deleteIcon,
                                                  width: 18.w,
                                                  color: AppColors
                                                      .black,
                                                ),
                                              ),
                                            )
                                                : null,
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
                                      ],
                                    ),
                                    SizedBox(height: 22.h),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  r'term'.tr,
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
                                                TextField(
                                                  controller:
                                                      controller.termController,
                                                  onChanged:
                                                      controller.onTextChanged,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  maxLength: 5,
                                                  inputFormatters: [
                                                    ExpiryDateFormatter(),
                                                  ],
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily:
                                                        AppFonts.primaryFont,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: r'**/**',
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
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: AppDimensions.paddingMedium.h,
                                          ),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  r'CVC'.tr,
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
                                                  TextInputType.phone,
                                                  obscureText: true,
                                                  controller:
                                                      controller.cvcController,
                                                  onChanged:
                                                      controller.onTextChanged,
                                                  maxLength: 3,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily:
                                                        AppFonts.primaryFont,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: r'CVC'.tr,
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
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: controller.continueEnabled ? 1.0 : 0.5,
                        child: Padding(
                          padding: EdgeInsets.all(
                            AppDimensions.paddingExtraLarge,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButtonWithState(
                              isLoading: false,
                              isError: false,
                              onPressed: () {
                                if (controller.continueEnabled) {
                                  controller.startBankVerification();
                                }
                              },
                              child: Text(
                                r'confirm'.tr,
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
                  if (controller.check)
                    CheckWidget(
                      isLoading: controller.status == Status.loading,
                      isTitle: true,
                      title: r'adding_a_card'.tr, successTitle: 'verification_was_successful',
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
  Widget buildCardSection(AddCardController controller) {

    final cardNumber = controller.cardNumberController.text.replaceAll(' ', '');
    final prefix6 = cardNumber.length >= 6 ? cardNumber.substring(0, 6) : '';


    final prefixToIndex = {
      '993470': 0,
      '993407': 0,
      '993420': 0,
      '993402': 0,
      '993471': 0,
      '993421': 0,
      '993472': 0,
      '993473': 1,
      '993474': 2,
      '993475': 3,
    };
    int? senagatIndex = prefixToIndex[prefix6];


    if (senagatIndex != null) {
      return Container(
        padding: EdgeInsets.all(
          AppDimensions.paddingExtraLarge,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppDimensions.marginMedium,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppDimensions.borderRadiusMedium.r,
          ),
          image: DecorationImage(
            image: AssetImage(
              controller.cardDesigns2[senagatIndex],
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100.h),
            Padding(
              padding: EdgeInsets.only(left: 23.w, top: 20.h),
              child: Text(
                controller.maskedCardNumber,
                style: TextStyle(
                  wordSpacing: 10.sp,
                  fontSize: 24.sp,
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(height: 35.h),
            Padding(
              padding: EdgeInsets.only(left: 23.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.nameController.text.isNotEmpty
                        ? controller.nameController.text.toUpperCase()
                        : r'name_on_the_card'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    controller.termController.text.isNotEmpty
                        ? controller.termController.text
                        : r'term'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {

      return Column(
        children: [
          SizedBox(
            height: 240.h,
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: controller.cardDesigns.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: 220.h,
                  padding: EdgeInsets.all(
                    AppDimensions.paddingExtraLarge,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: AppDimensions.marginMedium,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium.r,
                    ),
                    image: DecorationImage(
                      image: AssetImage(controller.cardDesigns[index]),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          controller.cardName.tr,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      // SizedBox(height: 72.h),
                      Text(
                        controller.maskedCardNumber,
                        style: TextStyle(
                          wordSpacing: 10.sp,
                          fontSize: 24.sp,
                          color: AppColors.white,
                        ),
                      ),
                      // SizedBox(height: 41.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.nameController.text.isNotEmpty
                                ? controller.nameController.text.toUpperCase()
                                : r'name_on_the_card'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            controller.termController.text.isNotEmpty
                                ? controller.termController.text
                                : r'term'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),
          Center(
            child: SmoothPageIndicator(
              count: controller.cardDesigns.length,
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
      );
    }
  }

}
