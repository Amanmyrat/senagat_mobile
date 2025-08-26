import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/pay/presentation/payment_screen.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../../../widgets/elevated_button_with_state.dart';
import '../controller/foundation_controller.dart';

class FoundationScreen extends StatefulWidget {
  static const route = '/foundation';

  const FoundationScreen({super.key});

  @override
  State<FoundationScreen> createState() => _FoundationScreenState();
}

class _FoundationScreenState extends State<FoundationScreen> {

  BoxDecoration boxDecoration = BoxDecoration(
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
  );

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
          child: GetBuilder<FoundationController>(
              init: FoundationController(),
              builder: (controller) => Column(
                children: [
                  CustomAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge, vertical: AppDimensions.paddingExtraLarge.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              decoration: boxDecoration,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(AppAssets.glowingObjectIcon,),
                                  Text(
                                    r'charitable_foundation'.tr,
                                    style: TextStyle(
                                      color: AppColors.blackText,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  SizedBox(height: AppDimensions.paddingMedium.h),
                                  Text(
                                    r'fund_text'.tr,
                                    style: TextStyle(
                                      color: AppColors.blackText,
                                      fontSize: 14.sp,
                                      fontFamily: AppFonts.secondaryFont,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppDimensions.padding40.h),
                            Text(
                              r'fund_balance'.tr,
                              style: TextStyle(
                                color: AppColors.blackText,
                                fontSize: 17.sp,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Container(
                              width: MediaQuery.of(context).size.width.w,
                              padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                              decoration: boxDecoration,
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
                                          '40,681,013',
                                          style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 24.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(color: AppColors.dividerColor,height: 50,width: 1,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '+17,2%',
                                          style: TextStyle(
                                            color: AppColors.green,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        Text(
                                          '2,681,013',
                                          style: TextStyle(
                                            color: AppColors.blackText,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Container(
                                  padding:EdgeInsets.all(AppDimensions.paddingMedium.w) ,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white,
                                    border: Border.all(color: AppColors.dividerColor,style: BorderStyle.solid)
                                  ),
                                  child: SvgPicture.asset(AppAssets.linkIcon, color: AppColors.black,),
                                ),
                                SizedBox(width: AppDimensions.paddingMedium.w),
                                Text(
                                  'https://senagatbank.com.tm/goyum/cagalar',
                                  style: TextStyle(
                                    color: AppColors.blackText,
                                    fontSize: 14.sp,
                                    fontFamily: AppFonts.secondaryFont,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppDimensions.padding40.h),

                            if(controller.payBox.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r'your_help_to_the_fund'.tr,
                                    style: TextStyle(
                                      color: AppColors.blackText,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Container(
                                    width: MediaQuery.of(context).size.width.w,
                                    padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium.h, horizontal: AppDimensions.paddingExtraLarge.w),
                                    decoration: boxDecoration,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: controller.payBox.length,
                                      itemBuilder: (context,index){
                                        return Container(
                                          margin: EdgeInsets.symmetric(vertical: 5.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '5 Авг',
                                                style: TextStyle(
                                                    color: AppColors.greyInactive,
                                                    fontSize: 14.sp,
                                                    fontFamily: AppFonts.secondaryFont
                                                ),
                                              ),
                                              SizedBox(width: AppDimensions.paddingMedium.w),
                                              Text(
                                                controller.payBox.getAt(index)?.userName ?? '',
                                                style: TextStyle(
                                                  color: AppColors.blackText,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.payBox.getAt(index)?.sum ?? '',
                                                  style: TextStyle(
                                                    color: AppColors.green,
                                                    fontSize: 14.sp,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButtonWithState(
                          isLoading: false,
                          isError: false,
                          onPressed: (){
                            Get.offNamed(PaymentScreen.route, arguments: {
                              'selectedServiceTitle': r'charitable_foundation'.tr,
                            });
                          },
                          child: Text(r'donate'.tr),
                        ),
                      ),
                    ),
                  ),
                ],
              )
          )
      ),
    );
  }
}
