import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/core/globals.dart';
import 'package:senagat_mobile/src/features/pay/repository/payment_repository.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../../loan/repository/location_repository.dart';
import '../../pay/presentation/payment_form_widgets.dart';
import '../controller/inquiries_controller.dart';
import '../repository/inquiries_repository.dart';

class InquiriesScreen extends StatefulWidget {
  static const route = '/inquiries';

  const InquiriesScreen({super.key});

  @override
  State<InquiriesScreen> createState() => _InquiriesScreenState();
}

class _InquiriesScreenState extends State<InquiriesScreen> {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<InquiriesController>(
          init: InquiriesController(
            PaymentRepository(apiService: ApiServices.apiService),
            InquiriesRepository(apiService: ApiServices.apiService),
            LocationRepository(apiService: ApiServices.apiService),
            _key,
          ),
          builder: (controller) {
            return controller.status == Status.loading
                ? Center(
                    child: CircularProgressIndicator(color: AppColors.green),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [

                              CustomAppBar(),

                              Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        AppDimensions.paddingExtraLarge.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r'get_inquiries'.tr,
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: AppColors.blackText,
                                        ),
                                      ),
                                      SizedBox(height: 16.h),

                                      SizedBox(
                                        height: AppDimensions.paddingMedium,
                                      ),
                                      DropdownButtonFormField2<String>(
                                        value: controller.selectedDropdownType,
                                        hint: Text(
                                          r"type_of_certificate".tr,
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
                                            AppDimensions.paddingExtraLarge.h,
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
                                            controller.setDropdownType(v),
                                        items: controller.inquiries
                                            .map(
                                              (item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item.title,
                                                    child: Text(
                                                      item.title!.tr,
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                  ),
                                            )
                                            .toList(),
                                      ),

                                    ],
                                  ),
                                ),
                              if (controller.isDropdownSelected)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        AppDimensions.paddingExtraLarge.w,
                                    vertical:
                                    AppDimensions.paddingExtraLarge.w,

                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        r'bank_branch'.tr,
                                        style: TextStyle(
                                          color: AppColors.blackText,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: AppDimensions.paddingMedium,
                                      ),

                                      DropdownButtonFormField2<int>(
                                        value: controller.selectedDropdownBranch,
                                        hint: Text(
                                          r"bank_branch".tr,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontFamily: AppFonts.primaryFont,
                                            color: AppColors.greyInactive,
                                          ),
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
                                            controller.setDropdownBranch(v),
                                        items: controller.branches
                                            .map(
                                              (item) =>
                                                  DropdownMenuItem<int>(
                                                    value: item.id,
                                                    child: Text(
                                                      item.name,
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
                                        r'home_address'.tr,
                                        style: TextStyle(
                                          color: AppColors.blackText,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: AppDimensions.paddingMedium.h,
                                      ),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.name,
                                        controller:
                                            controller.addressController,
                                        onChanged: (v) =>
                                            controller.onInformationNotEmpty(v),
                                        style: TextStyle(fontSize: 14.sp),
                                        decoration: InputDecoration(
                                          hintText: r'home_address'.tr,
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
                                            vertical: AppDimensions
                                                .paddingExtraLarge
                                                .h,
                                            horizontal:
                                                AppDimensions.paddingLarge.w,
                                          ),
                                        ),
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
                                          controller.onInformationNotEmpty(controller.requiredPayment);
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
                                                    controller.onInformationNotEmpty(newValue);
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

                                      ]

                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      Opacity(
                        opacity: controller.continueEnabled ? 1 : 0.5,
                        child: Padding(
                          padding: EdgeInsets.all(
                            AppDimensions.paddingExtraLarge.w,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButtonWithState(
                              isLoading: controller.status == Status.loading,
                              isError: controller.status == Status.error,
                              onPressed: () {
                                controller.onTap();
                              },
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
}
