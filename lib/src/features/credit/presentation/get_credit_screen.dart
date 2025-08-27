
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
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
                                  r'Получение кредита'.tr,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: AppColors.blackText,
                                  ),
                                ),
                                SizedBox(height: AppDimensions.padding40,),

                                Text('Выберите тип кредита', style: TextStyle(fontSize: 14.sp, color: AppColors.blackText),),
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
                                  child: DropdownButtonFormField<String>(
                                    value: controller.selectedDropdownValue,
                                    hint: Text(
                                      r"Тип кридита".tr,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    icon: SvgPicture.asset(
                                      AppAssets.caretDownIcon,
                                      width: 18.w,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppDimensions.paddingExtraLarge.h,
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
                                    )
                                        .toList(),
                                  ),
                                ),

                                SizedBox(height: AppDimensions.padding40,),

                                if(controller.continueEnabled)
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
                                        Text(r'Калькулятор'.tr,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.blackText,
                                          ),),
                                        SizedBox(height: AppDimensions.paddingMedium,),
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
                                            contentPadding: EdgeInsets.all(20),
                                          ),
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: AppColors.black
                                          ),
                                        ),
                                        SizedBox(height: AppDimensions.paddingMedium.h,),
                                        SliderTheme(
                                          data: SliderTheme.of(context).copyWith(
                                            thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 12,
                                              elevation: 0,
                                            ),
                                            overlayShape: RoundSliderOverlayShape(
                                              overlayRadius: 20,
                                            ),
                                            thumbSelector: (textDirection, values, tapValue, thumbSize, trackSize, dx) => Thumb.start,
                                            disabledThumbColor: AppColors.white,
                                            activeTrackColor: AppColors.green,
                                            inactiveTrackColor: Colors.green.shade100,
                                            trackHeight: 3,
                                            valueIndicatorStrokeColor: AppColors.green,
                                            valueIndicatorColor: AppColors.green,
                                          ),
                                          child: Slider(
                                            value: controller.currentValue,
                                            min: 1000,
                                            max: 20000,
                                            divisions: (20000 - 1000) ~/ 100,
                                            onChanged: (value) {
                                              controller.updateText(value);
                                            },
                                          ),
                                        ),

                                        Expanded(
                                          child: TabBarView(
                                            controller: controller.tabBarController,
                                            children: [
                                            Tab(text: 'a',),
                                            Tab(text: 'a',),
                                            Tab(text: 'a',),
                                          ],),
                                        )
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
                          onPressed: controller.continueEnabled
                              ? () {

                          }
                              : null,
                          child: Text(r'Далее'.tr),
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
