import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/information_for_inquiries.dart';

class InformationForInquiries extends StatefulWidget {
  static const route = '/info/inquiries';
  const InformationForInquiries({super.key});

  @override
  State<InformationForInquiries> createState() => _InformationForInquiriesState();
}

class _InformationForInquiriesState extends State<InformationForInquiries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<InformationForInquiriesController>(
            init: InformationForInquiriesController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomAppBar(),
                              Padding(
                                padding: EdgeInsets.only(right: AppDimensions.paddingExtraLarge, top: 22),
                                child: Align(alignment: Alignment.bottomRight,child: Text(r'Шаг 3 из 4'.tr, style: TextStyle(fontSize: 14.sp), )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r'Информация для справки'.tr,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: AppColors.blackText,
                                  ),
                                ),
                                SizedBox(height: 32.h,),
                                Text(r'Филиал банка'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                SizedBox(height: AppDimensions.paddingMedium,),

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
                                    hint: Text(r"Филиал банка".tr, style: TextStyle(
                                      fontSize: 14.sp,),
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
                                        child: Text(item, style: TextStyle(
                                          fontSize: 14.sp,
                                        ),),
                                      ),
                                    ).toList(),
                                  ),
                                ),

                                SizedBox(height: 22.h,),


                                Text(r'Домашний адрес'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                SizedBox(height: AppDimensions.paddingMedium.h,),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  controller: controller.addressController,
                                  onChanged:(v) => controller.onTextIsNotEmpty(v),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: r'Домашний адрес'.tr,
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

                                SizedBox(height: 22.h,),

                                Text(r'phone_number'.tr, style: TextStyle(color: AppColors.blackText,fontSize: 14.sp),),
                                SizedBox(height: AppDimensions.paddingMedium.h,),
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
                                        controller: controller.phoneController,
                                        onChanged:(v) => controller.onTextIsNotEmpty(v),
                                        maxLength: 8,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                        ),
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
                                            vertical: AppDimensions.paddingExtraLarge.h,
                                            horizontal: AppDimensions.paddingLarge.w,
                                          ),
                                        ),
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
                  ),

                  Opacity(
                    opacity: controller.continueEnabled ? 1 : 0.5,
                    child: Padding(
                      padding:  EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButtonWithState(
                          isLoading: controller.status == Status.loading,
                          isError: controller.status == Status.error,
                          onPressed:() {
                            if(controller.continueEnabled) {
                              Get.toNamed(InformationForInquiries.route);
                            }
                          },
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
