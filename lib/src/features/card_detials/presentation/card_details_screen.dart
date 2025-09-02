import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/card_detials/controller/card_details_controller.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';

import '../../../utils/theme/constants/app_colors.dart';

class CardDetailsScreen extends StatefulWidget {
  static const route = r'/card/detail';
  const CardDetailsScreen({super.key});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
          child: GetBuilder<CardDetailsController>(
            init: CardDetailsController(),
            builder: (context) {
              return Column(
                children: [
                  CustomAppBar(),
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge.w, vertical: AppDimensions.paddingMedium.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r'Реквизиты карты'.tr, style: TextStyle(color: AppColors.black, fontSize: 24.sp),),
                            SizedBox(height: AppDimensions.padding40,),
                            Text(r'Номер карты'.tr, style: TextStyle(color: AppColors.black, fontSize: 14.sp),),
                            SizedBox(height: 10.h,),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: AppColors.inputFillBackground
                              ),
                              child: Text(r'3576 1239 1234 0689'.tr, style: TextStyle(color: AppColors.black, fontSize: 14.sp),),
                            ),
                            SizedBox(height: 22.h,),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r'Имя на карте'.tr, style: TextStyle(color: AppColors.black, fontSize: 14.sp),),
                                    SizedBox(height: 10.h,),
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          color: AppColors.inputFillBackground
                                      ),
                                      child: Text(r'Mergen Jumayew'.tr, style: TextStyle(color: AppColors.black, fontSize: 14.sp),),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 11.w,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r'Срок'.tr, style: TextStyle(color: AppColors.black, fontSize: 14.sp),),
                                    SizedBox(height: 10.h,),
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          color: AppColors.inputFillBackground
                                      ),
                                      child: Text(r'11/27'.tr, style: TextStyle(color: AppColors.black, fontSize: 14.sp),),
                                    ),
                                  ],
                                ),

                              ],
                            )
                          ],
                        ),
                      )
                  ),
                ],
              );
            }
          ),
      ),
    );
  }
}
