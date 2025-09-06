import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/service_numbers/controller/service_number_controller.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';

import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';

class ServiceNumberScreen extends StatefulWidget {
  static const route = '/service/numbers';
  const ServiceNumberScreen({super.key});

  @override
  State<ServiceNumberScreen> createState() => _ServiceNumberScreenState();
}

class _ServiceNumberScreenState extends State<ServiceNumberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GetBuilder<ServiceNumberController>(
            init: ServiceNumberController(),
            builder: (controller) {
              return Column(
                children: [
                  CustomAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r'Учетные записи'.tr, style: TextStyle(fontSize: 24.sp, color: AppColors.black),),
                            SizedBox(height: 32.h,),
                            ListView.builder(
                              itemCount: 6,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(controller.serviceNames[index], style: TextStyle(fontSize: 24.sp, color: AppColors.black),),
                                        SizedBox(height: 16.sp,),
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
                                              Text(r'Гос номер'.tr, style: TextStyle(fontSize: 14.sp, color: AppColors.blackText,),),
                                              SizedBox(height: 10.h,),
                                              Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    TextFormField(
                                                      textInputAction: TextInputAction.next,
                                                      keyboardType: TextInputType.name,
                                                      controller: controller.controllers[index],
                                                      onChanged:(v) => controller.onTextIsNotEmpty(v,index),
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                      ),
                                                      decoration: InputDecoration(
                                                        hintText: r'number'.tr,
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
                                                    if(controller.controllers[index].text.isNotEmpty)
                                                      Column(
                                                      children: [
                                                        SizedBox(height: 16.h,),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: AppDimensions.paddingMedium.w),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(AppDimensions.paddingMedium.r),
                                                              color: AppColors.green
                                                          ),
                                                          child: Text(r'Сохранить'.tr, style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.secondaryFont, color: AppColors.white),),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          )
      ),
    );
  }
}
