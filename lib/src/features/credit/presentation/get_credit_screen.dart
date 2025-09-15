import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/loan/presentation/loan_screen.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/get_credit_controller.dart';

class GetCreditScreen extends StatefulWidget {
  static const route = '/get/credit';
  const GetCreditScreen({super.key});

  @override
  State<GetCreditScreen> createState() => _GetCreditScreenState();
}

class _GetCreditScreenState extends State<GetCreditScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SafeArea(
        child: GetBuilder<GetCreditController>(
            init: GetCreditController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r'getting_a_loan'.tr,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: AppColors.blackText,
                                  ),
                                ),
                                SizedBox(height: AppDimensions.padding40,),

                                Text(r'select_loan_type'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.blackText),),
                                SizedBox(height: 16.h,),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: AppColors.inputFillBackground,
                                    cardTheme:  CardThemeData(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(AppDimensions.borderRadiusMedium.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: DropdownButtonFormField2<String>(
                                    value: controller.selectedDropdownValue,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(AppDimensions.paddingMedium.w, AppDimensions.paddingExtraLarge.w, AppDimensions.paddingExtraLarge.w, AppDimensions.paddingExtraLarge.h, ),
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r),

                                      ),
                                      elevation: 2,

                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: SvgPicture.asset(AppAssets.caretDownIcon, width: 18.w,),
                                    ),
                                    hint:  Text(
                                      r"loan_type".tr,
                                      style: TextStyle(fontSize: 14.sp, color: AppColors.greyInactive),
                                    ),
                                    onChanged: (v) => controller.setDropdownValue(v),
                                    items: controller.dropdownItems
                                        .map(
                                          (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      ),
                                    ).toList(),
                                  ),
                                ),

                                SizedBox(height: AppDimensions.padding40,),

                                if(controller.selectedDropdownValue != null)
                                  Container(
                                    padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                                    decoration: BoxDecoration(
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
                                        Text(r'calculator'.tr,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.blackText,
                                          ),
                                        ),
                                        SizedBox(height: AppDimensions.paddingMedium.h,),
                                        TextField(
                                          controller: controller.sumController,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            final parsed = double.tryParse(value.replaceAll(',', ''));
                                            if (parsed != null &&
                                                parsed >= 1000 &&
                                                parsed <= 20000) {
                                              controller.updateText(parsed);
                                            }
                                          },
                                          decoration: InputDecoration(
                                            suffixText: '20,000',
                                            prefixText: '1000',
                                            suffixStyle: TextStyle(
                                              color: AppColors.greyInactive,
                                              fontSize: 14.sp
                                            ),
                                            prefixStyle: TextStyle(
                                                color: AppColors.greyInactive,
                                                fontSize: 14.sp
                                            ),
                                            contentPadding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                                          ),
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: AppColors.black
                                          ),
                                        ),
                                        SizedBox(height: AppDimensions.paddingMedium.h,),
                                        FlutterSlider(
                                            values: [controller.currentValue],
                                            min: 1000,
                                            max: 20000,
                                            step: FlutterSliderStep(
                                              step: 100, // 👈 this replaces divisions
                                            ),
                                            tooltip: FlutterSliderTooltip(
                                              disabled: true,
                                            ),
                                            trackBar: FlutterSliderTrackBar(
                                              activeTrackBar: BoxDecoration(
                                                color: AppColors.green,
                                              ),
                                              inactiveTrackBar: BoxDecoration(
                                                color: AppColors.lightGreen
                                              )
                                            ),
                                            handlerWidth: 22,
                                            handlerHeight: 22,
                                            handler: FlutterSliderHandler(
                                              child: SvgPicture.asset(AppAssets.thumbIcon),

                                            ),
                                            onDragging: (handlerIndex, lowerValue, upperValue){
                                              controller.updateText(lowerValue);
                                            },
                                          ),
                                        SizedBox(height: AppDimensions.paddingExtraLarge.h,),
                                        Text(r'term'.tr,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.blackText,
                                          ),
                                        ),
                                        SizedBox(height: AppDimensions.paddingMedium.h,),
                                        DefaultTabController(
                                          length: 3,
                                          child: Container(
                                            height: 42.h,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                  AppDimensions.borderRadiusMedium.r,
                                                ),
                                              color: AppColors.lightGreen,
                                            ),
                                            child: TabBar(
                                              dividerHeight: 0,
                                              labelColor: AppColors.white,
                                              unselectedLabelColor: AppColors.white,
                                              labelStyle: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.primaryFont,),
                                              indicatorSize: TabBarIndicatorSize.tab,
                                              indicator: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                  AppDimensions.borderRadiusMedium.r,
                                                ),
                                                color: AppColors.blackText
                                              ),
                                              tabs: [
                                              Tab(text: r'1_year'.tr,),
                                              Tab(text: r'2_years'.tr,),
                                              Tab(text: r'3_years'.tr,),
                                            ],),
                                          ),
                                        ),
                                        SizedBox(height: AppDimensions.paddingExtraLarge.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 70.w,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(r'bid'.tr,
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: AppColors.blackText,
                                                    ),
                                                  ),
                                                  SizedBox(height: AppDimensions.paddingMedium,),
                                                  TextField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.digitsOnly, // allow only numbers
                                                    ],
                                                    controller: controller.bidController,
                                                    keyboardType: TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    onChanged: (v)=> controller.onTextIsNotEmpty(v),
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontFamily: AppFonts.primaryFont,
                                                    ),
                                                    decoration: InputDecoration(
                                                      hintText: r'bid'.tr,
                                                      border: OutlineInputBorder(),
                                                      suffixText: '%',
                                                      suffixStyle: TextStyle(color: AppColors.blackText),
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
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: AppDimensions.paddingMedium.h,),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(r'monthly_payment'.tr,
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: AppColors.blackText,
                                                    ),
                                                  ),
                                                  SizedBox(height: AppDimensions.paddingMedium,),
                                                  TextField(
                                                    controller: controller.paymentController,
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (v)=> controller.onTextIsNotEmpty(v),
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontFamily: AppFonts.primaryFont,
                                                    ),
                                                    decoration: InputDecoration(
                                                      hintText: r'monthly_payment'.tr,
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
                                                        vertical: AppDimensions.paddingExtraLarge.h,
                                                        horizontal: AppDimensions.paddingLarge.w,
                                                      ),
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
                          ),
                        ],
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
                          onPressed: controller.continueEnabled ? () {
                            Get.offAndToNamed(LoanScreen.route);
                          } : null,
                          child: Text(r'next'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.white),),
                        ),
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
