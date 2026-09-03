import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/get_card/repository/card_repository.dart';
import 'package:senagat_mobile/src/features/get_card_details/controller/get_card_details_controller.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../loan/repository/location_repository.dart';
import '../../pay/presentation/payment_form_widgets.dart';

class GetCardDetailsScreen extends StatefulWidget {
  static const route = '/get/card/details';

  const GetCardDetailsScreen({super.key});

  @override
  State<GetCardDetailsScreen> createState() => _GetCardDetailsScreenState();
}

class _GetCardDetailsScreenState extends State<GetCardDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<GetCardDetailsController>(
          init: GetCardDetailsController(
            PaymentRepository(apiService: ApiServices.apiService),
            CardRepository(apiService: ApiServices.apiService),
            LocationRepository(apiService: ApiServices.apiService),
          ),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingExtraLarge.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.selectedCardTitle?.tr ?? '',
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: AppColors.blackText,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          CachedNetworkImage(
                            imageUrl:
                                controller.selectedCardImage ??
                                AppAssets.cardImage,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: AppDimensions.padding40.h),
                          Text(
                            r'details_for_obtaining'.tr,
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: AppColors.blackText,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          Text(
                            'work_phone'.tr,
                            style: TextStyle(
                              color: AppColors.blackText,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: AppDimensions.paddingMedium.h),
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
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                              SizedBox(width: AppDimensions.paddingSmall.w),
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: controller.workPhoneController,
                                  onChanged: (v) =>
                                      controller.onInformationNotEmpty(v),
                                  maxLength: 8,
                                  style: TextStyle(fontSize: 14.sp),
                                  decoration: InputDecoration(
                                    hintText: r'enter_number'.tr,
                                    border: OutlineInputBorder(),
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
                                        color: AppColors.white,
                                        width: 1.w,
                                      ),
                                    ),
                                    counter: const SizedBox(),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical:
                                          AppDimensions.paddingExtraLarge.h,
                                      horizontal: AppDimensions.paddingLarge.w,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),
                          Text(
                            r'bank_branch'.tr,
                            style: TextStyle(
                              color: AppColors.blackText,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: AppDimensions.paddingMedium),

                          DropdownButtonFormField2<int>(
                            value: controller.selectedDropdownBranch,
                            hint: Text(
                              r"bank_branch".tr,
                              style: TextStyle(fontSize: 14.sp),
                            ),

                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                0,
                                AppDimensions.paddingExtraLarge.w,
                                AppDimensions.paddingExtraLarge.w,
                                AppDimensions.paddingExtraLarge.h,
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium.r,
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
                            onChanged: (v) => controller.setDropdownBranch(v),
                            items: controller.branches
                                .map(
                                  (item) => DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Text(
                                      item.name,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(height: 22.h),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'job_title'.tr,
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: AppDimensions.paddingMedium.h),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                controller: controller.workPositionController,
                                onChanged: (v) =>
                                    controller.onInformationNotEmpty(v),
                                style: TextStyle(fontSize: 14.sp),
                                decoration: InputDecoration(
                                  hintText: 'job_title'.tr,
                                  border: const OutlineInputBorder(),
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
                                      color: AppColors.white,
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
                              SizedBox(height: 22.h),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email'.tr,
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: AppDimensions.paddingMedium.h),

                              TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                controller: controller.emailController,
                                onChanged: controller.onInformationNotEmpty,
                                style: TextStyle(fontSize: 14.sp),
                                decoration: InputDecoration(
                                  hintText: 'Email'.tr,
                                  border: const OutlineInputBorder(),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                                    borderSide: BorderSide(
                                      color: controller.emailError == null
                                          ? AppColors.green
                                          : AppColors.redDark,   // <--- error border
                                      width: 1.w,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                                    borderSide: BorderSide(
                                      color: controller.emailError == null
                                          ? AppColors.white
                                          : AppColors.redDark,   // <--- error border
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

                              SizedBox(height: 22.h),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'internet_service'.tr,
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: AppDimensions.paddingMedium.h),
                              GestureDetector(
                                onTap: () =>
                                    controller.onCheckBoxTap('internet'),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                    AppDimensions.paddingExtraLarge.w,
                                    AppDimensions.paddingSmall.h,
                                    AppDimensions.paddingSmall.h,
                                    AppDimensions.paddingSmall.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputFillBackground,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusMedium,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'internet_service'.tr,
                                        style: TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      Checkbox(
                                        side: BorderSide(width: 1.w),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                        value: controller.internetService,
                                        onChanged: (value) => controller
                                            .onCheckBoxTap('internet'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 22.h,
                              ),
                              Text(
                                'delivery'.tr,
                                style: TextStyle(
                                  color: AppColors.blackText,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: AppDimensions.paddingMedium.h),
                              GestureDetector(
                                onTap: () =>
                                    controller.onCheckBoxTap('delivery'),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                   AppDimensions.paddingExtraLarge.w,
                                   AppDimensions.paddingSmall.h,
                                   AppDimensions.paddingSmall.h,
                                   AppDimensions.paddingSmall.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputFillBackground,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusMedium,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'delivery'.tr,
                                        style: TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      Checkbox(
                                        side: BorderSide(width: 1.w),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                        value: controller.delivery,
                                        onChanged: (value) => controller.onCheckBoxTap('delivery'),
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),
                          Text(
                            'Onlaýn tölemek'.tr,
                            style: TextStyle(
                              color: AppColors.blackText,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: AppDimensions.paddingMedium.h),
                          GestureDetector(
                            onTap: (){
                              controller.requiredPayment = !controller.requiredPayment;
                              controller.onInformationNotEmpty('');
                              controller.update();
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                AppDimensions.paddingExtraLarge.w,
                                AppDimensions.paddingSmall.h,
                                AppDimensions.paddingSmall.h,
                                AppDimensions.paddingSmall.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.inputFillBackground,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(r'Onlaýn tölemek'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.grey,),),
                                  Checkbox(
                                    side: BorderSide(width: 1.w),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                    value: controller.requiredPayment,
                                    onChanged: (bool? newValue) {
                                      controller.requiredPayment = newValue ?? false;
                                      controller.onInformationNotEmpty('');
                                      controller.update();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if(controller.requiredPayment)...[
                            SizedBox(height: 22.h),

                            Text(
                              r'select_a_card'.tr,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.blackText,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            paymentCardPicker(controller),
                          ],
                          SizedBox(height: 22.h),
                          Text(
                            r'payment_amount'.tr,
                            style: TextStyle(
                              color: AppColors.blackText,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: AppDimensions.paddingMedium.h),
                          _priceSummary(controller),
                          SizedBox(height: 22.h),
                        ],
                      ),
                    ),
                  ),
                ),

                Opacity(
                  opacity: controller.continueEnabled ? 1 : 0.5,
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButtonWithState(
                        isLoading: controller.status == Status.loading,
                        isError: controller.status == Status.error,
                        onPressed: () => controller.onButtonTap(),
                        child: Text(
                          r'next'.tr,
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
            );
          },
        ),
      ),
    );
  }

  Widget _priceSummary(GetCardDetailsController controller) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
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
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
            child: Column(
              children: [
                _priceRow(
                  r'card_price'.tr,
                  controller.formatAmount(controller.cardPrice),
                ),
                if (controller.delivery) ...[
                  SizedBox(height: 12.h),
                  _priceRow(
                    r'delivery_price'.tr,
                    controller.formatAmount(controller.deliveryPrice),
                    prefix: '+',
                  ),
                ],
              ],
            ),
          ),
          if (controller.delivery) ...[
            Divider(color: AppColors.dividerColor, height: 1.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingExtraLarge.w,
                vertical: AppDimensions.paddingLarge.h,
              ),
              color: AppColors.inputFillBackground,
              child: _priceRow(
                r'total'.tr,
                controller.formatAmount(controller.displaySum),
                isTotal: true,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _priceRow(
    String label,
    String amount, {
    String? prefix,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              color: isTotal ? AppColors.blackText : AppColors.grey,
            ),
          ),
        ),
        Text(
          '${prefix ?? ''}$amount ${r'manat'.tr}',
          style: TextStyle(
            fontSize: isTotal ? 16.sp : 14.sp,
            color: isTotal ? AppColors.green : AppColors.blackText,
          ),
        ),
      ],
    );
  }
}
